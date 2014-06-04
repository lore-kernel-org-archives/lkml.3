Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbaFDXxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:53:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbaFDXXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.14 217/228] powerpc: irq work racing with timer interrupt can result in timer interrupt hang
Date: Wed,  4 Jun 2014 16:24:06 -0700
Message-Id: <20140604232355.010193017@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 8050936caf125fbe54111ba5e696b68a360556ba upstream.

I am seeing an issue where a CPU running perf eventually hangs.
Traces show timer interrupts happening every 4 seconds even
when a userspace task is running on the CPU. /proc/timer_list
also shows pending hrtimers have not run in over an hour,
including the scheduler.

Looking closer, decrementers_next_tb is getting set to
0xffffffffffffffff, and at that point we will never take
a timer interrupt again.

In __timer_interrupt() we set decrementers_next_tb to
0xffffffffffffffff and rely on ->event_handler to update it:

        *next_tb = ~(u64)0;
        if (evt->event_handler)
                evt->event_handler(evt);

In this case ->event_handler is hrtimer_interrupt. This will eventually
call back through the clockevents code with the next event to be
programmed:

static int decrementer_set_next_event(unsigned long evt,
                                      struct clock_event_device *dev)
{
        /* Don't adjust the decrementer if some irq work is pending */
        if (test_irq_work_pending())
                return 0;
        __get_cpu_var(decrementers_next_tb) = get_tb_or_rtc() + evt;

If irq work came in between these two points, we will return
before updating decrementers_next_tb and we never process a timer
interrupt again.

This looks to have been introduced by 0215f7d8c53f (powerpc: Fix races
with irq_work). Fix it by removing the early exit and relying on
code later on in the function to force an early decrementer:

       /* We may have raced with new irq work */
       if (test_irq_work_pending())
               set_dec(1);

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/time.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -805,9 +805,6 @@ static void __init clocksource_init(void
 static int decrementer_set_next_event(unsigned long evt,
 				      struct clock_event_device *dev)
 {
-	/* Don't adjust the decrementer if some irq work is pending */
-	if (test_irq_work_pending())
-		return 0;
 	__get_cpu_var(decrementers_next_tb) = get_tb_or_rtc() + evt;
 	set_dec(evt);
 


