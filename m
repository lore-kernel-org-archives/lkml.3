Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaBMF2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 00:28:10 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48402 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaBMF2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 00:28:07 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Andrew Duggan <aduggan@synaptics.com>,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/11] Input: synaptics-rmi4 - fix LTS handling in F01
Date: Wed, 12 Feb 2014 21:27:50 -0800
Message-Id: <1392269277-16391-4-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christopher Heiny <cheiny@synaptics.com>

Both F01_RMI_Ctrl2 and F01_RMI_Ctrl3 (doze_interval and wakeup_threshold)
are controlled by the has_adjustable_doze bit.

Signed-off-by: Christopher Heiny<cheiny@synaptics.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/rmi4/rmi_f01.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
index 976aba3..30e0b50 100644
--- a/drivers/input/rmi4/rmi_f01.c
+++ b/drivers/input/rmi4/rmi_f01.c
@@ -328,6 +328,9 @@ static int rmi_f01_initialize(struct rmi_function *fn)
 		}
 	}
 
+	if (data->properties.has_lts)
+		ctrl_base_addr++;
+
 	if (data->properties.has_adjustable_doze_holdoff) {
 		data->doze_holdoff_addr = ctrl_base_addr;
 		ctrl_base_addr++;
@@ -383,7 +386,7 @@ static int rmi_f01_config(struct rmi_function *fn)
 		dev_err(&fn->dev, "Failed to write interrupt enable.\n");
 		return retval;
 	}
-	if (data->properties.has_lts) {
+	if (data->properties.has_adjustable_doze) {
 		retval = rmi_write_block(fn->rmi_dev, data->doze_interval_addr,
 					 &data->device_control.doze_interval,
 					 sizeof(u8));
@@ -391,9 +394,7 @@ static int rmi_f01_config(struct rmi_function *fn)
 			dev_err(&fn->dev, "Failed to write doze interval.\n");
 			return retval;
 		}
-	}
 
-	if (data->properties.has_adjustable_doze) {
 		retval = rmi_write_block(fn->rmi_dev,
 					 data->wakeup_threshold_addr,
 					 &data->device_control.wakeup_threshold,
-- 
1.8.5.3

