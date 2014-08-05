Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaHEG1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 02:27:21 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:59822 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaHEG1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 02:27:20 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: David Airlie <airlied@linux.ie>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/gma500: mdfld: Reuse video/mipi_display.h
Date: Tue,  5 Aug 2014 08:27:16 +0200
Message-Id: <1407220036-4058-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The GMA500 driver redefines many constants already found in the generic
header. Replace uses of the custom defines by the standard ones and get
rid of the duplicate defininitions.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c | 75 +++++++++++----------------
 drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.h | 12 -----
 2 files changed, 31 insertions(+), 56 deletions(-)

diff --git a/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c b/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c
index 87885d8c06e8..6b43ae3ffd73 100644
--- a/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c
+++ b/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c
@@ -25,6 +25,7 @@
  */
 
 #include <linux/freezer.h>
+#include <video/mipi_display.h>
 
 #include "mdfld_dsi_output.h"
 #include "mdfld_dsi_pkg_sender.h"
@@ -32,20 +33,6 @@
 
 #define MDFLD_DSI_READ_MAX_COUNT		5000
 
-enum data_type {
-	DSI_DT_GENERIC_SHORT_WRITE_0	= 0x03,
-	DSI_DT_GENERIC_SHORT_WRITE_1	= 0x13,
-	DSI_DT_GENERIC_SHORT_WRITE_2	= 0x23,
-	DSI_DT_GENERIC_READ_0		= 0x04,
-	DSI_DT_GENERIC_READ_1		= 0x14,
-	DSI_DT_GENERIC_READ_2		= 0x24,
-	DSI_DT_GENERIC_LONG_WRITE	= 0x29,
-	DSI_DT_DCS_SHORT_WRITE_0	= 0x05,
-	DSI_DT_DCS_SHORT_WRITE_1	= 0x15,
-	DSI_DT_DCS_READ			= 0x06,
-	DSI_DT_DCS_LONG_WRITE		= 0x39,
-};
-
 enum {
 	MDFLD_DSI_PANEL_MODE_SLEEP = 0x1,
 };
