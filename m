Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaBZWod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:44:33 -0500
Received: from arlo.cworth.org ([50.126.95.6]:51972 "EHLO arlo.cworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbaBZWo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:44:27 -0500
From: Carl Worth <cworth@cworth.org>
To: Ping Cheng <pingc@wacom.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carl Worth <cworth@cworth.org>
Subject: [PATCH 3/3] Input: wacom - Avoid incorrect sign extension from pressure-value lower byte
Date: Wed, 26 Feb 2014 14:38:16 -0800
Message-Id: <1393454296-32735-4-git-send-email-cworth@cworth.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393454296-32735-3-git-send-email-cworth@cworth.org>
References: <1393454296-32735-1-git-send-email-cworth@cworth.org>
 <1393454296-32735-2-git-send-email-cworth@cworth.org>
 <1393454296-32735-3-git-send-email-cworth@cworth.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, whenever the lower byte was greater than 127, the sign
extension of the "char" during integer promotion would result in a
negative value for pressure. There was code in place to adjust a
negative value back to positive by subtracting from pressure_max, but
this code was only correct with a tablet with a maximum of 256
pressure values.

By switching from "char" to "unsigned char" we can avoid the sign
extension altogether, eliminate the code to adjust values, and obtain
correct pressure results.

With this code in place, I am now obtaining correct pressure results
from the Wacom tablet built into a ThinkPad Yoga laptop. (Prior to
this fix, gradual increases of pressure would result in pressure
values that would reset from 255 to 0 rathern than simply increasing.)

Signed-off-by: Carl Worth <cworth@cworth.org>
---
 drivers/input/tablet/wacom_wac.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 563f197..93f7440 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -1018,8 +1018,7 @@ static int wacom_tpc_single_touch(struct wacom_wac *wacom, size_t len)
 
 static int wacom_tpc_pen(struct wacom_wac *wacom)
 {
-	struct wacom_features *features = &wacom->features;
-	char *data = wacom->data;
+	unsigned char *data = wacom->data;
 	struct input_dev *input = wacom->input;
 	int pressure;
 	bool prox = data[1] & 0x20;
@@ -1038,8 +1037,6 @@ static int wacom_tpc_pen(struct wacom_wac *wacom)
 		input_report_abs(input, ABS_X, le16_to_cpup((__le16 *)&data[2]));
 		input_report_abs(input, ABS_Y, le16_to_cpup((__le16 *)&data[4]));
 		pressure = (data[7] << 8) | data[6];
-		if (pressure < 0)
-			pressure = features->pressure_max + pressure + 1;
 		input_report_abs(input, ABS_PRESSURE, pressure);
 		input_report_key(input, BTN_TOUCH, data[1] & 0x05);
 		input_report_key(input, wacom->tool[0], prox);
-- 
1.9.0

