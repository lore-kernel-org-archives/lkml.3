Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3A1CdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 21:33:13 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:54961 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3A1CdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 21:33:12 -0500
MIME-Version: 1.0
In-Reply-To: <201301260045.28804.arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
	<1359132254.21576.230.camel@gandalf.local.home>
	<20130125165934.GE2069@linaro.org>
	<201301260045.28804.arnd@arndb.de>
Date: Mon, 28 Jan 2013 11:33:11 +0900
Message-ID: <CA+KhAHYJus7+LsVhNa4RcxfpeTBtV=_vf2YDACtoMujo5c6tXA@mail.gmail.com>
Subject: Re: [PATCH 19/19] [INCOMPLETE] ARM: make return_address available for ARM_UNWIND
From: Keun-O Park <kpark3469@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Dave Martin <dave.martin@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        sahara <keun-o.park@windriver.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys,

Could you please review the patch of fixing bug first of returning
wrong address when using frame pointer?
I am wondering if the first patch is not delivered to the mailing.

~~~~~~~~~~~~~~~~~~~~~snip~~~~~~~~~~~~~~~~~~~~~~~~~
>From 3a60b536d22a2043d735c890a9aac9e7cb72de8f Mon Sep 17 00:00:00 2001
From: sahara <keun-o.park@windriver.com>
Date: Thu, 3 Jan 2013 17:12:37 +0900
Subject: [PATCH 1/2] arm: fix returning wrong CALLER_ADDRx

This makes return_address return correct value for ftrace feature.
unwind_frame does not update frame->lr but frame->pc for backtrace.
And, the initialization for data.addr was missing so that wrong value
returned when unwind_frame failed.

Signed-off-by: sahara <keun-o.park@windriver.com>
---
 arch/arm/kernel/return_address.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/return_address.c b/arch/arm/kernel/return_address.c
index 8085417..fafedd8 100644
--- a/arch/arm/kernel/return_address.c
+++ b/arch/arm/kernel/return_address.c
@@ -26,7 +26,7 @@ static int save_return_addr(struct stackframe *frame, void *d)
        struct return_address_data *data = d;

        if (!data->level) {
-               data->addr = (void *)frame->lr;
+               data->addr = (void *)frame->pc;

                return 1;
        } else {
@@ -41,7 +41,8 @@ void *return_address(unsigned int level)
        struct stackframe frame;
        register unsigned long current_sp asm ("sp");

-       data.level = level + 1;
+       data.level = level + 2;
+       data.addr = NULL;

        frame.fp = (unsigned long)__builtin_frame_address(0);
        frame.sp = current_sp;
-- 
1.7.1
~~~~~~~~~~~~~~~~~~~~~snip~~~~~~~~~~~~~~~~~~~~~~~~~

Without this patch, when I added the following printk line and did
sync command,
it returned wrong return addresses using frame pointer.

Added line in __bdi_start_writeback():
+ printk("TEST: CALLER_ADDR0=(%pS), CALLER_ADDR1=(%pS),
CALLER_ADDR2=(%pS)\n", (void *)CALLER_ADDR0, (void *)CALLER_ADDR1,
(void *)CALLER_ADDR2);

Call sequence:
sys_sync() -> wakeup_flusher_threads() -> __bdi_start_writeback()

Result of sync after boot up:
~ # sync
TEST: CALLER_ADDR0=(wakeup_flusher_threads+0x9c/0xb8),
CALLER_ADDR1=(__bdi_start_writeback+0x30/0x120),
CALLER_ADDR2=(__bdi_start_writeback+0x3c/0x120)

As you see, the result of CALLER_ADDR1 and CALLER_ADDR2 is wrong.

With this patch, you will be able to see the following result.
~ # sync
TEST: CALLER_ADDR0=(wakeup_flusher_threads+0x9c/0xb8),
CALLER_ADDR1=(sys_sync+0x34/0xac),
CALLER_ADDR2=(ret_fast_syscall+0x0/0x48)

Based on this patch, if you apply the second patch which enables the
arm unwind,
and turning on CONFIG_ARM_UNWIND, you will see the correct result.

What I am currently concerning is if I use unwind info and ftrace's irqsoff,
I presume the ftrace might need architecture specific function to make
irqsoff work correctly.
For example, when I tried to test irqsoff, I got the message from
trace like the following.

     cat-563     0d...    2us+: __irq_svc <-_raw_spin_unlock_irqrestore

Actually I could see the call sequence from the end of the trace.
~~~~~~~~~~~~~~~~~~snip~~~~~~~~~~~~~~~~~~
 => gic_handle_irq
 => __irq_svc
 => _raw_spin_unlock_irqrestore
 => uart_start
 => uart_write
~~~~~~~~~~~~~~~~~~snip~~~~~~~~~~~~~~~~~~
Seeing this call sequences, the output need to be
'_raw_spin_unlock_irqrestore <- uart_start'.
But, the CALLER_ADDR1 in trace_hardirqs_off() returned correct value.
So there's no problem in output.
I think trace_hardirqs_off() should call CALLER_ADDR1 and CALLER_ADDR2
respectively for its arguments for start_critical_timing(). This
thought leads me to the necessity of creating architecture specific
trace_hardirqs_off function. Any opinion on this?

-- kpark
