Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaD1Bb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42934 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Lee Jones" <lee.jones@linaro.org>,
        "Krzysztof Kozlowski" <k.kozlowski@samsung.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.272433196@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 55/94] mfd: 88pm860x: Fix possible NULL pointer
 dereference on i2c_new_dummy error
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 159ce52a6b777fc82fa0b51c7440e25f9e4c6feb upstream.

During probe the driver allocates dummy I2C device for companion chip
with i2c_new_dummy() but it does not check the return value of this call.

In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later used
by regmap_init_i2c().

If i2c_new_dummy() fails for companion device, fail also the probe for
main MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
[bwh: Backported to 3.2:
 - Adjust filename, context
 - Add kfree() before return, as driver is not using managed allocations]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mfd/88pm860x-i2c.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/mfd/88pm860x-i2c.c
+++ b/drivers/mfd/88pm860x-i2c.c
@@ -290,6 +290,12 @@ static int __devinit pm860x_probe(struct
 		chip->companion_addr = pdata->companion_addr;
 		chip->companion = i2c_new_dummy(chip->client->adapter,
 						chip->companion_addr);
+		if (!chip->companion) {
+			dev_err(&client->dev,
+				"Failed to allocate I2C companion device\n");
+			kfree(chip);
+			return -ENODEV;
+		}
 		i2c_set_clientdata(chip->companion, chip);
 	}
 

