Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3FGIWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:22:45 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:40084 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab3FGIWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:22:42 -0400
From: Adam Lee <adam.lee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: platform-driver-x86@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Alex Hung <alex.hung@canonical.com>, Bjorn Mork <bjorn@mork.no>
Subject: [PATCH 2/3] thinkpad_acpi: add the ability setting TPACPI_LED_NONE by quirk
Date: Fri,  7 Jun 2013 16:20:08 +0800
Message-Id: <1370593209-21358-3-git-send-email-adam.lee@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
References: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some new Lenovo or ThinkPad laptops don't have EC controllable LEDs,
their LED quirks are 0. This patch set led_supported=TPACPI_LED_NONE
when quirk equals 0.

Signed-off-by: Adam Lee <adam.lee@canonical.com>
---
 drivers/platform/x86/thinkpad_acpi.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index bea57ae..2fb1f1c 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5327,6 +5327,16 @@ static int __init led_init(struct ibm_init_struct *iibm)
 
 	led_supported = led_init_detect_mode();
 
+	if (led_supported != TPACPI_LED_NONE) {
+		useful_leds = tpacpi_check_quirks(led_useful_qtable,
+				ARRAY_SIZE(led_useful_qtable));
+
+		if (!useful_leds) {
+			led_handle = NULL;
+			led_supported = TPACPI_LED_NONE;
+		}
+	}
+
 	vdbg_printk(TPACPI_DBG_INIT, "LED commands are %s, mode %d\n",
 		str_supported(led_supported), led_supported);
 
@@ -5340,9 +5350,6 @@ static int __init led_init(struct ibm_init_struct *iibm)
 		return -ENOMEM;
 	}
 
-	useful_leds = tpacpi_check_quirks(led_useful_qtable,
-					  ARRAY_SIZE(led_useful_qtable));
-
 	for (i = 0; i < TPACPI_LED_NUMLEDS; i++) {
 		if (!tpacpi_is_led_restricted(i) &&
 		    test_bit(i, &useful_leds)) {
-- 
1.7.10.4

