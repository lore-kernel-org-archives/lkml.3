Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3KFTbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:31:05 -0500
Received: from host171.canaca.com ([67.55.55.225]:50291 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab3KFTbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:31:01 -0500
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org, Elias Vanderstuyft <elias.vds@gmail.com>,
        =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@prifuk.cz>
Subject: [PATCH 1/5] HID:hid-lg4ff: Scale autocentering force properly on Logitech wheel
Date: Wed,  6 Nov 2013 12:30:40 -0700
Message-Id: <1383766244-2336-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.8.1.2
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

Adjust the scaling and lineartity to match that of the Windows
driver (from MOMO testing).

Reported-by: Elias Vanderstuyft <elias.vds@gmail.com>
Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-lg4ff.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 8782fe1..530fcd19 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -218,12 +218,21 @@ static void hid_lg4ff_set_autocenter_default(struct input_dev *dev, u16 magnitud
 	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
 	__s32 *value = report->field[0]->value;
+	__u32 expand_a, expand_b;
+
+	if (magnitude <= 0xaaaa) {
+		expand_a = 0x0c * magnitude;
+		expand_b = 0x80 * magnitude;
+	} else {
+		expand_a = (0x0c * 0xaaaa) + 0x06 * (magnitude - 0xaaaa);
+		expand_b = (0x80 * 0xaaaa) + 0xff * (magnitude - 0xaaaa);
+	}
 
 	value[0] = 0xfe;
 	value[1] = 0x0d;
-	value[2] = magnitude >> 13;
-	value[3] = magnitude >> 13;
-	value[4] = magnitude >> 8;
+	value[2] = expand_a / 0xaaaa;
+	value[3] = expand_a / 0xaaaa;
+	value[4] = expand_b / 0xaaaa;
 	value[5] = 0x00;
 	value[6] = 0x00;
 
-- 
1.8.1.2

