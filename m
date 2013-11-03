Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3KCRwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 12:52:53 -0500
Received: from 12.mo6.mail-out.ovh.net ([178.32.125.228]:56807 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753904Ab3KCRwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 12:52:51 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Fabio Porcedda <fabio.porcedda@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Guenter Roeck <groeck7@gmail.com>, Yang Wenyou <wenyou.yang@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH 2/3] watchdog: at91sam9_wdt: avoid spurious watchdog reset during init
Date: Sun,  3 Nov 2013 18:52:43 +0100
Message-Id: <1383501164-8111-3-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383501164-8111-1-git-send-email-b.brezillon@overkiz.com>
References: <1383501164-8111-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 10214445430178085050
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrhedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrhedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the min_heartbeat value instead of the calculated heartbeat value for
the first watchdog reset to avoid spurious watchdog reset.

Resetting the watchdog counter during init might lead to a watchdog fault
reset because the watchdog counter has to be running for at least
min_heartbeat.

Resetting the watchdog counter after heartbeat might lead to a watchdog
timeout reset because the watchdog counter is running for more than
max_heartbeat time.

Using min_heartbeat instead of heartbeat does not guarantee that the
watchdog won't trigger a reset, but at least it reduces the chances to be
in such a case.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/watchdog/at91sam9_wdt.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 65f4691..ab0c4e0 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -213,7 +213,15 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
 			 tmp & wdt->mr_mask, wdt->mr & wdt->mr_mask);
 
 	setup_timer(&wdt->timer, at91_ping, (unsigned long)wdt);
-	mod_timer(&wdt->timer, jiffies + wdt->heartbeat);
+
+	/*
+	 * Use min_heartbeat the first time to avoid spurious watchdog reset:
+	 * we don't know for how long the watchdog counter is running, and
+	 *  - resetting it right now might trigger a watchdog fault reset
+	 *  - waiting for heartbeat time might lead to a watchdog timeout
+	 *    reset
+	 */
+	mod_timer(&wdt->timer, jiffies + min_heartbeat);
 
 	/* Try to set timeout from device tree first */
 	if (watchdog_init_timeout(&wdt->wdd, 0, dev))
-- 
1.7.9.5

