Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab3BVSQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:16:50 -0500
Received: from [89.21.227.133] ([89.21.227.133]:53942 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759019Ab3BVSIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:32 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 34/40] Input: atmel_mxt_ts - Remove mxt_make_highchg
Date: Fri, 22 Feb 2013 17:58:21 +0000
Message-Id: <1361555907-19840-35-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading all messages until an invalid is received is a way of forcing the CHG
line high, which means that when using edge-triggered interrupts the interrupt
can be acquired.

This only papers over the problem because the interrupt may still be lost
during message reading (although this is very rare), so it is better to either

1) Use level-triggered interrupts
or
2) Use edge-triggered interrupts and enable the RETRIGEN feature in T18
   COMMSCONFIG

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 6dbd3d6..83a0837 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1925,14 +1925,9 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 		mxt_initialize(data);
 	}
 
-	if (data->state == APPMODE) {
+	if (data->state == APPMODE)
 		enable_irq(data->irq);
 
-		error = mxt_process_messages_until_invalid(data);
-		if (error)
-			return error;
-	}
-
 	return count;
 }
 
@@ -2205,12 +2200,6 @@ static int mxt_probe(struct i2c_client *client,
 		goto err_free_object;
 	}
 
-	if (data->state == APPMODE) {
-		error = mxt_process_messages_until_invalid(data);
-		if (error)
-			goto err_free_irq;
-	}
-
 	error = sysfs_create_group(&client->dev.kobj, &mxt_attr_group);
 	if (error) {
 		dev_err(&client->dev, "Failure %d creating sysfs group\n",
-- 
1.7.10.4

