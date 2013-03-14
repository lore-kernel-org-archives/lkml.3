Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab3CNPHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:07:00 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:56384 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab3CNPG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:06:58 -0400
MIME-Version: 1.0
Date: Thu, 14 Mar 2013 23:06:56 +0800
Message-ID: <CAM16m2mpwKc4-ECGcAXdZS4r+To=heHkpezAu0CZ4fc=VP7ivw@mail.gmail.com>
Subject: In SMP, every CPU has its own loops_per_jiffy value,
 __loop_const_udelay time period is not right if two cpus are running in
 different frequency.
From: chpoph <chpoph@gmail.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in __loop_const_udelay function, the delayed time period is calculated
according to loops_per_jiffy.
In SMP, every CPU has its own  loops_per_jiffy value,
__loop_const_udelay time period is not right if two cpus are running
in different frequency.


the following is file arch/arm/lib/delay-loop.S
/*
 *  linux/arch/arm/lib/delay.S
 *
 *  Copyright (C) 1995, 1996 Russell King
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */
#include <linux/linkage.h>
#include <asm/assembler.h>
#include <asm/delay.h>
		.text

.LC0:		.word	loops_per_jiffy
.LC1:		.word	UDELAY_MULT

/*
 * r0  <= 2000
 * lpj <= 0x01ffffff (max. 3355 bogomips)
 * HZ  <= 1000
 */

ENTRY(__loop_udelay)
		ldr	r2, .LC1
		mul	r0, r2, r0
ENTRY(__loop_const_udelay)			@ 0 <= r0 <= 0x7fffff06
		mov	r1, #-1
		ldr	r2, .LC0
		ldr	r2, [r2]		@ max = 0x01ffffff
		add	r0, r0, r1, lsr #32-14
		mov	r0, r0, lsr #14		@ max = 0x0001ffff
		add	r2, r2, r1, lsr #32-10
		mov	r2, r2, lsr #10		@ max = 0x00007fff
		mul	r0, r2, r0		@ max = 2^32-1
		add	r0, r0, r1, lsr #32-6
		movs	r0, r0, lsr #6
		moveq	pc, lr

/*
 * loops = r0 * HZ * loops_per_jiffy / 1000000
 */

@ Delay routine
ENTRY(__loop_delay)
		subs	r0, r0, #1
#if 0
		movls	pc, lr
		subs	r0, r0, #1
		movls	pc, lr
		subs	r0, r0, #1
		movls	pc, lr
		subs	r0, r0, #1
		movls	pc, lr
		subs	r0, r0, #1
		movls	pc, lr
		subs	r0, r0, #1
		movls	pc, lr
		subs	r0, r0, #1
		movls	pc, lr
		subs	r0, r0, #1
#endif
		bhi	__loop_delay
		mov	pc, lr
ENDPROC(__loop_udelay)
ENDPROC(__loop_const_udelay)
ENDPROC(__loop_delay)
