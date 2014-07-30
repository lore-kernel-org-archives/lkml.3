Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaG3Btu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:49:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbaG3Btp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 3.14 19/29] hwmon: (smsc47m192) Fix temperature limit and vrm write operations
Date: Tue, 29 Jul 2014 18:48:54 -0700
Message-Id: <20140730014810.142777114@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014809.316066303@linuxfoundation.org>
References: <20140730014809.316066303@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 043572d5444116b9d9ad8ae763cf069e7accbc30 upstream.

Temperature limit clamps are applied after converting the temperature
from milli-degrees C to degrees C, so either the clamp limit needs
to be specified in degrees C, not milli-degrees C, or clamping must
happen before converting to degrees C. Use the latter method to avoid
overflows.

vrm is an u8, so the written value needs to be limited to [0, 255].

Cc: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/smsc47m192.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/smsc47m192.c
+++ b/drivers/hwmon/smsc47m192.c
@@ -86,7 +86,7 @@ static inline u8 IN_TO_REG(unsigned long
  */
 static inline s8 TEMP_TO_REG(int val)
 {
-	return clamp_val(SCALE(val, 1, 1000), -128000, 127000);
+	return SCALE(clamp_val(val, -128000, 127000), 1, 1000);
 }
 
 static inline int TEMP_FROM_REG(s8 val)
@@ -384,6 +384,8 @@ static ssize_t set_vrm(struct device *de
 	err = kstrtoul(buf, 10, &val);
 	if (err)
 		return err;
+	if (val > 255)
+		return -EINVAL;
 
 	data->vrm = val;
 	return count;


