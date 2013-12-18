Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab3LRWNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:13:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab3LRVLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:11:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Roger Lucas <vt8231@hiddenengine.co.uk>,
        Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 3.10 17/78] hwmon: Prevent some divide by zeros in FAN_TO_REG()
Date: Wed, 18 Dec 2013 13:10:45 -0800
Message-Id: <20131218211112.391854002@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3806b45ba4655147a011df03242cc197ab986c43 upstream.

The "rpm * div" operations can overflow here, so this patch adds an
upper limit to rpm to prevent that.  Jean Delvare helped me with this
patch.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Roger Lucas <vt8231@hiddenengine.co.uk>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/lm78.c    |    2 ++
 drivers/hwmon/sis5595.c |    2 ++
 drivers/hwmon/vt8231.c  |    2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -94,6 +94,8 @@ static inline u8 FAN_TO_REG(long rpm, in
 {
 	if (rpm <= 0)
 		return 255;
+	if (rpm > 1350000)
+		return 1;
 	return clamp_val((1350000 + rpm * div / 2) / (rpm * div), 1, 254);
 }
 
--- a/drivers/hwmon/sis5595.c
+++ b/drivers/hwmon/sis5595.c
@@ -141,6 +141,8 @@ static inline u8 FAN_TO_REG(long rpm, in
 {
 	if (rpm <= 0)
 		return 255;
+	if (rpm > 1350000)
+		return 1;
 	return clamp_val((1350000 + rpm * div / 2) / (rpm * div), 1, 254);
 }
 
--- a/drivers/hwmon/vt8231.c
+++ b/drivers/hwmon/vt8231.c
@@ -145,7 +145,7 @@ static const u8 regtempmin[] = { 0x3a, 0
  */
 static inline u8 FAN_TO_REG(long rpm, int div)
 {
-	if (rpm == 0)
+	if (rpm <= 0 || rpm > 1310720)
 		return 0;
 	return clamp_val(1310720 / (rpm * div), 1, 255);
 }


