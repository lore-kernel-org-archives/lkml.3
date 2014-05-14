Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbaENMpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:45:54 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:56979 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaENMpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:45:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-pci@vger.kernel.org, rogerq@ti.com,
        balajitk@ti.com, "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Marek Vasut'" <marex@denx.de>
Subject: Re: [PATCH 06/17] pci: host: pcie-designware: Use *base-mask* for configuring the iATU
Date: Wed, 14 May 2014 14:45:36 +0200
Message-ID: <5281007.CFRjW0Yeu2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <537302CD.7000701@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <4528185.oZbgyuuFKX@wuerfel> <537302CD.7000701@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:l4o9cNPT0Lrc3mcQIabUJlYG9AVgE80Ug6KhmsffXn7
 DZhqxAksRQ3N1+zZHw0QfXhj9CWCI4QuM8Y3gxV5qEO3y7Fpv4
 jTWF6//SaFJ06R6bPGVOiaU9rLDpEdNC8LPzziKLN0L6Qs8Png
 gvkwFSBnGC3jQvo2789k13UjH2Z7FUBszEA11RoJ7vZzUqAON/
 3sC3S5B3AnsLixIuw9IDet+AwlqLhNAYshULczAwMyLNlG3ap4
 IIrXgcDBueAINaoC4JsuN6zGDeNxuEcqy/404OhhxS9NK4Yz6I
 fEoq+gM+eBDzhew+FsJZaBRQksjHWdBYd18DrSrtfJ88h0Vxl6
 zXVnspms2o+13aDXDOt8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 11:14:45 Kishon Vijay Abraham I wrote:
> hi Arnd,
> 
> On Tuesday 13 May 2014 07:04 PM, Arnd Bergmann wrote:
> > On Tuesday 13 May 2014 15:27:46 Arnd Bergmann wrote:
> >> On Tuesday 13 May 2014 18:56:23 Kishon Vijay Abraham I wrote:
> >>>> If you have a case where the outbound translation is a 256MB (i.e. 28bit)
> >>>> section of the CPU address space, that could be represented as
> >>>>
> >>>>       ranges = <0x82000000 0 0  0xb0000000  0 0x10000000>;
> >>>>
> >>>> or 
> >>>>
> >>>>       ranges = <0x82000000 0 0xb0000000  0xb0000000  0 0x10000000>;
> >>>>
> >>>> depending on whether you want the BARs to be programmed using a low
> >>>> address 0x0-0x0fffffff or an address matching the window
> >>>> 0xb0000000-0xbfffffff.
> >>>
> >>> The problem is, for configuring the window starting at 0xb0000000, the ATU
> >>> should be programmed 0x0000000 (the cpu address for it will be 0xb0000000 though).
> >>>
> >>
> >> Then use the first of the two?
> >>
> > 
> > To clarify: using <0x82000000 0 0  0xb0000000  0 0x10000000> will give you 
> > a mem_offset of 0xb0000000, which should work just fine for this case.
> > 
> > What I don't understand is why the ATU cares about whether the outbound
> > address is 0x0000000 or 0xb0000000 if it just decodes the lower 28 bit
> > anyway. Did you mean that we have to program the BARs using low addresses
> > regardless of what is programmed in the ATU? That would make more sense,
> > and it also matches what I suggested.
> 
> No, It's not like it decodes only the lower 28bits. The BARs is programmed with
> 32 bit value.
> 
> My pcie dt node has
>  ranges = <0x00000800 0 0x20001000 0x20001000 0 0x00002000  /* CONFIG */
>            0x81000000 0 0          0x20003000 0 0x00010000  /* IO */
>            0x82000000 0 0x20013000 0x20013000 0 0xffed000>; /* MEM */
> 
> Consider MEM address space..
> 
> Here both PCI address and CPU address is 0x20013000. So when there is a write
> to cpu addr 0x20013000 [writel(virt_addr(0x20013000)], we want it to be
> translated to PCI addr 0x20013000. So in 'ATU', we would expect *base* to be
> programmed to *0x20013000* and target to be programmed to *0x20013000*. But
> that's not the case for DRA7xx. For DRA7xx *base* should be programmed to
> *0x0013000* and target should be programmed to *0x20013000*.

Ok, got it, thanks for your patience.

I think this would best be modeled as a separate bus node that contains the
restriction, like this:

/ {
	#address-cells = <1>; // or <2> if you support > 4GB address space
	#size-cells = <1>;

	soc {
		#address-cells <1>;
		#size-cells = <1>;
		ranges;
		dma-ranges;

		... // all normal devices

		axi@20000000 {
			#size-cells = <1>;
			#address-cells = <1>;
			dma-ranges; // can access all 4GB outbound
			ranges = <0 0x20000000 0x10000000>; // 28-bit bus

			pci@0 {
				reg = <0x0    0x1000>, // internal regs
				      <0x1000 0x2000>; // config space
				dma-ranges; // 32-bit outbound
				ranges = <0x81000000 0 0           0x3000 0 0x00010000  /* IO */
					  0x82000000 0 0x20013000 0x13000 0 0xffed000>; /* MEM */
			};
		};
	};
};


	Arnd
