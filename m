Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaK0QOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:14:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbaK0QOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:14:04 -0500
Message-ID: <54774DC9.4040103@suse.de>
Date: Thu, 27 Nov 2014 17:14:01 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "J. German Rivera" <German.Rivera@freescale.com>,
        gregkh@linuxfoundation.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org
CC: stuart.yoder@freescale.com, Kim.Phillips@freescale.com,
        scottwood@freescale.com, bhamciu1@freescale.com, R89243@freescale.com,
        Geoff.Thorpe@freescale.com, bhupesh.sharma@freescale.com,
        nir.erez@freescale.com, richard.schmitt@freescale.com
Subject: Re: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex
 APIs
References: <1415901246-24131-1-git-send-email-German.Rivera@freescale.com> <1415901246-24131-2-git-send-email-German.Rivera@freescale.com>
In-Reply-To: <1415901246-24131-2-git-send-email-German.Rivera@freescale.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 13.11.14 18:54, J. German Rivera wrote:
> APIs to access the Management Complex (MC) hardware
> module of Freescale LS2 SoCs. This patch includes
> APIs to check the MC firmware version and to manipulate
> DPRC objects in the MC.
> 
> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>

[...]

> +/**
> + * Creates an MC I/O object
> + *
> + * @dev: device to be associated with the MC I/O object
> + * @mc_portal_phys_addr: physical address of the MC portal to use
> + * @mc_portal_size: size in bytes of the MC portal
> + * @flags: flags for the new MC I/O object
> + * @new_mc_io: Area to return pointer to newly created MC I/O object
> + *
> + * Returns '0' on Success; Error code otherwise.
> + */
> +int __must_check fsl_create_mc_io(struct device *dev,
> +				  phys_addr_t mc_portal_phys_addr,
> +				  uint32_t mc_portal_size,
> +				  uint32_t flags, struct fsl_mc_io **new_mc_io)
> +{
> +	struct fsl_mc_io *mc_io;
> +	void __iomem *mc_portal_virt_addr;
> +	struct resource *res;
> +
> +	mc_io = devm_kzalloc(dev, sizeof(*mc_io), GFP_KERNEL);
> +	if (mc_io == NULL)
> +		return -ENOMEM;
> +
> +	mc_io->dev = dev;
> +	mc_io->flags = flags;
> +	mc_io->portal_phys_addr = mc_portal_phys_addr;
> +	mc_io->portal_size = mc_portal_size;
> +	res = devm_request_mem_region(dev,
> +				      mc_portal_phys_addr,
> +				      mc_portal_size,
> +				      "mc_portal");
> +	if (res == NULL) {
> +		dev_err(dev,
> +			"devm_request_mem_region failed for MC portal %#llx\n",
> +			mc_portal_phys_addr);
> +		return -EBUSY;
> +	}
> +
> +	mc_portal_virt_addr = devm_ioremap_nocache(dev,
> +						   mc_portal_phys_addr,
> +						   mc_portal_size);

While I can't complain about the device itself, I will note that I think
it's a pretty bad design decision to expose actual host physical
addresses in the protocol.

Basically this means that you won't be able to pass a full MC complex
into a guest, even if you could virtualize IRQ and DMA access unless you
map it at the exact same location as the host's MC complex.

Could we at least add a "ranges" property to the MC device description
and check whether the physical addresses we get are within that range -
if nothing else, at least as sanity check? Then maybe add some calls in
the next version that act on that range rather than actual host physical
addresses?


Alex
