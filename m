Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855AbaHZEiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:38:07 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:42993 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933750AbaHZEiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:38:01 -0400
Date: Tue, 26 Aug 2014 13:37:14 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC] ARM: Refactoring of Low-level debug
Cc: linux-kernel@vger.kernel.org
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20140826133714.ED4B.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ARM Linux developers,


I was thinking about refactoing low level debug functions.
Before I start to write a patch, I'd like to know experts' option.


In the current implementation, "addruart" gets both
phys addr and virt addr (if CONFIG_MMU=y),
but do we really need both?

We always pick up one of them and discard the other.
Moreover, we always know which one should be used
before calling "addruart".


The idea popped up in my mind was
to split "addruart" into "addruart_phys" and "addruart_virt"
and call the only appropriate one.


The patch will change the caller in arch/arm/kernel/debug.S
as follows:



[Before]

#ifdef CONFIG_MMU
		.macro	addruart_current, rx, tmp1, tmp2
		addruart	\tmp1, \tmp2, \rx
		mrc		p15, 0, \rx, c1, c0
		tst		\rx, #1
		moveq		\rx, \tmp1
		movne		\rx, \tmp2
		.endm

#else /* !CONFIG_MMU */
		.macro	addruart_current, rx, tmp1, tmp2
		addruart	\rx, \tmp1
		.endm

#endif /* CONFIG_MMU */




[After]

		.macro	addruart_current, rx, tmp
#ifdef CONFIG_MMU
		mrc		p15, 0, \tmp, c1, c0
		tst		\tmp, #1
		beq		10f
		addruart_virt	\rx, \tmp
		b		11f
#endif
10:		addruart_phys	\rx, \tmp
11:
		.endm




The callee in each machine  (arch/arm/include/debug/*.S)
will be changed as follows:


[Before]

		.macro	addruart, rp, rv, tmp
		ldr	\rp, =CONFIG_DEBUG_UART_PHYS
		ldr	\rv, =CONFIG_DEBUG_UART_VIRT
		.endm



[After]

		.macro	addruart_phys, rx, tmp
		ldr	\rx, =CONFIG_DEBUG_UART_PHYS
		.endm

		.macro	addruart_virt, rx, tmp
		ldr	\rx, =CONFIG_DEBUG_UART_VIRT
		.endm





Pros of doing this
------------------

[1] In the current implementation, the interface of addruart
is defferent depending on CONFIG_MMU.

"addruart" takes three arguments for CONFIG_MMU=y, whereas
it takes two for CONFIG_MMU is not set.

This patch will introduce the consistency of the number of
arguments.


[2] We can save one scratch register.

For example, arch/arm/boot/compressed/debug.S
gets phys addr and virt addr (r1 = phys, r2 = virt),
but r2 is not used:

ENTRY(putc)
	addruart r1, r2, r3
	waituart r3, r1
	senduart r0, r1
	busyuart r3, r1
	mov	 pc, lr
ENDPROC(putc)



We can change this part as follows:

ENTRY(putc)
	addruart_phys r1, r3
	waituart r3, r1
	senduart r0, r1
	busyuart r3, r1
	mov	 pc, lr
ENDPROC(putc)





If the basic idea is OK, I will take a close look.
Comments are welcome.



Best Regards
Masahiro Yamada

