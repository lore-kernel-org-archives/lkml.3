Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaEBPO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:14:29 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:61744 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaEBPO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:14:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
Date: Fri, 02 May 2014 17:13:46 +0200
Message-ID: <4526988.X68ZFJZdRl@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53639A0C.8070306@ti.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com> <5279118.J5305KQNjB@wuerfel> <53639A0C.8070306@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:vi6fGQr3XAETudpQY/Nv/7vXnNByMolA7v33znar3Ow
 oab/hzcS+uhPWvxbDOKGzNgaIJe740U7V6FSBrH4OGsISWw2R+
 IXoTzUEADQMZgYqZlBz0K3ANh0qZVVsFTvz1Dv2eksczHbuJHx
 XxMQ5FUbQDht91UeFhu50K9FBsZNau7bdKMA2g4GsjF+/rgqwL
 OB1hckk3nClvxEoRLMia4rLfGwCNHY+/XgMTziACo095DmCtBV
 SNY6c9n6J9dpmIg4iKMY7WXPu3cYnYsunc13po2lNCH0jq9/Jg
 EyXgVT0gXBC1619wzMyh+IlseVb2Zueku1E8v40+Osly+Iege4
 F4scw8+xZqEmnttm5KeM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2014 09:13:48 Santosh Shilimkar wrote:
> On Friday 02 May 2014 05:58 AM, Arnd Bergmann wrote:
> > On Thursday 01 May 2014 14:12:10 Grant Likely wrote:
> >>>> I've got two concerns here. of_dma_get_range() retrieves only the first
> >>>> tuple from the dma-ranges property, but it is perfectly valid for
> >>>> dma-ranges to contain multiple tuples. How should we handle it if a
> >>>> device has multiple ranges it can DMA from?
> >>>>
> >>>
> >>> We've not found any cases in current Linux where more than one dma-ranges
> >>> would be used. Moreover, The MM (definitely for ARM) isn't supported such
> >>> cases at all (if i understand everything right).
> >>> - there are only one arm_dma_pfn_limit
> >>> - there is only one MM zone is used for ARM
> >>> - some arches like x86,mips can support 2 zones (per arch - not per device or bus)
> >>>   DMA & DMA32, but they configured once and forever per arch.
> >>
> >> Okay. If anyone ever does implement multiple ranges then this code will
> >> need to be revisited.
> > 
> > I wonder if it's needed for platforms implementing the standard "ARM memory map" [1].
> > The document only talks about addresses as seen from the CPU, and I can see
> > two logical interpretations how the RAM is supposed to be visible from a device:
> > either all RAM would be visible contiguously at DMA address zero, or everything
> > would be visible at the same physical address as the CPU sees it.
> > 
> > If anyone picks the first interpretation, we will have to implement that
> > in Linux. We can of course hope that all hardware designs follow the second
> > interpretation, which would be more convenient for us here.
> >
> not sure if I got your point correctly but DMA address 0 isn't used as DRAM start in
> any of the ARM SOC today, mainly because of the boot architecture where address 0 is
> typically used by ROM code. RAM start will be at some offset always and hence I
> believe ARM SOCs will follow second interpretation. This was one of the main reason
> we ended up fixing the max*pfn stuff. 
> 26ba47b {ARM: 7805/1: mm: change max*pfn to include the physical offset of memory}

Marvell normally has memory starting at physical address zero.

Even if RAM starts elsewhere, I don't think that is a reason to have
the DMA address do the same. The memory controller internally obviously
starts at zero, and it wouldn't be unreasonable to have the DMA space
match what the memory controller sees rather than have it match what
the CPU sees.

If you look at the table 3.1.4, you have both addresses listed:

	  Physical Addresses in SoC	Offset	 		Internal DRAM address

2 GBytes	0x00 8000 0000 –	-0x00 8000 0000		0x00 0000 0000 –
		0x00 FFFF FFFF			 		0x00 7FFF FFFF

30 GBytes	0x08 8000 0000 – 	-0x08 0000 0000		0x00 8000 0000 –
		0x0F FFFF FFFF					0x07 FFFF FFFF

32 GBytes	0x88 0000 0000 -	-0x80 0000 0000	 	0x08 0000 0000 -
		0x8F FFFF FFFF					0x0F FFFF FFFF

The wording "Physical Addresses in SoC" would indeed suggest that the
same address is used for DMA, but I would trust everybody to do that.

	Arnd
