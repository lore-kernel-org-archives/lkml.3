Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3FECXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 22:23:09 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41038 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3FECXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 22:23:04 -0400
Date: Tue, 4 Jun 2013 22:23:01 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: avoid mis-detecting some V7 cores in the
 decompressor
In-Reply-To: <20130604214501.GL599@codeaurora.org>
Message-ID: <alpine.LFD.2.03.1306041751470.1200@syhkavp.arg>
References: <20130523231531.GT18614@n2100.arm.linux.org.uk> <20130524220539.GB599@codeaurora.org> <51AD0703.6050408@codeaurora.org> <20130603222321.GP18614@n2100.arm.linux.org.uk> <51AD1AB3.9050908@codeaurora.org> <20130603224555.GR18614@n2100.arm.linux.org.uk>
 <51AD1FE9.80709@codeaurora.org> <alpine.LFD.2.03.1306040032510.1200@syhkavp.arg> <20130604194705.GK599@codeaurora.org> <alpine.LFD.2.03.1306041559440.1200@syhkavp.arg> <20130604214501.GL599@codeaurora.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jun 2013, Stephen Boyd wrote:

> On 06/04, Nicolas Pitre wrote:
> > diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> > index 9a94f344df..773bc35f92 100644
> > --- a/arch/arm/boot/compressed/head.S
> > +++ b/arch/arm/boot/compressed/head.S
> > @@ -178,11 +178,23 @@ not_angel:
> >  		mov	r4, pc
> >  		and	r4, r4, #0xf8000000
> >  		add	r4, r4, #TEXT_OFFSET
> > +		bl	cache_on
> >  #else
> >  		ldr	r4, =zreladdr
> > -#endif
> >  
> > -		bl	cache_on
> > +		/*
> > +		 * Set up a page table only if we don't overwrite ourself.
> > +		 * That means r4 < pc && r4 - 4K > &_end.
> > +		 * Given that r4 > &_en is most unfrequent, we add a rough
> > +		 * additional 1MB of room for a possible appended DTB.
> > +		 */
> > +		mov	r0, pc
> > +		cmp	r0, r4
> > +		ldrcc	r0, LC0+32
> > +		addcc	r0, r0, pc
> > +		cmpcc	r4, r0
> > +		blcs	cache_on
> > +#endif
> 
> But this looks backwards? Shouldn't we put it in the
> CONFIG_AUTO_ZRELADDR case?

Obviously.  I was looking for zreladdr only. In fact this should be done 
in both cases.

> >  restart:	adr	r0, LC0
> >  		ldmia	r0, {r1, r2, r3, r6, r10, r11, r12}
> > @@ -464,6 +476,16 @@ not_relocated:	mov	r0, #0
> >  		cmp	r2, r3
> >  		blo	1b
> >  
> > +#if defined(CONFIG_AUTO_ZRELADDR) && defined(CONFIG_CPU_CP15)
> > +		/*
> > +		 * Did we skip the cache setup earlier?
> > +		 * Do it now if so.
> > +		 */
> > +		mrc     p15, 0, r0, c1, c0, 0	@ read control register
> > +		tst	r0, #1			@ MMU bit set?
> > +		bleq	cache_on		@ no: set it up
> > +#endif
> 
> Too bad we can't store one more variable into LC0 that says we
> turned the caches on. Then we could read that here and detect it
> without CP15 accessors required.

The LC0 area should be considered read-only as it may be located in 
flash.

Here's what I came with instead:

From: Nicolas Pitre <nicolas.pitre@linaro.org>
Date: Tue, 4 Jun 2013 17:01:30 -0400
Subject: [PATCH] ARM: zImage: don't overwrite ourself with a page table

When zImage is loaded into RAM at a low address but TEXT_OFFSET
is set higher, we risk overwriting ourself with the page table
needed to turn on the cache as it is located relative to the relocation
address.  Let's defer the cache setup after relocation in that case.

Signed-off-by: Nicolas Pitre <nico@linaro.org>

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 9a94f344df..aa909393f2 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -182,7 +182,19 @@ not_angel:
 		ldr	r4, =zreladdr
 #endif
 
-		bl	cache_on
+		/*
+		 * Set up a page table only if it won't overwrite ourself.
+		 * That means r4 < pc && r4 - 16k page directory > &_end.
+		 * Given that r4 > &_en is most unfrequent, we add a rough
+		 * additional 1MB of room for a possible appended DTB.
+		 */
+		mov	r0, pc
+		cmp	r0, r4
+		ldrcc	r0, LC0+32
+		addcc	r0, r0, pc
+		cmpcc	r4, r0
+		orrcc	r4, r4, #1		@ remember we skipped cache_on
+		blcs	cache_on
 
 restart:	adr	r0, LC0
 		ldmia	r0, {r1, r2, r3, r6, r10, r11, r12}
@@ -228,7 +240,7 @@ restart:	adr	r0, LC0
  *   r0  = delta
  *   r2  = BSS start
  *   r3  = BSS end
- *   r4  = final kernel address
+ *   r4  = final kernel address (possibly with LSB set)
  *   r5  = appended dtb size (still unknown)
  *   r6  = _edata
  *   r7  = architecture ID
@@ -276,6 +288,7 @@ restart:	adr	r0, LC0
 		 */
 		cmp	r0, #1
 		sub	r0, r4, #TEXT_OFFSET
+		bic	r0, r0, #1
 		add	r0, r0, #0x100
 		mov	r1, r6
 		sub	r2, sp, r6
@@ -322,12 +335,13 @@ dtb_check_done:
 
 /*
  * Check to see if we will overwrite ourselves.
- *   r4  = final kernel address
+ *   r4  = final kernel address (possibly with LSB set)
  *   r9  = size of decompressed image
  *   r10 = end of this image, including  bss/stack/malloc space if non XIP
  * We basically want:
  *   r4 - 16k page directory >= r10 -> OK
  *   r4 + image length <= address of wont_overwrite -> OK
+ * Note: the possible LSB in r4 is harmless here.
  */
 		add	r10, r10, #16384
 		cmp	r4, r10
@@ -389,7 +403,8 @@ dtb_check_done:
 		add	sp, sp, r6
 #endif
 
-		bl	cache_clean_flush
+		tst	r4, #1
+		bleq	cache_clean_flush
 
 		adr	r0, BSYM(restart)
 		add	r0, r0, r6
@@ -401,7 +416,7 @@ wont_overwrite:
  *   r0  = delta
  *   r2  = BSS start
  *   r3  = BSS end
- *   r4  = kernel execution address
+ *   r4  = kernel execution address (possibly with LSB set)
  *   r5  = appended dtb size (0 if not present)
  *   r7  = architecture ID
  *   r8  = atags pointer
@@ -464,6 +479,15 @@ not_relocated:	mov	r0, #0
 		cmp	r2, r3
 		blo	1b
 
+		/*
+		 * Did we skip the cache setup earlier?
+		 * That is indicated by the LSB in r4.
+		 * Do it now if so.
+		 */
+		tst	r4, #1
+		bic	r4, r4, #1
+		blne	cache_on
+
 /*
  * The C runtime environment should now be setup sufficiently.
  * Set up some pointers, and start decompressing.
@@ -512,6 +536,7 @@ LC0:		.word	LC0			@ r1
 		.word	_got_start		@ r11
 		.word	_got_end		@ ip
 		.word	.L_user_stack_end	@ sp
+		.word	_end - restart + 16384 + 1024*1024
 		.size	LC0, . - LC0
 
 #ifdef CONFIG_ARCH_RPC
