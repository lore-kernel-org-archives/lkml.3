Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab3L3JUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 04:20:45 -0500
Received: from hiddenengine.co.uk ([82.71.36.240]:60818 "EHLO
	www.hiddenengine.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3L3JUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 04:20:43 -0500
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Dec 2013 04:20:43 EST
From: <vt8231@hiddenengine.co.uk>
To: "'Ben Hutchings'" <ben@decadent.org.uk>
Cc: <akpm@linux-foundation.org>, "'Roger Lucas'" <vt8231@hiddenengine.co.uk>,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'Jean Delvare'" <khali@linux-fr.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <lsq.1388282923.751256928@decadent.org.uk> <lsq.1388282924.25256622@decadent.org.uk>
In-Reply-To: <lsq.1388282924.25256622@decadent.org.uk>
Subject: RE: [PATCH 3.2 140/185] hwmon: Prevent some divide by zeros in FAN_TO_REG()
Date: Mon, 30 Dec 2013 09:15:09 -0000
Message-ID: <C83890AC7B9B4C02AB263C79698F8F96@honeybadger>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac8EOyNePbxoqBKlRDegXiGFMT+7hQBA+/Zg
X-MimeOLE: Produced By Microsoft MimeOLE V6.1.7601.17609
x-antivirus: AVG for E-mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

The VT8231 patch looks OK to me.  Thanks for your help.

Best regards,

Roger

-----Original Message-----
From: Ben Hutchings [mailto:ben@decadent.org.uk] 
Sent: 29 December 2013 02:09
To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
Cc: akpm@linux-foundation.org; Roger Lucas; Dan Carpenter; Jean Delvare
Subject: [PATCH 3.2 140/185] hwmon: Prevent some divide by zeros in
FAN_TO_REG()

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3806b45ba4655147a011df03242cc197ab986c43 upstream.

The "rpm * div" operations can overflow here, so this patch adds an
upper limit to rpm to prevent that.  Jean Delvare helped me with this
patch.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Roger Lucas <vt8231@hiddenengine.co.uk>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/lm78.c    | 2 ++
 drivers/hwmon/sis5595.c | 2 ++
 drivers/hwmon/vt8231.c  | 2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -90,6 +90,8 @@ static inline u8 FAN_TO_REG(long rpm, in
 {
 	if (rpm <= 0)
 		return 255;
+	if (rpm > 1350000)
+		return 1;
 	return SENSORS_LIMIT((1350000 + rpm * div / 2) / (rpm * div), 1,
254);
 }
 
--- a/drivers/hwmon/sis5595.c
+++ b/drivers/hwmon/sis5595.c
@@ -133,6 +133,8 @@ static inline u8 FAN_TO_REG(long rpm, in
 {
 	if (rpm <= 0)
 		return 255;
+	if (rpm > 1350000)
+		return 1;
 	return SENSORS_LIMIT((1350000 + rpm * div / 2) / (rpm * div), 1,
254);
 }
 
--- a/drivers/hwmon/vt8231.c
+++ b/drivers/hwmon/vt8231.c
@@ -139,7 +139,7 @@ static const u8 regtempmin[] = { 0x3a, 0
 */
 static inline u8 FAN_TO_REG(long rpm, int div)
 {
-	if (rpm == 0)
+	if (rpm <= 0 || rpm > 1310720)
 		return 0;
 	return SENSORS_LIMIT(1310720 / (rpm * div), 1, 255);
 }


