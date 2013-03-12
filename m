Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563Ab3CLWdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:33:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab3CLWci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 003/100] ARM: 7653/2: do not scale loops_per_jiffy when using a constant delay clock
Date: Tue, 12 Mar 2013 15:30:48 -0700
Message-Id: <20130312223123.259378413@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <nicolas.pitre@linaro.org>

commit 70264367a243a68b1d5636ffb570183449803cbe upstream.

When udelay() is implemented using an architected timer, it is wrong
to scale loops_per_jiffy when changing the CPU clock frequency since
the timer clock remains constant.

The lpj should probably become an implementation detail relevant to
the CPU loop based delay routine only and more confined to it. In the
mean time this is the minimal fix needed to have expected delays with
the timer based implementation when cpufreq is also in use.

Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Nicolas Pitre <nico@linaro.org>
Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Liviu Dudau <Liviu.Dudau@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/delay.h |    1 +
 arch/arm/kernel/smp.c        |    3 +++
 arch/arm/lib/delay.c         |    1 +
 3 files changed, 5 insertions(+)

--- a/arch/arm/include/asm/delay.h
+++ b/arch/arm/include/asm/delay.h
@@ -24,6 +24,7 @@ extern struct arm_delay_ops {
 	void (*delay)(unsigned long);
 	void (*const_udelay)(unsigned long);
 	void (*udelay)(unsigned long);
+	bool const_clock;
 } arm_delay_ops;
 
 #define __delay(n)		arm_delay_ops.delay(n)
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -693,6 +693,9 @@ static int cpufreq_callback(struct notif
 	if (freq->flags & CPUFREQ_CONST_LOOPS)
 		return NOTIFY_OK;
 
+	if (arm_delay_ops.const_clock)
+		return NOTIFY_OK;
+
 	if (!per_cpu(l_p_j_ref, cpu)) {
 		per_cpu(l_p_j_ref, cpu) =
 			per_cpu(cpu_data, cpu).loops_per_jiffy;
--- a/arch/arm/lib/delay.c
+++ b/arch/arm/lib/delay.c
@@ -77,6 +77,7 @@ void __init register_current_timer_delay
 		arm_delay_ops.delay		= __timer_delay;
 		arm_delay_ops.const_udelay	= __timer_const_udelay;
 		arm_delay_ops.udelay		= __timer_udelay;
+		arm_delay_ops.const_clock	= true;
 		delay_calibrated		= true;
 	} else {
 		pr_info("Ignoring duplicate/late registration of read_current_timer delay\n");


