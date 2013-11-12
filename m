Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab3KLOBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:01:22 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:64046 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3KLOBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:01:19 -0500
Date: Tue, 12 Nov 2013 09:01:16 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Christopher Covington <cov@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v2] ARM: Use udiv/sdiv for __aeabi_{u}idiv library
 functions
In-Reply-To: <528193A0.7050505@codeaurora.org>
Message-ID: <alpine.LFD.2.10.1311120839310.9667@knanqh.ubzr>
References: <1383951632-6090-1-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.10.1311092357090.2314@knanqh.ubzr> <528193A0.7050505@codeaurora.org>
User-Agent: Alpine 2.10 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov 2013, Stephen Boyd wrote:

> On 11/09/13 21:03, Nicolas Pitre wrote:
> > Bah..... NAK. We are doing runtime patching of the kernel for many
> > many things already. So why not do the same here?
> 
> static keys are a form of runtime patching, albeit not as extreme as
> you're suggesting.
> 
> >
> > The obvious strategy is to simply overwrite the start of the existing 
> > __aeabi_idiv code with the "sdiv r0, r0, r1" and "bx lr" opcodes.  
> >
> > Similarly for the unsigned case.
> 
> I was thinking the same thing when I wrote this, but I didn't know how
> to tell the compiler to either inline this function or to let me inilne
> an assembly stub with some section magic.
> 
> >
> > That let you test the hardware capability only once during boot instead 
> > of everytime a divide operation is performed.
> 
> The test for hardware capability really isn't done more than once during
> boot. The assembly is like so at compile time
> 
> 00000000 <__aeabi_idiv>:
>    0:   nop     {0}
>    4:   b       0 <___aeabi_idiv>
>    8:   sdiv    r0, r0, r1
>    c:   bx      lr
> 
> and after we test and find support for the instruction it will be
> replaced with
> 
> 00000000 <__aeabi_idiv>:
>    0:   b       8
>    4:   b       0 <___aeabi_idiv>
>    8:   sdiv    r0, r0, r1
>    c:   bx      lr
> 
> Unfortunately we still have to jump to this function. It would be great
> if we could inline this function at the call site but as I already said
> I don't know how to do that.

What about this patch which I think is currently your best option.  Note 
it would need to use the facilities from asm/opcodes.h to make it endian 
agnostic.

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 6a1b8a81b1..379cffe4ab 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -383,6 +383,34 @@ static void __init cpuid_init_hwcaps(void)
 		elf_hwcap |= HWCAP_IDIVT;
 	}
 
+	/*
+	 * Patch our division routines with the corresponding opcode
+	 * if the hardware supports it.
+	 */
+	if (IS_ENABLED(CONFIG_THUMB2_KERNEL) && (elf_hwcap & HWCAP_IDIVT)) {
+		extern char __aeabi_uidiv, __aeabi_idiv;
+		u16 *uidiv = (u16 *)&__aeabi_uidiv;
+		u16 *idiv = (u16 *)&__aeabi_idiv;
+
+		uidiv[0] = 0xfbb0;  /* udiv r0, r0, r1 */
+		uidiv[1] = 0xf0f1;
+		uidiv[2] = 0x4770;  /* bx lr */
+
+		idiv[0] = 0xfb90;  /* sdiv r0, r0, r1 */
+		idiv[1] = 0xf0f1;  
+		idiv[2] = 0x4770;  /* bx lr */
+	} else if (!IS_ENABLED(CONFIG_THUMB2_KERNEL) && (elf_hwcap & HWCAP_IDIVA)) {
+		extern char __aeabi_uidiv, __aeabi_idiv;
+		u32 *uidiv = (u32 *)&__aeabi_uidiv;
+		u32 *idiv = (u32 *)&__aeabi_idiv;
+
+		uidiv[0] = 0xe730f110;  /* udiv r0, r0, r1 */
+		uidiv[1] = 0xe12fff1e;  /* bx lr */
+
+		idiv[0] = 0xe710f110;  /* sdiv r0, r0, r1 */
+		idiv[1] = 0xe12fff1e;  /* bx lr */
+	}
+
 	/* LPAE implies atomic ldrd/strd instructions */
 	vmsa = (read_cpuid_ext(CPUID_EXT_MMFR0) & 0xf) >> 0;
 	if (vmsa >= 5)


Nicolas
