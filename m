Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935743AbaDJUrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:47:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:55340 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934020AbaDJUrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:47:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 4/6] pci: Introduce a domain number for pci_host_bridge.
Date: Thu, 10 Apr 2014 22:46:36 +0200
Message-ID: <6459805.ygy4tBNDNz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140410145304.GS985@e106497-lin.cambridge.arm.com>
References: <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com> <6144916.rD76jOL8sv@wuerfel> <20140410145304.GS985@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:pwJeUiwXMMJrk28fI0tlR7T4+6PkFTxGyj9xlijtfUZ
 UXhjyINsVv02nKNOpTHgrzkUkalRyGVRAFA/jUBEL/rIhwaGa9
 6sVu0jpyhAwgj+eUrfkzf3oVuXIIur3wValMQ3xRJcOTTQRBNy
 BLvPJK4yp6KamZETVe4D6s3sKMpytwnSP0uqOi5JS2lAwYPpJJ
 wP88/Qp4m1b2qflojmQh/gRe4GUZbG/VFrS7CxdWgA6ugzce5N
 M+PJpednY+0DVWaQeZE/JY87w4wg3nPy5XSHDVfdA1H0e2JFIh
 ilqzWcZd/pG/goCXF8Z5Ue31ktMH5DIthoD4s67u82wXVMsXtb
 o6p3DvIN/k79uGL9vEss=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 April 2014 15:53:04 Liviu Dudau wrote:
> On Thu, Apr 10, 2014 at 03:07:44PM +0100, Arnd Bergmann wrote:

> > This mirrors how we treat devices: a pci_device has an embedded device,
> > and so on, in other subsystems we can have multiple layers.
> > 
> > In this example, the tegra pcie driver then allocates its own tegra_pcie
> > structure, fills out the fields it needs, and registers it with the
> > ARM architecture code, passing just the pci_sys_data pointer. That function
> > in turn passes a pointer to the embedded pci_host_bridge down to the
> > generic code. Ideally we should try to eliminate the architecture specific
> > portion here, but that is a later step.
> 
> So Arnd seems to agree with me: we should try to get out of architecture specific
> pci_sys_data and link the host bridge driver straight into the PCI core. The
> core then can call into arch code via pcibios_*() functions.
> 
> Arnd, am I reading correctly into what you are saying?

Half of it ;-)

I think it would be better to not have an architecture specific data
structure, just like it would be better not to have architecture specific
pcibios_* functions that get called by the PCI core. Note that the
architecture specific functions are the ones that rely on the architecture
specific data structures as well. If they only use the common fields,
it should also be possible to share the code.

I also don't realistically think we can get there on a lot of architectures
any time soon. Note that most architectures only have one PCI host
implementation, so the architecture structure is the same as the host
driver structure anyway.

For architectures like powerpc and arm that have people actively working
on them, we have a chance to clean up that code in the way we want it
(if we can agree on the direction), but it's still not trivial to do.

Speaking of arm32 in particular, I think we will end up with a split
approach: modern platforms (multiplatform, possibly all DT based) using
PCI core infrastructure directly and no architecture specific PCI
code on the one side, and a variation of today's code for the legacy
platforms on the other.

	Arnd
