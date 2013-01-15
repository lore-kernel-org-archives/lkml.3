Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab3AOM4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:56:35 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:57176 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab3AOM4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:32 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/26] mfd: ab8500-sysctrl: Only reboot into charging mode if battery type is known
Date: Tue, 15 Jan 2013 12:55:43 +0000
Message-Id: <1358254566-12419-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

When a charger is connected, we usually want AB8500 based systems to
reboot into charging-only mode. However, if the battery type cannot
be identified this would be futile, so we'll just shut the system
down instead.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
---
 drivers/mfd/ab8500-sysctrl.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index 01b0669..26216e7 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -23,6 +23,10 @@ void ab8500_power_off(void)
 	sigset_t all;
 	static char *pss[] = {"ab8500_ac", "ab8500_usb"};
 	int i;
+	bool charger_present = false;
+	union power_supply_propval val;
+	struct power_supply *psy;
+	int ret;
 
 	/*
 	 * If we have a charger connected and we're powering off,
@@ -30,23 +34,36 @@ void ab8500_power_off(void)
 	 */
 
 	for (i = 0; i < ARRAY_SIZE(pss); i++) {
-		union power_supply_propval val;
-		struct power_supply *psy;
-		int ret;
-
 		psy = power_supply_get_by_name(pss[i]);
 		if (!psy)
 			continue;
+
 		ret = psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &val);
 
 		if (!ret && val.intval) {
+			charger_present = true;
+			break;
+		}
+	}
+
+	if (!charger_present)
+		goto shutdown;
+
+	/* Check if battery is known */
+	psy = power_supply_get_by_name("ab8500_btemp");
+	if (psy) {
+		ret = psy->get_property(psy, POWER_SUPPLY_PROP_TECHNOLOGY,
+					&val);
+		if (!ret && val.intval != POWER_SUPPLY_TECHNOLOGY_UNKNOWN) {
 			printk(KERN_INFO
-			       "Charger \"%s\" is connected. Rebooting.\n",
+			       "Charger \"%s\" is connected with known battery."
+			       " Rebooting.\n",
 			       pss[i]);
 			machine_restart(NULL);
 		}
 	}
 
+shutdown:
 	sigfillset(&all);
 
 	if (!sigprocmask(SIG_BLOCK, &all, &old)) {
-- 
1.7.9.5

