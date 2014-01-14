Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaANA2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:28:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbaANA2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.12 48/77] ARM: fix footbridge clockevent device
Date: Mon, 13 Jan 2014 16:28:09 -0800
Message-Id: <20140114002753.873693293@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 4ff859fe1dc0da0f87bbdfff78f527898878fa4a upstream.

The clockevents code was being told that the footbridge clock event
device ticks at 16x the rate which it actually does.  This leads to
timekeeping problems since it allows the clocksource to wrap before
the kernel notices.  Fix this by using the correct clock.

Fixes: 4e8d76373c9fd ("ARM: footbridge: convert to clockevents/clocksource")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-footbridge/dc21285-timer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-footbridge/dc21285-timer.c
+++ b/arch/arm/mach-footbridge/dc21285-timer.c
@@ -96,11 +96,12 @@ static struct irqaction footbridge_timer
 void __init footbridge_timer_init(void)
 {
 	struct clock_event_device *ce = &ckevt_dc21285;
+	unsigned rate = DIV_ROUND_CLOSEST(mem_fclk_21285, 16);
 
-	clocksource_register_hz(&cksrc_dc21285, (mem_fclk_21285 + 8) / 16);
+	clocksource_register_hz(&cksrc_dc21285, rate);
 
 	setup_irq(ce->irq, &footbridge_timer_irq);
 
 	ce->cpumask = cpumask_of(smp_processor_id());
-	clockevents_config_and_register(ce, mem_fclk_21285, 0x4, 0xffffff);
+	clockevents_config_and_register(ce, rate, 0x4, 0xffffff);
 }


