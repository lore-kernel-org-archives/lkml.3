Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaA3OQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:16:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61668 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaA3OQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:16:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [RFC PATCH V3 1/4] pci: APM X-Gene PCIe controller driver
Date: Thu, 30 Jan 2014 15:16:26 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@apm.com, jcm@redhat.com
References: <1390599168-13150-1-git-send-email-tinamdar@apm.com> <1390599168-13150-2-git-send-email-tinamdar@apm.com>
In-Reply-To: <1390599168-13150-2-git-send-email-tinamdar@apm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401301516.27091.arnd@arndb.de>
X-Provags-ID: V02:K0:dy59V8ceAMGqhNuPUli2jtg69fvX5YBDJW/BNnRIfCl
 P/5ihMHcmoIrzfRkp+Bdltz6LVnWLdmgfHqq6AWw6TBqCXyAEe
 Vun/UjZ8UD+yf5GS88o+kQDq9ll29NUGUZMsRIAQLK1uhfzqGl
 TEKm2SHt/b2XvDc7JTgvT9/6u2xCLA30URQelJuPcBgHqnudqr
 N4+RsjYBgkZmNR3gHeay5O6WTTBJSi8NoI9yPA3st6UJFfR4Mq
 Z1dlNL5sZBFIhYSEeOcMLQhZlhXWQq1Y6zVbNxdu56eHnw+JOi
 3PBxoXSfxRiJQzoX1dOQjQV2qGawgIvh/6Mx6nbEXt8Z1tHIyT
 bKPK1IKZe/JCmJJvrTwxoAvyKxsD6lZZmT1XR76Jl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 January 2014, Tanmay Inamdar wrote:

> +static void xgene_pcie_fixup_bridge(struct pci_dev *dev)
> +{
> +	int i;
> +
> +	/* Hide the PCI host BARs from the kernel as their content doesn't
> +	 * fit well in the resource management
> +	 */
> +	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
> +		dev->resource[i].start = dev->resource[i].end = 0;
> +		dev->resource[i].flags = 0;
> +	}
> +	dev_info(&dev->dev, "Hiding X-Gene pci host bridge resources %s\n",
> +		 pci_name(dev));
> +}
> +DECLARE_PCI_FIXUP_HEADER(XGENE_PCIE_VENDORID, XGENE_PCIE_DEVICEID,
> +			 xgene_pcie_fixup_bridge);

Shouldn't this be gone now that the host bridge is correctly shown
at the domain root?

> +static int xgene_pcie_setup(int nr, struct pci_sys_data *sys)
> +{
> +	struct xgene_pcie_port *pp = sys->private_data;
> +	struct resource *io = &pp->realio;
> +
> +	io->start = sys->domain * SZ_64K;
> +	io->end = io->start + SZ_64K;
> +	io->flags = pp->io.res.flags;
> +	io->name = "PCI IO";
> +	pci_ioremap_io(io->start, pp->io.res.start);
> +
> +	pci_add_resource_offset(&sys->resources, io, sys->io_offset);
> +	sys->mem_offset = pp->mem.res.start - pp->mem.pci_addr;
> +	pci_add_resource_offset(&sys->resources, &pp->mem.res,
> +				sys->mem_offset);
> +	return 1;
> +}

Thanks for bringing back the I/O space handling.

You don't seem to set sys->io_offset anywhere, but each of the
ports listed in your DT starts a local bus I/O register range
at port 0.

AFAICT, you need to add (somewhere)

	sys->io_offset = pp->realio.start - pp->io.pci_addr;

but there could be something else missing. You clearly haven't
tested if the I/O space actually works.

If you want to try out the I/O space, I'd suggest using an Intel
e1000 network card, which has both memory and i/o space. There
is a patch at http://www.spinics.net/lists/linux-pci/msg27684.html
that lets you check the I/O registers on it, or you can go
through /dev/port from user space.

I also haven't seen your patch that adds pci_ioremap_io() for
arm64. It would be helpful to keep it in the same patch
series, since it won't build without this patch.

	Arnd
