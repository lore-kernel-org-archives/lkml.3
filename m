Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbaGVWXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:23:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44527 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbaGVWXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:23:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 084/116] iio: adc: at91: signedness bug in at91_adc_get_trigger_value_by_name()
Date: Tue, 22 Jul 2014 15:21:35 -0700
Message-Id: <1406067727-19683-85-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4f3bcd878f1d3c730fe00f619b7260c6125d49eb upstream.

at91_adc_get_trigger_value_by_name() was returning -ENOMEM truncated to
a positive u8 and that doesn't work.  I've changed it to int and
refactored it to preserve the error code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Tested-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iio/adc/at91_adc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index a526c0e..aa78185 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -157,12 +157,11 @@ static int at91_adc_channel_init(struct iio_dev *idev)
 	return idev->num_channels;
 }
 
-static u8 at91_adc_get_trigger_value_by_name(struct iio_dev *idev,
+static int at91_adc_get_trigger_value_by_name(struct iio_dev *idev,
 					     struct at91_adc_trigger *triggers,
 					     const char *trigger_name)
 {
 	struct at91_adc_state *st = iio_priv(idev);
-	u8 value = 0;
 	int i;
 
 	for (i = 0; i < st->trigger_number; i++) {
@@ -175,15 +174,16 @@ static u8 at91_adc_get_trigger_value_by_name(struct iio_dev *idev,
 			return -ENOMEM;
 
 		if (strcmp(trigger_name, name) == 0) {
-			value = triggers[i].value;
 			kfree(name);
-			break;
+			if (triggers[i].value == 0)
+				return -EINVAL;
+			return triggers[i].value;
 		}
 
 		kfree(name);
 	}
 
-	return value;
+	return -EINVAL;
 }
 
 static int at91_adc_configure_trigger(struct iio_trigger *trig, bool state)
@@ -193,14 +193,14 @@ static int at91_adc_configure_trigger(struct iio_trigger *trig, bool state)
 	struct iio_buffer *buffer = idev->buffer;
 	struct at91_adc_reg_desc *reg = st->registers;
 	u32 status = at91_adc_readl(st, reg->trigger_register);
-	u8 value;
+	int value;
 	u8 bit;
 
 	value = at91_adc_get_trigger_value_by_name(idev,
 						   st->trigger_list,
 						   idev->trig->name);
-	if (value == 0)
-		return -EINVAL;
+	if (value < 0)
+		return value;
 
 	if (state) {
 		st->buffer = kmalloc(idev->scan_bytes, GFP_KERNEL);
-- 
1.9.1

