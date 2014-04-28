Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaD1Bco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:32:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42927 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Krzysztof Kozlowski" <k.kozlowski@samsung.com>,
        "Lee Jones" <lee.jones@linaro.org>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.423127291@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 53/94] mfd: max8998: Fix possible NULL pointer
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

commit ed26f87b9f71693a1d1ee85f5e6209601505080f upstream.

During probe the driver allocates dummy I2C device for RTC with i2c_new_dummy() but it does not check the return value of this call.

In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later used
by i2c_unregister_device().

If i2c_new_dummy() fails for RTC device, fail also the probe for
main MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mfd/max8998.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -152,6 +152,10 @@ static int max8998_i2c_probe(struct i2c_
 	mutex_init(&max8998->iolock);
 
 	max8998->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
+	if (!max8998->rtc) {
+		dev_err(&i2c->dev, "Failed to allocate I2C device for RTC\n");
+		return -ENODEV;
+	}
 	i2c_set_clientdata(max8998->rtc, max8998);
 
 	max8998_irq_init(max8998);

