Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934697AbaGXJsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:48:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55069 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600AbaGXJsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 094/128] hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div
Date: Thu, 24 Jul 2014 10:45:43 +0100
Message-Id: <1406195177-8656-95-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 1035a9e3e9c76b64a860a774f5b867d28d34acc2 upstream.

Writing to fanX_div does not clear the cache. As a result, reading
from fanX_div may return the old value for up to two seconds
after writing a new value.

This patch ensures the fan_div cache is updated in set_fan_div().

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/adm1029.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwmon/adm1029.c b/drivers/hwmon/adm1029.c
index 9ee5e066423b..39441e5d922c 100644
--- a/drivers/hwmon/adm1029.c
+++ b/drivers/hwmon/adm1029.c
@@ -232,6 +232,9 @@ static ssize_t set_fan_div(struct device *dev,
 	/* Update the value */
 	reg = (reg & 0x3F) | (val << 6);
 
+	/* Update the cache */
+	data->fan_div[attr->index] = reg;
+
 	/* Write value */
 	i2c_smbus_write_byte_data(client,
 				  ADM1029_REG_FAN_DIV[attr->index], reg);
-- 
1.9.1

