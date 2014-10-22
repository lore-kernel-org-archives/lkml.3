Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbaJVTNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:13:31 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49619 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbaJVTN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:13:27 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] eeepc-laptop: document fan_pwm conversions
Date: Wed, 22 Oct 2014 21:12:42 +0200
Message-Id: <1414005163-3461-8-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eeepc_get_fan_pwm and eeepc_set_fan_pwm convert the PWM value read from
the fan to a range lmsensors understands. Unfortunately this is only
clear if you are familiar with how lmsensors handles duty cycles.

Introduce two conversion functions that document the goal of these
conversions.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index f820bb3..275a239 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -974,18 +974,28 @@ static struct platform_driver platform_driver = {
 #define EEEPC_EC_SFB0      0xD0
 #define EEEPC_EC_FAN_CTRL  (EEEPC_EC_SFB0 + 3) /* Byte containing SF25  */
 
+static inline int eeepc_pwm_to_lmsensors(int value)
+{
+	return value * 255 / 100;
+}
+
+static inline int eeepc_lmsensors_to_pwm(int value)
+{
+	value = clamp_val(value, 0, 255);
+	return value * 100 / 255;
+}
+
 static int eeepc_get_fan_pwm(void)
 {
 	u8 value = 0;
 
 	ec_read(EEEPC_EC_FAN_PWM, &value);
-	return value * 255 / 100;
+	return eeepc_pwm_to_lmsensors(value);
 }
 
 static void eeepc_set_fan_pwm(int value)
 {
-	value = clamp_val(value, 0, 255);
-	value = value * 100 / 255;
+	value = eeepc_lmsensors_to_pwm(value);
 	ec_write(EEEPC_EC_FAN_PWM, value);
 }
 
-- 
2.1.0

