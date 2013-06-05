Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473Ab3FEWIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:08:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab3FEVfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [ 009/127] ARM: at91: rm9200 fix time support
Date: Wed,  5 Jun 2013 14:32:56 -0700
Message-Id: <20130605213219.075152773@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

commit b7a8ca5173ef9aa55fa039d7c216426ff0b25a12 upstream.

since commit 838a2ae80a6ab52139fb1bf0a93ea8c5eff94488
Author: Shawn Guo <shawn.guo@linaro.org>
Date:   Sat Jan 12 11:50:05 2013 +0000

ARM: use clockevents_config_and_register() where possible

The timer is wrongly configured and result in a nice crash
so revert it on rm9200 timer.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-at91/at91rm9200_time.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-at91/at91rm9200_time.c
+++ b/arch/arm/mach-at91/at91rm9200_time.c
@@ -174,6 +174,7 @@ clkevt32k_next_event(unsigned long delta
 static struct clock_event_device clkevt = {
 	.name		= "at91_tick",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.shift		= 32,
 	.rating		= 150,
 	.set_next_event	= clkevt32k_next_event,
 	.set_mode	= clkevt32k_mode,
@@ -264,9 +265,11 @@ void __init at91rm9200_timer_init(void)
 	at91_st_write(AT91_ST_RTMR, 1);
 
 	/* Setup timer clockevent, with minimum of two ticks (important!!) */
+	clkevt.mult = div_sc(AT91_SLOW_CLOCK, NSEC_PER_SEC, clkevt.shift);
+	clkevt.max_delta_ns = clockevent_delta2ns(AT91_ST_ALMV, &clkevt);
+	clkevt.min_delta_ns = clockevent_delta2ns(2, &clkevt) + 1;
 	clkevt.cpumask = cpumask_of(0);
-	clockevents_config_and_register(&clkevt, AT91_SLOW_CLOCK,
-					2, AT91_ST_ALMV);
+	clockevents_register_device(&clkevt);
 
 	/* register clocksource */
 	clocksource_register_hz(&clk32k, AT91_SLOW_CLOCK);


