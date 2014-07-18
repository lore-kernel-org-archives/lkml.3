Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935018AbaGRNOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:14:15 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17721 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965742AbaGRNOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:14:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Guenter Roeck <linux@roeck-us.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 139/170] hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div
Date: Fri, 18 Jul 2014 14:12:24 +0200
Message-Id: <1a2ce98105c028a662abe9310a4a4b4966010ec1.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1035a9e3e9c76b64a860a774f5b867d28d34acc2 upstream.

Writing to fanX_div does not clear the cache. As a result, reading
from fanX_div may return the old value for up to two seconds
after writing a new value.

This patch ensures the fan_div cache is updated in set_fan_div().

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

