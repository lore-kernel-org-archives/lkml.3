Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab3CLBUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 21:20:49 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22681 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3CLBUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 21:20:47 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355126400"; 
   d="scan'208";a="28617223"
Message-ID: <513E82EE.2040407@codeaurora.org>
Date: Mon, 11 Mar 2013 18:20:46 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] ARM: smp_twd: Divorce smp_twd from local timer
 API
References: <20130308180730.GE11806@atomide.com> <513A2B20.30805@codeaurora.org> <20130308194802.GG11806@atomide.com> <513A40EF.8050403@codeaurora.org> <20130308200811.GJ11806@atomide.com> <513A4774.3040605@codeaurora.org> <20130308202947.GK11806@atomide.com> <513A8B22.5030008@codeaurora.org> <20130311172847.GP26093@atomide.com> <513E5804.3050104@codeaurora.org> <20130311225004.GR26093@atomide.com>
In-Reply-To: <20130311225004.GR26093@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/13 15:50, Tony Lindgren wrote:
> * Stephen Boyd <sboyd@codeaurora.org> [130311 15:22]:
>> Ok. qemu works for me before applying my patches. I've added this into
>> the series before this patch to fix the boot issue.
> OK thanks:
>
>

Actually, it's worse. From reading the code it looks like quite a few
other machines register a clockevent and get jiffies going so they can
calibrate the twd. I also see that Rob Herring's pull request to move
smp_twd to CLKSRC_OF_DECLARE is going to conflict with any changes I
make in the board files. I think we need to make the twd use the
late_time_init callback if there is no clock rate and ignore the other
patch I sent out a few hours ago. Basically, squash this into this 3/10
patch.

----8<-----

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index a1185d3..c58918f 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -90,8 +90,10 @@ static int twd_timer_ack(void)
 	return 0;
 }
 
-static void twd_timer_stop(struct clock_event_device *clk)
+static void twd_timer_stop(void)
 {
+	struct clock_event_device *clk = __this_cpu_ptr(twd_evt);
+
 	twd_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
 	disable_percpu_irq(clk->irq);
 }
@@ -265,8 +267,9 @@ static void twd_get_clock(struct device_node *np)
 /*
  * Setup the local clock events for a CPU.
  */
-static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
+static void __cpuinit twd_timer_setup(void)
 {
+	struct clock_event_device *clk = __this_cpu_ptr(twd_evt);
 	int cpu = smp_processor_id();
 
 	/*
@@ -275,9 +278,9 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	 */
 	if (per_cpu(percpu_setup_called, cpu)) {
 		__raw_writel(0, twd_base + TWD_TIMER_CONTROL);
-		clockevents_register_device(__this_cpu_ptr(twd_evt));
+		clockevents_register_device(clk);
 		enable_percpu_irq(clk->irq, 0);
-		return 0;
+		return;
 	}
 	per_cpu(percpu_setup_called, cpu) = true;
 
@@ -302,20 +305,18 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
 					0xf, 0xffffffff);
 	enable_percpu_irq(clk->irq, 0);
 
-	return 0;
+	return;
 }
 
 static int __cpuinit twd_timer_cpu_notify(struct notifier_block *self,
 					   unsigned long action, void *hcpu)
 {
-	struct clock_event_device *evt = this_cpu_ptr(twd_evt);
-
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_STARTING:
-		twd_timer_setup(evt);
+		twd_timer_setup();
 		break;
 	case CPU_DYING:
-		twd_timer_stop(evt);
+		twd_timer_stop();
 		break;
 	}
 
@@ -348,8 +349,15 @@ static int __init twd_local_timer_common_register(struct device_node *np)
 
 	twd_get_clock(np);
 
-	/* Immediately configure the timer on the boot CPU */
-	twd_timer_setup(this_cpu_ptr(twd_evt));
+	/*
+	 * Immediately configure the timer on the boot CPU, unless we need
+	 * jiffies to be incrementing to calibrate the rate in which case
+	 * setup the timer in late_time_init.
+	 */
+	if (twd_timer_rate)
+		twd_timer_setup();
+	else
+		late_time_init = twd_timer_setup;
 
 	return 0;
 

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

