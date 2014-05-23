Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaEWALm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 20:11:42 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55222 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaEWALl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 20:11:41 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Christopher Covington <cov@codeaurora.org>
Cc: Larry Bassel <larry.bassel@linaro.org>, catalin.marinas@arm.com,
        will.deacon@arm.com, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mark.rutland@arm.com
Subject: Re: [PATCH v4 2/2] arm64: enable context tracking
References: <1400786855-32656-1-git-send-email-larry.bassel@linaro.org>
	<1400786855-32656-3-git-send-email-larry.bassel@linaro.org>
	<537E5E1F.3050605@codeaurora.org>
Date: Thu, 22 May 2014 17:11:38 -0700
In-Reply-To: <537E5E1F.3050605@codeaurora.org> (Christopher Covington's
	message of "Thu, 22 May 2014 16:29:19 -0400")
Message-ID: <7hd2f5icat.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Mark Rutland

Christopher Covington <cov@codeaurora.org> writes:

> Hi Larry,
>
> On 05/22/2014 03:27 PM, Larry Bassel wrote:
>> Make calls to ct_user_enter when the kernel is exited
>> and ct_user_exit when the kernel is entered (in el0_da,
>> el0_ia, el0_svc, el0_irq and all of the "error" paths).
>> 
>> These macros expand to function calls which will only work
>> properly if el0_sync and related code has been rearranged
>> (in a previous patch of this series).
>> 
>> The calls to ct_user_exit are made after hw debugging has been
>> enabled (enable_dbg_and_irq).
>> 
>> The call to ct_user_enter is made at the beginning of the
>> kernel_exit macro.
>> 
>> This patch is based on earlier work by Kevin Hilman.
>> Save/restore optimizations were also done by Kevin.
>
>> --- a/arch/arm64/kernel/entry.S
>> +++ b/arch/arm64/kernel/entry.S
>> @@ -30,6 +30,44 @@
>>  #include <asm/unistd32.h>
>>  
>>  /*
>> + * Context tracking subsystem.  Used to instrument transitions
>> + * between user and kernel mode.
>> + */
>> +	.macro ct_user_exit, restore = 0
>> +#ifdef CONFIG_CONTEXT_TRACKING
>> +	bl	context_tracking_user_exit
>> +	.if \restore == 1
>> +	/*
>> +	 * Save/restore needed during syscalls.  Restore syscall arguments from
>> +	 * the values already saved on stack during kernel_entry.
>> +	 */
>> +	ldp	x0, x1, [sp]
>> +	ldp	x2, x3, [sp, #S_X2]
>> +	ldp	x4, x5, [sp, #S_X4]
>> +	ldp	x6, x7, [sp, #S_X6]
>> +	.endif
>> +#endif
>> +	.endm
>> +
>> +	.macro ct_user_enter, save = 0
>> +#ifdef CONFIG_CONTEXT_TRACKING
>> +	.if \save == 1
>> +	/*
>> +	 * Save/restore only needed on syscall fastpath, which uses
>> +	 * x0-x2.
>> +	 */
>> +	push    x2, x3
>
> Why is x3 saved?

I'll respond here since I worked with Larry on the context save/restore
part.

[insert rather embarassing disclamer of ignorance of arm64 assembly]

Based on my reading of the code, I figured only x0-x2 needed to be
saved.  However, based on some experiments with intentionally clobbering
the registers[1] (as suggested by Mark Rutland) in order to make sure
we're saving/restoring the right things, I discovered x3 was needed too
(I missed updating the comment to mention x0-x3.)

Maybe Will/Catalin/Mark R. can shed some light here?

Kevin

[1]
>From 8a8702b4d597d08def22221368beae5db2f4a8aa Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@linaro.org>
Date: Fri, 9 May 2014 13:37:43 -0700
Subject: [PATCH] KJH: test: clobber regs

---
 arch/arm64/kernel/entry.S | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 520da4c02ece..232f0200e88d 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -36,6 +36,25 @@
 	.macro ct_user_exit, restore = 0
 #ifdef CONFIG_CONTEXT_TRACKING
 	bl	context_tracking_user_exit
+ 	movz	x0, #0xff, lsl #48
+	movz	x1, #0xff, lsl #48
+	movz	x2, #0xff, lsl #48
+	movz	x3, #0xff, lsl #48
+	movz	x4, #0xff, lsl #48
+	movz	x5, #0xff, lsl #48
+	movz	x6, #0xff, lsl #48
+	movz	x7, #0xff, lsl #48
+	movz	x8, #0xff, lsl #48
+	movz	x9, #0xff, lsl #48
+	movz	x10, #0xff, lsl #48
+	movz	x11, #0xff, lsl #48
+	movz	x12, #0xff, lsl #48
+	movz	x13, #0xff, lsl #48
+	movz	x14, #0xff, lsl #48
+	movz	x15, #0xff, lsl #48
+	movz	x16, #0xff, lsl #48
+	movz	x17, #0xff, lsl #48
+	movz	x18, #0xff, lsl #48
 	.if \restore == 1
 	/*
 	 * Save/restore needed during syscalls.  Restore syscall arguments from
@@ -60,6 +79,25 @@
 	push    x0, x1
 	.endif
 	bl	context_tracking_user_enter
+ 	movz	x0, #0xff, lsl #48
+	movz	x1, #0xff, lsl #48
+	movz	x2, #0xff, lsl #48
+	movz	x3, #0xff, lsl #48
+	movz	x4, #0xff, lsl #48
+	movz	x5, #0xff, lsl #48
+	movz	x6, #0xff, lsl #48
+	movz	x7, #0xff, lsl #48
+	movz	x8, #0xff, lsl #48
+	movz	x9, #0xff, lsl #48
+	movz	x10, #0xff, lsl #48
+	movz	x11, #0xff, lsl #48
+	movz	x12, #0xff, lsl #48
+	movz	x13, #0xff, lsl #48
+	movz	x14, #0xff, lsl #48
+	movz	x15, #0xff, lsl #48
+	movz	x16, #0xff, lsl #48
+	movz	x17, #0xff, lsl #48
+	movz	x18, #0xff, lsl #48
 	.if \save == 1
 	pop     x0, x1
 	pop     x2, x3
-- 
1.9.2

