Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3FGJHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:07:48 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:56965 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab3FGJHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:07:44 -0400
From: Adam Lee <adam.lee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: platform-driver-x86@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Alex Hung <alex.hung@canonical.com>, Bjorn Mork <bjorn@mork.no>
Subject: [PATCH v2] thinkpad_acpi: return -NODEV while operating uninitialized LEDs
Date: Fri,  7 Jun 2013 17:05:32 +0800
Message-Id: <1370595932-29889-1-git-send-email-adam.lee@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
References: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all 0-15 LEDs are available for all models, sometimes it's even not
safe. This patch return -NODEV while operating uninitialized LEDs.

Signed-off-by: Adam Lee <adam.lee@canonical.com>
---
 drivers/platform/x86/thinkpad_acpi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 54d31c0..d2ac4e8 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5401,9 +5401,12 @@ static int led_write(char *buf)
 		return -ENODEV;
 
 	while ((cmd = next_cmd(&buf))) {
-		if (sscanf(cmd, "%d", &led) != 1 || led < 0 || led > 15)
+		if (sscanf(cmd, "%d", &led) != 1 || led < 0 || led > (TPACPI_LED_NUMLEDS -1))
 			return -EINVAL;
 
+		if (!tpacpi_leds[led].led)
+			return -ENODEV;
+
 		if (strstr(cmd, "off")) {
 			s = TPACPI_LED_OFF;
 		} else if (strstr(cmd, "on")) {
-- 
1.7.10.4

