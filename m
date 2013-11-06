Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab3KFTbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:31:53 -0500
Received: from host171.canaca.com ([67.55.55.225]:50299 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab3KFTbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:31:07 -0500
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org, Elias Vanderstuyft <elias.vds@gmail.com>,
        =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@prifuk.cz>
Subject: [PATCH 3/5] HID:hid-lg4ff: ensure ConstantForce is disabled when set to 0
Date: Wed,  6 Nov 2013 12:30:42 -0700
Message-Id: <1383766244-2336-3-git-send-email-simon@mungewell.org>
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

When 'Constant Force' is set to 0 it is not turned off completely,
the wheel feels 'heavy'. This patch issues the '13 00..' command
to ensure that the force in slot 1 (the Constant Force) is
deactivated.

Reported-by: Elias Vanderstuyft <elias.vds@gmail.com>
Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-lg4ff.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 49f6cc0..5d140b7 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -196,6 +196,21 @@ static int hid_lg4ff_play(struct input_dev *dev, void *data, struct ff_effect *e
 	case FF_CONSTANT:
 		x = effect->u.ramp.start_level + 0x80;	/* 0x80 is no force */
 		CLAMP(x);
+
+		if (x == 0x80) {
+			/* De-activate force in slot-1*/
+			value[0] = 0x13;
+			value[1] = 0x00;
+			value[2] = 0x00;
+			value[3] = 0x00;
+			value[4] = 0x00;
+			value[5] = 0x00;
+			value[6] = 0x00;
+
+			hid_hw_request(hid, report, HID_REQ_SET_REPORT);
+			return 0;
+		}
+
 		value[0] = 0x11;	/* Slot 1 */
 		value[1] = 0x08;
 		value[2] = x;
-- 
1.8.1.2

