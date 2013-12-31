Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab3LaCHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 21:07:44 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:54859 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452Ab3LaCHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 21:07:14 -0500
From: "Felipe F. Tonello" <eu@felipetonello.com>
To: linux-input@vger.kernel.org
Cc: "Felipe F. Tonello" <eu@felipetonello.com>, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 2/2] input: egalax: report end state in suspend callback
Date: Mon, 30 Dec 2013 18:06:41 -0800
Message-Id: <1388455601-17033-3-git-send-email-eu@felipetonello.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388455601-17033-1-git-send-email-eu@felipetonello.com>
References: <1388455601-17033-1-git-send-email-eu@felipetonello.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felipe F. Tonello" <eu@felipetonello.com>

Make sure user-space will receive the touch end event even if the device
driver suspends while touchscreen is still active (with fingers touching it).

Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
---
 drivers/input/touchscreen/egalax_ts.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/input/touchscreen/egalax_ts.c b/drivers/input/touchscreen/egalax_ts.c
index 054d225..9cf4cdb 100644
--- a/drivers/input/touchscreen/egalax_ts.c
+++ b/drivers/input/touchscreen/egalax_ts.c
@@ -247,8 +247,13 @@ static int egalax_ts_suspend(struct device *dev)
 		0x3, 0x6, 0xa, 0x3, 0x36, 0x3f, 0x2, 0, 0, 0
 	};
 	struct i2c_client *client = to_i2c_client(dev);
+	struct egalax_ts *ts = i2c_get_clientdata(client);
 	int ret;
 
+	input_mt_report_end_state(ts->input_dev);
+	input_mt_report_pointer_emulation(ts->input_dev, true);
+	input_sync(ts->input_dev);
+
 	ret = i2c_master_send(client, suspend_cmd, MAX_I2C_DATA_LEN);
 	return ret > 0 ? 0 : ret;
 }
-- 
1.8.3.1

