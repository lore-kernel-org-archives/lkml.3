Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab3FDVTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 17:19:04 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:37029 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab3FDVTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 17:19:01 -0400
Date: Tue, 4 Jun 2013 17:13:35 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: avoid mis-detecting some V7 cores in the
 decompressor
In-Reply-To: <20130604194705.GK599@codeaurora.org>
Message-ID: <alpine.LFD.2.03.1306041559440.1200@syhkavp.arg>
References: <5193E424.9090605@codeaurora.org> <519E57D2.3050000@codeaurora.org> <20130523231531.GT18614@n2100.arm.linux.org.uk> <20130524220539.GB599@codeaurora.org> <51AD0703.6050408@codeaurora.org> <20130603222321.GP18614@n2100.arm.linux.org.uk>
 <51AD1AB3.9050908@codeaurora.org> <20130603224555.GR18614@n2100.arm.linux.org.uk> <51AD1FE9.80709@codeaurora.org> <alpine.LFD.2.03.1306040032510.1200@syhkavp.arg> <20130604194705.GK599@codeaurora.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jun 2013, Stephen Boyd wrote:

> On 06/04, Nicolas Pitre wrote:
> > On Mon, 3 Jun 2013, Stephen Boyd wrote:
> > 
> > > On 06/03/13 15:45, Russell King - ARM Linux wrote:
> > > > On Mon, Jun 03, 2013 at 03:37:39PM -0700, Stephen Boyd wrote:
> > > >> In my case I'm booting a kernel with textoffset = 0x208000 but RAM
> > > >> starts at 0x0. Does "minimum of RAM start" mean 0x0 or 0x200000?
> > > > The basic requirement for zImage's is no less than the start of RAM
> > > > plus 32K.  Or let me put it another way - start of writable memory
> > > > plus 32K.
> > > >
> > > > Whether you need an offset of 0x200000 or not is not for the
> > > > decompressor to know.  If you're having to avoid the first 0x200000
> > > > bytes of memory for some reason (eg, secure firmware or DSP needs
> > > > it left free) then there's no way for the decompressor to know that,
> > > > so it's irrelevant.
> > > >
> > > > So, lets say that your platform has a DSP which needs the first 0x200000
> > > > bytes left free.  So the boot loader _already_ needs to know to load
> > > > the image not at zero, but above 0x200000.  The additional 32K
> > > > requirement is really nothing new and so should be treated in just the
> > > > same way.
> > > >
> > > > Leave at least 32K of usable memory below the zImage at all times.
> > > 
> > > Understood. On my device writeable RAM actually starts at 0x0 but I have
> > > compiled in support for devices which don't have writeable memory at
> > > 0x0, instead they have writeable memory starting at 0x200000. Because I
> > > have a kernel supporting more than one device with differing memory
> > > layouts I run into this problem. The same problem will occur to any
> > > devices in the multi-platform kernel when a device with unwriteable
> > > memory near the bottom (such as MSM8960) joins the multi-platform defconfig.
> > > 
> > > Let me try to word it in your example. I have compiled in support for a
> > > platform that has a DSP which needs the first 0x200000 bytes left free.
> > > I have also compiled in support for a platform that doesn't have this
> > > requirement. I plan to run the zImage on the second platform (the one
> > > without the DSP requirement). The bootloader I'm running this zImage on
> > > has no idea that I've compiled in support for the other platform with
> > > the DSP requirement so it assumes it can load the zImage at the start of
> > > RAM (0x0) plus 32K. This is bad because then the page tables get written
> > > into my compressed data and it fails to decompress.
> > 
> > I've looked at the code and I think that #1 in your initial options is 
> > probably best here.  I agree with Russell about #2 being way too complex 
> > for only this case.
> > 
> > So, right before calling into cache_on, you could test if r4 - 16K >= pc 
> > and r4 < pc + (_end - .) then skip cache_on.
> > 
> > Something like this untested patch:
> 
> So this would cause the decompression to run without the cache on
> if we have to relocate the decompression code to avoid
> overwriting ourselves?

No.  What my example patch does is to simply skip setting up a page 
table and turning on the cache if the page table ends up in the 
code/data to be relocated.

> It seems that the memcpy is fairly quick on my hardware in comparison 
> to the decompression so moving the cache_on() call to right before we 
> run decompression keeps things pretty fast. It's very possible 
> different hardware will have different results.

"Fairly quick" is still not optimal.

> This is what I meant by option #1. I suppose
> we can make it smarter and conditionalize it on if we relocated
> or not?

Here's what I,m suggesting:

>From f1ec55e8189c06b89d2f196929f01fe3fc40f908 Mon Sep 17 00:00:00 2001
From: Nicolas Pitre <nicolas.pitre@linaro.org>
Date: Tue, 4 Jun 2013 17:01:30 -0400
Subject: [PATCH] ARM: zImage: don't overwrite ourself with a page table

When zImage is loaded into RAM at a low address but TEXT_OFFSET
is set higher, we risk overwriting ourself with the page table
needed to turn on the cache as it is located relative to the relocation
address.  Let's defer the cache setup after relocation in that case.

Signed-off-by: Nicolas Pitre <nico@linaro.org>

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 9a94f344df..773bc35f92 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -178,11 +178,23 @@ not_angel:
 		mov	r4, pc
 		and	r4, r4, #0xf8000000
 		add	r4, r4, #TEXT_OFFSET
+		bl	cache_on
 #else
 		ldr	r4, =zreladdr
-#endif
 
-		bl	cache_on
+		/*
+		 * Set up a page table only if we don't overwrite ourself.
+		 * That means r4 < pc && r4 - 4K > &_end.
+		 * Given that r4 > &_en is most unfrequent, we add a rough
+		 * additional 1MB of room for a possible appended DTB.
+		 */
+		mov	r0, pc
+		cmp	r0, r4
+		ldrcc	r0, LC0+32
+		addcc	r0, r0, pc
+		cmpcc	r4, r0
+		blcs	cache_on
+#endif
 
 restart:	adr	r0, LC0
 		ldmia	r0, {r1, r2, r3, r6, r10, r11, r12}
@@ -464,6 +476,16 @@ not_relocated:	mov	r0, #0
 		cmp	r2, r3
 		blo	1b
 
+#if defined(CONFIG_AUTO_ZRELADDR) && defined(CONFIG_CPU_CP15)
+		/*
+		 * Did we skip the cache setup earlier?
+		 * Do it now if so.
+		 */
+		mrc     p15, 0, r0, c1, c0, 0	@ read control register
+		tst	r0, #1			@ MMU bit set?
+		bleq	cache_on		@ no: set it up
+#endif
+
 /*
  * The C runtime environment should now be setup sufficiently.
  * Set up some pointers, and start decompressing.
@@ -512,6 +534,7 @@ LC0:		.word	LC0			@ r1
 		.word	_got_start		@ r11
 		.word	_got_end		@ ip
 		.word	.L_user_stack_end	@ sp
+		.word	_end - restart + 16384 + 1024*1024
 		.size	LC0, . - LC0
 
 #ifdef CONFIG_ARCH_RPC
