Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaC1NGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:06:15 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8841 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaC1NGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:06:11 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-35-533573c18a7d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 3/3] clocksource: exynos_mct: Fix too early ISR fire up on
 wrong CPU
Date: Fri, 28 Mar 2014 14:06:02 +0100
Message-id: <1396011962-4467-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396011962-4467-1-git-send-email-k.kozlowski@samsung.com>
References: <1396011962-4467-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4Fd2DxabBBguvCFhsnLGe1WLeZ1mL
	1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txdojd9ktFmx8xGixfsZrFovNm6YyO/B4
	3Lm2h83j3blz7B6bl9R79G1ZxejxeZNcAGsUl01Kak5mWWqRvl0CV8b1CcuYCh7wVOzb2c7a
	wHiTq4uRk0NCwERiQUM/G4QtJnHh3nowW0hgKaPEnwbzLkYuILuPSWLbxe9gCTYBY4nNy5ew
	gSREBJ4ySvxueMQI4jALNDJJLN7+E8jh4BAWCJP4+KIMpIFFQFViyeKrzCA2r4CbxJm2TlaQ
	EgkBBYk5k2xAwpwC7hIn5j5nh1jsJrHt2k+2CYy8CxgZVjGKppYmFxQnpeca6RUn5haX5qXr
	JefnbmKEBODXHYxLj1kdYhTgYFTi4Z1hZRIsxJpYVlyZe4hRgoNZSYR3ia1psBBvSmJlVWpR
	fnxRaU5q8SFGJg5OqQbG9C3TZPeEFs1brMF80q2qcfWPKwJpMdclihT2H+TXYXldaXbd76+4
	0ofk8z9aBEJii43zp3RkObWqrTUSfzRl/8Rtsc823cor/S/Qq8G3+vUGkb/NTltU4h84hFis
	KZ3oE2j3K/1mcaidRNykq1v/Ts18LHn6dqrxHqtbhwvSui6skS/d8oVViaU4I9FQi7moOBEA
	vZImiR4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After hotplugging CPU1 the first call of interrupt handler for CPU1
oneshot timer was called on CPU0 because it fired up before setting IRQ
affinity. Affected are SoCs where Multi Core Timer interrupts are shared
(SPI), e.g. Exynos 4210.

During setup of the MCT timers the clock event device should be
registered after setting the affinity for interrupt. This will prevent
starting the timer too early.

Additionally, if clock event device has interrupt set up, the
clockevents_config_and_register() will also set the affinity for it.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
---
 drivers/clocksource/exynos_mct.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 2ac7d228743a..f9c9a1d41f2a 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -418,8 +418,6 @@ static int exynos4_local_timer_setup(struct clock_event_device *evt)
 	evt->set_mode = exynos4_tick_set_mode;
 	evt->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
 	evt->rating = 450;
-	clockevents_config_and_register(evt, clk_rate / (TICK_BASE_CNT + 1),
-					0xf, 0x7fffffff);
 
 	exynos4_mct_write(TICK_BASE_CNT, mevt->base + MCT_L_TCNTB_OFFSET);
 
@@ -435,6 +433,8 @@ static int exynos4_local_timer_setup(struct clock_event_device *evt)
 	} else {
 		enable_percpu_irq(mct_irqs[MCT_L0_IRQ], 0);
 	}
+	clockevents_config_and_register(evt, clk_rate / (TICK_BASE_CNT + 1),
+					0xf, 0x7fffffff);
 
 	return 0;
 }
-- 
1.7.9.5

