Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaDQVk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 17:40:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59906 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaDQVkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 17:40:37 -0400
Date: Thu, 17 Apr 2014 14:40:24 -0700
From: tip-bot for Krzysztof Kozlowski <tipbot@zytor.com>
Message-ID: <tip-8db6e5104b77de5d0b7002b95069da0992a34be9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        k.kozlowski@samsung.com, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        kgene.kim@samsung.com, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, tglx@linutronix.de
In-Reply-To: <20140416143316.299247848@linutronix.de>
References: <20140416143316.299247848@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] clocksource: Exynos_mct:
  Register clock event after request_irq()
Git-Commit-ID: 8db6e5104b77de5d0b7002b95069da0992a34be9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8db6e5104b77de5d0b7002b95069da0992a34be9
Gitweb:     http://git.kernel.org/tip/8db6e5104b77de5d0b7002b95069da0992a34be9
Author:     Krzysztof Kozlowski <k.kozlowski@samsung.com>
AuthorDate: Wed, 16 Apr 2014 14:36:45 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 17 Apr 2014 23:36:28 +0200

clocksource: Exynos_mct: Register clock event after request_irq()

After hotplugging CPU1 the first call of interrupt handler for CPU1
oneshot timer was called on CPU0 because it fired before setting IRQ
affinity. Affected are SoCs where Multi Core Timer interrupts are
shared (SPI), e.g. Exynos 4210.

During setup of the MCT timers the clock event device should be
registered after setting the affinity for interrupt. This will prevent
starting the timer too early.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/20140416143316.299247848@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/exynos_mct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index b2d4163..acf5a32 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -416,8 +416,6 @@ static int exynos4_local_timer_setup(struct clock_event_device *evt)
 	evt->set_mode = exynos4_tick_set_mode;
 	evt->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
 	evt->rating = 450;
-	clockevents_config_and_register(evt, clk_rate / (TICK_BASE_CNT + 1),
-					0xf, 0x7fffffff);
 
 	exynos4_mct_write(TICK_BASE_CNT, mevt->base + MCT_L_TCNTB_OFFSET);
 
@@ -434,6 +432,8 @@ static int exynos4_local_timer_setup(struct clock_event_device *evt)
 	} else {
 		enable_percpu_irq(mct_irqs[MCT_L0_IRQ], 0);
 	}
+	clockevents_config_and_register(evt, clk_rate / (TICK_BASE_CNT + 1),
+					0xf, 0x7fffffff);
 
 	return 0;
 }
