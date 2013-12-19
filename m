Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3LSL77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:59:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45349 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3LSL75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Jean Delvare <khali@linux-fr.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 190/208] hwmon: Prevent some divide by zeros in FAN_TO_REG()
Date: Thu, 19 Dec 2013 11:54:48 +0000
Message-Id: <1387454106-19326-191-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3806b45ba4655147a011df03242cc197ab986c43 upstream.

The "rpm * div" operations can overflow here, so this patch adds an
upper limit to rpm to prevent that.  Jean Delvare helped me with this
patch.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Roger Lucas <vt8231@hiddenengine.co.uk>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/lm78.c    | 2 ++
 drivers/hwmon/sis5595.c | 2 ++
 drivers/hwmon/vt8231.c  | 2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/lm78.c b/drivers/hwmon/lm78.c
index 6cf6bff..a2f3b4a 100644
--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -94,6 +94,8 @@ static inline u8 FAN_TO_REG(long rpm, int div)
 {
 	if (rpm <= 0)
 		return 255;
+	if (rpm > 1350000)
+		return 1;
 	return clamp_val((1350000 + rpm * div / 2) / (rpm * div), 1, 254);
 }
 
diff --git a/drivers/hwmon/sis5595.c b/drivers/hwmon/sis5595.c
index 1404e63..72a8897 100644
--- a/drivers/hwmon/sis5595.c
+++ b/drivers/hwmon/sis5595.c
@@ -141,6 +141,8 @@ static inline u8 FAN_TO_REG(long rpm, int div)
 {
 	if (rpm <= 0)
 		return 255;
+	if (rpm > 1350000)
+		return 1;
 	return clamp_val((1350000 + rpm * div / 2) / (rpm * div), 1, 254);
 }
 
diff --git a/drivers/hwmon/vt8231.c b/drivers/hwmon/vt8231.c
index 0e70178..aee14e2 100644
--- a/drivers/hwmon/vt8231.c
+++ b/drivers/hwmon/vt8231.c
@@ -145,7 +145,7 @@ static const u8 regtempmin[] = { 0x3a, 0x3e, 0x2c, 0x2e, 0x30, 0x32 };
  */
 static inline u8 FAN_TO_REG(long rpm, int div)
 {
-	if (rpm == 0)
+	if (rpm <= 0 || rpm > 1310720)
 		return 0;
 	return clamp_val(1310720 / (rpm * div), 1, 255);
 }
-- 
1.8.3.2

