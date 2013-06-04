Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3FDF2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:28:06 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:44435 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab3FDF2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:28:03 -0400
Date: Tue, 4 Jun 2013 01:27:59 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: avoid mis-detecting some V7 cores in the
 decompressor
In-Reply-To: <51AD1FE9.80709@codeaurora.org>
Message-ID: <alpine.LFD.2.03.1306040032510.1200@syhkavp.arg>
References: <1368049671-22879-1-git-send-email-sboyd@codeaurora.org> <5193E424.9090605@codeaurora.org> <519E57D2.3050000@codeaurora.org> <20130523231531.GT18614@n2100.arm.linux.org.uk> <20130524220539.GB599@codeaurora.org> <51AD0703.6050408@codeaurora.org>
 <20130603222321.GP18614@n2100.arm.linux.org.uk> <51AD1AB3.9050908@codeaurora.org> <20130603224555.GR18614@n2100.arm.linux.org.uk> <51AD1FE9.80709@codeaurora.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jun 2013, Stephen Boyd wrote:

> On 06/03/13 15:45, Russell King - ARM Linux wrote:
> > On Mon, Jun 03, 2013 at 03:37:39PM -0700, Stephen Boyd wrote:
> >> In my case I'm booting a kernel with textoffset = 0x208000 but RAM
> >> starts at 0x0. Does "minimum of RAM start" mean 0x0 or 0x200000?
> > The basic requirement for zImage's is no less than the start of RAM
> > plus 32K.  Or let me put it another way - start of writable memory
> > plus 32K.
> >
> > Whether you need an offset of 0x200000 or not is not for the
> > decompressor to know.  If you're having to avoid the first 0x200000
> > bytes of memory for some reason (eg, secure firmware or DSP needs
> > it left free) then there's no way for the decompressor to know that,
> > so it's irrelevant.
> >
> > So, lets say that your platform has a DSP which needs the first 0x200000
> > bytes left free.  So the boot loader _already_ needs to know to load
> > the image not at zero, but above 0x200000.  The additional 32K
> > requirement is really nothing new and so should be treated in just the
> > same way.
> >
> > Leave at least 32K of usable memory below the zImage at all times.
> 
> Understood. On my device writeable RAM actually starts at 0x0 but I have
> compiled in support for devices which don't have writeable memory at
> 0x0, instead they have writeable memory starting at 0x200000. Because I
> have a kernel supporting more than one device with differing memory
> layouts I run into this problem. The same problem will occur to any
> devices in the multi-platform kernel when a device with unwriteable
> memory near the bottom (such as MSM8960) joins the multi-platform defconfig.
> 
> Let me try to word it in your example. I have compiled in support for a
> platform that has a DSP which needs the first 0x200000 bytes left free.
> I have also compiled in support for a platform that doesn't have this
> requirement. I plan to run the zImage on the second platform (the one
> without the DSP requirement). The bootloader I'm running this zImage on
> has no idea that I've compiled in support for the other platform with
> the DSP requirement so it assumes it can load the zImage at the start of
> RAM (0x0) plus 32K. This is bad because then the page tables get written
> into my compressed data and it fails to decompress.

I've looked at the code and I think that #1 in your initial options is 
probably best here.  I agree with Russell about #2 being way too complex 
for only this case.

So, right before calling into cache_on, you could test if r4 - 16K >= pc 
and r4 < pc + (_end - .) then skip cache_on.

Something like this untested patch:

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 9a94f344df..9e0dbbccdd 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -182,7 +182,16 @@ not_angel:
 		ldr	r4, =zreladdr
 #endif
 
-		bl	cache_on
+		/* Set up a page table only if we don't overwrite ourself */
+		ldr	r0, 1f
+		add	r0, r0, pc
+		cmp	r4, r0
+		mov	r0, pc
+		cmpcc	r0, r4
+		blcs	cache_on
+		b	restart
+		.align	2
+1:		.word	_end - . + 0x4000
 
 restart:	adr	r0, LC0
 		ldmia	r0, {r1, r2, r3, r6, r10, r11, r12}
