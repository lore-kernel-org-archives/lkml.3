Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaIEROi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:14:38 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42494 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbaIEROg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:14:36 -0400
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>,
        Darren Hart <dvhart@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH 5/5] toshiba_acpi: Change touchpad store to check for invalid values
Date: Fri,  5 Sep 2014 11:14:07 -0600
Message-Id: <1409937247-2525-6-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
References: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function toshiba_touchpad_store is not checking
for invalid values and simply returns silently.

This patch checks for invalid values and returns accordingly.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 1738171..777fb3c 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1396,12 +1396,18 @@ static ssize_t toshiba_touchpad_store(struct device *dev,
 {
 	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
 	int state;
+	int ret;
 
 	/* Set the TouchPad on/off, 0 - Disable | 1 - Enable */
-	if (sscanf(buf, "%i", &state) == 1 && (state == 0 || state == 1)) {
-		if (toshiba_touchpad_set(toshiba, state) < 0)
-			return -EIO;
-	}
+	ret = kstrtoint(buf, 0, &state);
+	if (ret)
+		return ret;
+	if (state != 0 || state != 1)
+		return -EINVAL;
+
+	ret = toshiba_touchpad_set(toshiba, state);
+	if (ret)
+		return ret;
 
 	return count;
 }
-- 
2.0.0

