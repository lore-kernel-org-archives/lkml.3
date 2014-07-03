Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079AbaGCPKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:10:45 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:60421 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758553AbaGCPIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:08:14 -0400
From: nick.dyer@itdev.co.uk
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Warren <swarren@nvidia.com>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 03/15] Input: atmel_mxt_ts - set pointer emulation on touchpads
Date: Thu,  3 Jul 2014 16:01:25 +0100
Message-Id: <1404399697-26484-4-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benson Leung <bleung@chromium.org>

Touchpads are pointers, so make sure to pass the correct values to
input_mt_report_pointer_emulation(). Without this, tap-to-click doesn't
work.

Signed-off-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index a248414..31113c3 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -654,10 +654,11 @@ static void mxt_input_button(struct mxt_data *data, struct mxt_message *message)
 	}
 }
 
-static void mxt_input_sync(struct input_dev *input_dev)
+static void mxt_input_sync(struct mxt_data *data)
 {
-	input_mt_report_pointer_emulation(input_dev, false);
-	input_sync(input_dev);
+	input_mt_report_pointer_emulation(data->input_dev,
+					  data->pdata->t19_num_keys);
+	input_sync(data->input_dev);
 }
 
 static void mxt_input_touchevent(struct mxt_data *data,
@@ -707,7 +708,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 		if (status & MXT_T9_RELEASE) {
 			input_mt_report_slot_state(input_dev,
 						   MT_TOOL_FINGER, 0);
-			mxt_input_sync(input_dev);
+			mxt_input_sync(data);
 		}
 
 		/* Touch active */
@@ -783,7 +784,7 @@ static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 	} while (reportid != 0xff);
 
 	if (update_input)
-		mxt_input_sync(data->input_dev);
+		mxt_input_sync(data);
 
 	return IRQ_HANDLED;
 }
-- 
2.0.1

