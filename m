Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbaGPAWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:22:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758570AbaGOXNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Axel Lin <axel.lin@ingics.com>
Subject: [PATCH 3.4 06/22] hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div
Date: Tue, 15 Jul 2014 16:17:11 -0700
Message-Id: <20140715231622.314011812@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231622.121816073@linuxfoundation.org>
References: <20140715231622.121816073@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/adm1029.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hwmon/adm1029.c
+++ b/drivers/hwmon/adm1029.c
@@ -231,6 +231,9 @@ static ssize_t set_fan_div(struct device
 	/* Update the value */
 	reg = (reg & 0x3F) | (val << 6);
 
+	/* Update the cache */
+	data->fan_div[attr->index] = reg;
+
 	/* Write value */
 	i2c_smbus_write_byte_data(client,
 				  ADM1029_REG_FAN_DIV[attr->index], reg);


