Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936261AbaICXqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:46:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933318AbaICWFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:05:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.10 21/55] hwmon: (lm85) Fix various errors on attribute writes
Date: Wed,  3 Sep 2014 15:05:11 -0700
Message-Id: <20140903220457.313895831@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220453.653576908@linuxfoundation.org>
References: <20140903220453.653576908@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 3248c3b771ddd9d31695da17ba350eb6e1b80a53 upstream.

Temperature limit register writes did not account for negative numbers.
As a result, writing -127000 resulted in -126000 written into the
temperature limit register. This problem affected temp[1-3]_min,
temp[1-3]_max, temp[1-3]_auto_temp_crit, and temp[1-3]_auto_temp_min.

When writing pwm[1-3]_freq, a long variable was auto-converted into an int
without range check. Wiring values larger than MAXINT resulted in unexpected
register values.

When writing temp[1-3]_auto_temp_max, an unsigned long variable was
auto-converted into an int without range check. Writing values larger than
MAXINT resulted in unexpected register values.

vrm is an u8, so the written value needs to be limited to [0, 255].

Cc: Axel Lin <axel.lin@ingics.com>
Reviewed-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/lm85.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -158,7 +158,7 @@ static inline u16 FAN_TO_REG(unsigned lo
 
 /* Temperature is reported in .001 degC increments */
 #define TEMP_TO_REG(val)	\
-		clamp_val(SCALE(val, 1000, 1), -127, 127)
+		DIV_ROUND_CLOSEST(clamp_val((val), -127000, 127000), 1000)
 #define TEMPEXT_FROM_REG(val, ext)	\
 		SCALE(((val) << 4) + (ext), 16, 1000)
 #define TEMP_FROM_REG(val)	((val) * 1000)
@@ -192,7 +192,7 @@ static const int lm85_range_map[] = {
 	13300, 16000, 20000, 26600, 32000, 40000, 53300, 80000
 };
 
-static int RANGE_TO_REG(int range)
+static int RANGE_TO_REG(long range)
 {
 	int i;
 
@@ -214,7 +214,7 @@ static const int adm1027_freq_map[8] = {
 	11, 15, 22, 29, 35, 44, 59, 88
 };
 
-static int FREQ_TO_REG(const int *map, int freq)
+static int FREQ_TO_REG(const int *map, unsigned long freq)
 {
 	int i;
 
@@ -463,6 +463,9 @@ static ssize_t store_vrm_reg(struct devi
 	if (err)
 		return err;
 
+	if (val > 255)
+		return -EINVAL;
+
 	data->vrm = val;
 	return count;
 }


