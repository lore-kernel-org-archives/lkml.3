Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbaLAXk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:40:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbaLAXkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:40:53 -0500
Message-ID: <547CFC82.8060701@suse.de>
Date: Tue, 02 Dec 2014 00:40:50 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stuart Yoder <stuart.yoder@freescale.com>,
        Jose Rivera <German.Rivera@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Kim Phillips <Kim.Phillips@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        "bhamciu1@freescale.com" <bhamciu1@freescale.com>,
        "R89243@freescale.com" <R89243@freescale.com>,
        Geoff Thorpe <Geoff.Thorpe@freescale.com>,
        "bhupesh.sharma@freescale.com" <bhupesh.sharma@freescale.com>,
        "nir.erez@freescale.com" <nir.erez@freescale.com>,
        Richard Schmitt <richard.schmitt@freescale.com>
Subject: Re: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex
 APIs
References: <1415901246-24131-1-git-send-email-German.Rivera@freescale.com> <1415901246-24131-2-git-send-email-German.Rivera@freescale.com> <54774DC9.4040103@suse.de> <CY1PR0301MB0748306F3BB357FF103625BC877D0@CY1PR0301MB0748.namprd03.prod.outlook.com>
In-Reply-To: <CY1PR0301MB0748306F3BB357FF103625BC877D0@CY1PR0301MB0748.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01.12.14 23:53, Stuart Yoder wrote:
> 
> 
>> -----Original Message-----
>> From: Alexander Graf [mailto:agraf@suse.de]
>> Sent: Thursday, November 27, 2014 10:14 AM
>> To: Rivera Jose-B46482; gregkh@linuxfoundation.org; arnd@arndb.de; linux-kernel@vger.kernel.org
>> Cc: Yoder Stuart-B08248; Phillips Kim-R1AAHA; Wood Scott-B07421; Hamciuc Bogdan-BHAMCIU1; Marginean
>> Alexandru-R89243; Thorpe Geoff-R01361; Sharma Bhupesh-B45370; Erez Nir-RM30794; Schmitt Richard-B43082
>> Subject: Re: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex APIs
>>
>>
>>
>> On 13.11.14 18:54, J. German Rivera wrote:
>>> APIs to access the Management Complex (MC) hardware
>>> module of Freescale LS2 SoCs. This patch includes
>>> APIs to check the MC firmware version and to manipulate
>>> DPRC objects in the MC.
>>>
>>> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
>>> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
>>
>> [...]
>>
>>> +/**
>>> + * Creates an MC I/O object
>>> + *
>>> + * @dev: device to be associated with the MC I/O object
>>> + * @mc_portal_phys_addr: physical address of the MC portal to use
>>> + * @mc_portal_size: size in bytes of the MC portal
>>> + * @flags: flags for the new MC I/O object
>>> + * @new_mc_io: Area to return pointer to newly created MC I/O object
>>> + *
>>> + * Returns '0' on Success; Error code otherwise.
>>> + */
>>> +int __must_check fsl_create_mc_io(struct device *dev,
>>> +				  phys_addr_t mc_portal_phys_addr,
>>> +				  uint32_t mc_portal_size,
>>> +				  uint32_t flags, struct fsl_mc_io **new_mc_io)
>>> +{
>>> +	struct fsl_mc_io *mc_io;
>>> +	void __iomem *mc_portal_virt_addr;
>>> +	struct resource *res;
>>> +
>>> +	mc_io = devm_kzalloc(dev, sizeof(*mc_io), GFP_KERNEL);
>>> +	if (mc_io == NULL)
>>> +		return -ENOMEM;
>>> +
>>> +	mc_io->dev = dev;
>>> +	mc_io->flags = flags;
>>> +	mc_io->portal_phys_addr = mc_portal_phys_addr;
>>> +	mc_io->portal_size = mc_portal_size;
>>> +	res = devm_request_mem_region(dev,
>>> +				      mc_portal_phys_addr,
>>> +				      mc_portal_size,
>>> +				      "mc_portal");
>>> +	if (res == NULL) {
>>> +		dev_err(dev,
>>> +			"devm_request_mem_region failed for MC portal %#llx\n",
>>> +			mc_portal_phys_addr);
>>> +		return -EBUSY;
>>> +	}
>>> +
>>> +	mc_portal_virt_addr = devm_ioremap_nocache(dev,
>>> +						   mc_portal_phys_addr,
>>> +						   mc_portal_size);
>>
>> While I can't complain about the device itself, I will note that I think
>> it's a pretty bad design decision to expose actual host physical
>> addresses in the protocol.
> 
> I tend to agree.  I'll look into creating a proposed change to the architecture
> to have the MC communicate a physical offset of some kind.
> 
>> Basically this means that you won't be able to pass a full MC complex
>> into a guest, even if you could virtualize IRQ and DMA access unless you
>> map it at the exact same location as the host's MC complex.
> 
> Right.  But is that really an issue in practice?

Well, it obviously depends on what you're trying to do. For everything
that's envisioned today I don't think it's a problem, but I like to
stick to the "know as little as you have to know" rule when it comes to
communication protocols.

>> Could we at least add a "ranges" property to the MC device description
>> and check whether the physical addresses we get are within that range -
>> if nothing else, at least as sanity check? Then maybe add some calls in
>> the next version that act on that range rather than actual host physical
>> addresses?
> 
> So you mean something like:
> 
>         fsl_mc: fsl-mc@80c000000 {
>                 compatible = "fsl,qoriq-mc";
>                 #stream-id-cells = <2>;
>                 reg = <0x00000008 0x0c000000 0 0x40>,    /* MC portal base */
>                       <0x00000000 0x08340000 0 0x40000>; /* MC control reg */
>                 ranges = <0x8 0x0 0x8 0x0 0x20000000>;
>                 lpi-parent = <&its>;
>         };
> 
> The physical addresses returned by the MC fall into a 512MB "portal"
> region at 0x8_0000_0000 in the physical address map.  For now map it 1:1, but in the
> future it could become:
>                    ranges = <0x0 0x0 0x8 0x0 0x20000000>;
> 
> ...if I can get the hardware architecture changed.

Yup, I think that makes things a lot less error prone - you don't
randomly access any pointer the device tells you to access :).


Alex
