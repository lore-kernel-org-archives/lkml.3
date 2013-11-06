Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab3KFTbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:31:08 -0500
Received: from host171.canaca.com ([67.55.55.225]:50295 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab3KFTbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:31:06 -0500
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org, Elias Vanderstuyft <elias.vds@gmail.com>,
        =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@prifuk.cz>
Subject: [PATCH 2/5] HID:hid-lg4ff: Switch autocentering off when strength is set to zero.
Date: Wed,  6 Nov 2013 12:30:41 -0700
Message-Id: <1383766244-2336-2-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383766244-2336-1-git-send-email-simon@mungewell.org>
References: <1383766244-2336-1-git-send-email-simon@mungewell.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the autocenter is set to zero, this patch issues a command to
totally disable the autocenter - this results in less resistance
in the wheel.

Reported-by: Elias Vanderstuyft <elias.vds@gmail.com>
Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-lg4ff.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 530fcd19..49f6cc0 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -220,6 +220,20 @@ static void hid_lg4ff_set_autocenter_default(struct input_dev *dev, u16 magnitud
 	__s32 *value = report->field[0]->value;
 	__u32 expand_a, expand_b;
 
+	/* De-activate Auto-Center */
+	if (magnitude == 0) {
+		value[0] = 0xf5;
+		value[1] = 0x00;
+		value[2] = 0x00;
+		value[3] = 0x00;
+		value[4] = 0x00;
+		value[5] = 0x00;
+		value[6] = 0x00;
+
+		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
+		return;
+	}
+
 	if (magnitude <= 0xaaaa) {
 		expand_a = 0x0c * magnitude;
 		expand_b = 0x80 * magnitude;
@@ -237,6 +251,17 @@ static void hid_lg4ff_set_autocenter_default(struct input_dev *dev, u16 magnitud
 	value[6] = 0x00;
 
 	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
+
+	/* Activate Auto-Center */
+	value[0] = 0x14;
+	value[1] = 0x00;
+	value[2] = 0x00;
+	value[3] = 0x00;
+	value[4] = 0x00;
+	value[5] = 0x00;
+	value[6] = 0x00;
+
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 }
 
 /* Sends autocentering command compatible with Formula Force EX */
-- 
1.8.1.2

