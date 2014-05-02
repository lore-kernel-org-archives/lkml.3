Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaEBQO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:14:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43906 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbaEBPmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:42:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 070/151] mfd: max8998: Fix possible NULL pointer dereference on i2c_new_dummy error
Date: Fri,  2 May 2014 08:37:38 -0700
Message-Id: <1399045139-4531-71-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mfd/max8998.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index fe6332d..25e131a 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -215,6 +215,10 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 	mutex_init(&max8998->iolock);
 
 	max8998->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
+	if (!max8998->rtc) {
+		dev_err(&i2c->dev, "Failed to allocate I2C device for RTC\n");
+		return -ENODEV;
+	}
 	i2c_set_clientdata(max8998->rtc, max8998);
 
 	max8998_irq_init(max8998);
-- 
1.9.1

