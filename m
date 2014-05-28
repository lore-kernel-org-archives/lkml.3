Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaE1PAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:00:21 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:59692 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbaE1PAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:00:19 -0400
From: Tord Andersson <tord.o.andersson@gmail.com>
X-Google-Original-From: Tord Andersson <tord.andersson@endian.se>
To: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tord Andersson <tord.andersson@endian.se>
Subject: [PATCH 1/1] watchdog: imx2: Added ioctl options to enable/disable watchdog as wanted by systemd.
Date: Wed, 28 May 2014 16:59:56 +0200
Message-Id: <1401289196-27567-1-git-send-email-tord.andersson@endian.se>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the current imx2 watchdog driver is used with the systemd watchdog feature,
we get "Failed to enable hardware watchdog: Inappropriate ioctl for device".
This is caused by missing ioctl setoptions to enable the watchdog.
This patch will add WDIOC_SETOPTIONS for WDIOS_ENABLECARD and WDIOS_DISABLECARD.

Signed-off-by: Tord Andersson <tord.andersson@endian.se>
---
 drivers/watchdog/imx2_wdt.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index dd51d95..180c6a5 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -196,6 +196,17 @@ static long imx2_wdt_ioctl(struct file *file, unsigned int cmd,
 		new_value = val & IMX2_WDT_WRSR_TOUT ? WDIOF_CARDRESET : 0;
 		return put_user(new_value, p);
 
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		if (new_value & WDIOS_ENABLECARD)
+			imx2_wdt_start();
+		else if (new_value & WDIOS_DISABLECARD)
+			imx2_wdt_stop();
+		else
+			return -EINVAL;
+		return 0;
+
 	case WDIOC_KEEPALIVE:
 		imx2_wdt_ping();
 		return 0;
-- 
1.9.1