@@ -321,9 +308,9 @@ static int send_pkg_prepare(struct mdfld_dsi_pkg_sender *sender, u8 data_type,
 	u8 cmd;
 
 	switch (data_type) {
-	case DSI_DT_DCS_SHORT_WRITE_0:
-	case DSI_DT_DCS_SHORT_WRITE_1:
-	case DSI_DT_DCS_LONG_WRITE:
+	case MIPI_DSI_DCS_SHORT_WRITE:
+	case MIPI_DSI_DCS_SHORT_WRITE_PARAM:
+	case MIPI_DSI_DCS_LONG_WRITE:
 		cmd = *data;
 		break;
 	default:
@@ -334,12 +321,12 @@ static int send_pkg_prepare(struct mdfld_dsi_pkg_sender *sender, u8 data_type,
 	sender->status = MDFLD_DSI_PKG_SENDER_BUSY;
 
 	/*wait for 120 milliseconds in case exit_sleep_mode just be sent*/
-	if (unlikely(cmd == DCS_ENTER_SLEEP_MODE)) {
+	if (unlikely(cmd == MIPI_DCS_ENTER_SLEEP_MODE)) {
 		/*TODO: replace it with msleep later*/
 		mdelay(120);
 	}
 
-	if (unlikely(cmd == DCS_EXIT_SLEEP_MODE)) {
+	if (unlikely(cmd == MIPI_DCS_EXIT_SLEEP_MODE)) {
 		/*TODO: replace it with msleep later*/
 		mdelay(120);
 	}
@@ -352,9 +339,9 @@ static int send_pkg_done(struct mdfld_dsi_pkg_sender *sender, u8 data_type,
 	u8 cmd;
 
 	switch (data_type) {
-	case DSI_DT_DCS_SHORT_WRITE_0:
-	case DSI_DT_DCS_SHORT_WRITE_1:
-	case DSI_DT_DCS_LONG_WRITE:
+	case MIPI_DSI_DCS_SHORT_WRITE:
+	case MIPI_DSI_DCS_SHORT_WRITE_PARAM:
+	case MIPI_DSI_DCS_LONG_WRITE:
 		cmd = *data;
 		break;
 	default:
@@ -362,15 +349,15 @@ static int send_pkg_done(struct mdfld_dsi_pkg_sender *sender, u8 data_type,
 	}
 
 	/*update panel status*/
-	if (unlikely(cmd == DCS_ENTER_SLEEP_MODE)) {
+	if (unlikely(cmd == MIPI_DCS_ENTER_SLEEP_MODE)) {
 		sender->panel_mode |= MDFLD_DSI_PANEL_MODE_SLEEP;
 		/*TODO: replace it with msleep later*/
 		mdelay(120);
-	} else if (unlikely(cmd == DCS_EXIT_SLEEP_MODE)) {
+	} else if (unlikely(cmd == MIPI_DCS_EXIT_SLEEP_MODE)) {
 		sender->panel_mode &= ~MDFLD_DSI_PANEL_MODE_SLEEP;
 		/*TODO: replace it with msleep later*/
 		mdelay(120);
-	} else if (unlikely(cmd == DCS_SOFT_RESET)) {
+	} else if (unlikely(cmd == MIPI_DCS_SOFT_RESET)) {
 		/*TODO: replace it with msleep later*/
 		mdelay(5);
 	}
@@ -405,19 +392,19 @@ static int send_pkg(struct mdfld_dsi_pkg_sender *sender, u8 data_type,
 	}
 
 	switch (data_type) {
-	case DSI_DT_GENERIC_SHORT_WRITE_0:
-	case DSI_DT_GENERIC_SHORT_WRITE_1:
-	case DSI_DT_GENERIC_SHORT_WRITE_2:
-	case DSI_DT_GENERIC_READ_0:
-	case DSI_DT_GENERIC_READ_1:
-	case DSI_DT_GENERIC_READ_2:
-	case DSI_DT_DCS_SHORT_WRITE_0:
-	case DSI_DT_DCS_SHORT_WRITE_1:
-	case DSI_DT_DCS_READ:
+	case MIPI_DSI_GENERIC_SHORT_WRITE_0_PARAM:
+	case MIPI_DSI_GENERIC_SHORT_WRITE_1_PARAM:
+	case MIPI_DSI_GENERIC_SHORT_WRITE_2_PARAM:
+	case MIPI_DSI_GENERIC_READ_REQUEST_0_PARAM:
+	case MIPI_DSI_GENERIC_READ_REQUEST_1_PARAM:
+	case MIPI_DSI_GENERIC_READ_REQUEST_2_PARAM:
+	case MIPI_DSI_DCS_SHORT_WRITE:
+	case MIPI_DSI_DCS_SHORT_WRITE_PARAM:
+	case MIPI_DSI_DCS_READ:
 		ret = send_short_pkg(sender, data_type, data[0], data[1], hs);
 		break;
-	case DSI_DT_GENERIC_LONG_WRITE:
-	case DSI_DT_DCS_LONG_WRITE:
+	case MIPI_DSI_GENERIC_LONG_WRITE:
+	case MIPI_DSI_DCS_LONG_WRITE:
 		ret = send_long_pkg(sender, data_type, data, len, hs);
 		break;
 	}
@@ -440,7 +427,7 @@ int mdfld_dsi_send_mcs_long(struct mdfld_dsi_pkg_sender *sender, u8 *data,
 	}
 
 	spin_lock_irqsave(&sender->lock, flags);
-	send_pkg(sender, DSI_DT_DCS_LONG_WRITE, data, len, hs);
+	send_pkg(sender, MIPI_DSI_DCS_LONG_WRITE, data, len, hs);
 	spin_unlock_irqrestore(&sender->lock, flags);
 
 	return 0;
@@ -461,10 +448,10 @@ int mdfld_dsi_send_mcs_short(struct mdfld_dsi_pkg_sender *sender, u8 cmd,
 	data[0] = cmd;
 
 	if (param_num) {
-		data_type = DSI_DT_DCS_SHORT_WRITE_1;
+		data_type = MIPI_DSI_DCS_SHORT_WRITE_PARAM;
 		data[1] = param;
 	} else {
-		data_type = DSI_DT_DCS_SHORT_WRITE_0;
+		data_type = MIPI_DSI_DCS_SHORT_WRITE;
 		data[1] = 0;
 	}
 
@@ -489,17 +476,17 @@ int mdfld_dsi_send_gen_short(struct mdfld_dsi_pkg_sender *sender, u8 param0,
 
 	switch (param_num) {
 	case 0:
-		data_type = DSI_DT_GENERIC_SHORT_WRITE_0;
+		data_type = MIPI_DSI_GENERIC_SHORT_WRITE_0_PARAM;
 		data[0] = 0;
 		data[1] = 0;
 		break;
 	case 1:
-		data_type = DSI_DT_GENERIC_SHORT_WRITE_1;
+		data_type = MIPI_DSI_GENERIC_SHORT_WRITE_1_PARAM;
 		data[0] = param0;
 		data[1] = 0;
 		break;
 	case 2:
-		data_type = DSI_DT_GENERIC_SHORT_WRITE_2;
+		data_type = MIPI_DSI_GENERIC_SHORT_WRITE_2_PARAM;
 		data[0] = param0;
 		data[1] = param1;
 		break;
@@ -523,7 +510,7 @@ int mdfld_dsi_send_gen_long(struct mdfld_dsi_pkg_sender *sender, u8 *data,
 	}
 
 	spin_lock_irqsave(&sender->lock, flags);
-	send_pkg(sender, DSI_DT_GENERIC_LONG_WRITE, data, len, hs);
+	send_pkg(sender, MIPI_DSI_GENERIC_LONG_WRITE, data, len, hs);
 	spin_unlock_irqrestore(&sender->lock, flags);
 
 	return 0;
@@ -594,7 +581,7 @@ int mdfld_dsi_read_mcs(struct mdfld_dsi_pkg_sender *sender, u8 cmd,
 		return -EINVAL;
 	}
 
-	return __read_panel_data(sender, DSI_DT_DCS_READ, &cmd, 1,
+	return __read_panel_data(sender, MIPI_DSI_DCS_READ, &cmd, 1,
 				data, len, hs);
 }
 
diff --git a/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.h b/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.h
index 459cd7ea8b81..0478a21c15d5 100644
--- a/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.h
+++ b/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.h
@@ -62,18 +62,6 @@ struct mdfld_dsi_pkg_sender {
 	u32 mipi_cmd_len_reg;
 };
 
-/* DCS definitions */
-#define DCS_SOFT_RESET			0x01
-#define DCS_ENTER_SLEEP_MODE		0x10
-#define DCS_EXIT_SLEEP_MODE		0x11
-#define DCS_SET_DISPLAY_OFF		0x28
-#define DCS_SET_DISPLAY_ON		0x29
-#define DCS_SET_COLUMN_ADDRESS		0x2a
-#define DCS_SET_PAGE_ADDRESS		0x2b
-#define DCS_WRITE_MEM_START		0x2c
-#define DCS_SET_TEAR_OFF		0x34
-#define DCS_SET_TEAR_ON			0x35
-
 extern int mdfld_dsi_pkg_sender_init(struct mdfld_dsi_connector *dsi_connector,
 					int pipe);
 extern void mdfld_dsi_pkg_sender_destroy(struct mdfld_dsi_pkg_sender *sender);
-- 
2.0.4

