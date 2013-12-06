Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab3LFNDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:03:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44317 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248Ab3LFNDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Simon Wood <simon@mungewell.org>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 159/272] HID:hid-lg4ff: Switch autocentering off when strength is set to zero.
Date: Fri,  6 Dec 2013 12:57:28 +0000
Message-Id: <1386334761-25517-160-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Wood <simon@mungewell.org>

commit d2c02da549b468bbb28e67d269bd3c9e10683ff5 upstream.

When the autocenter is set to zero, this patch issues a command to
totally disable the autocenter - this results in less resistance
in the wheel.

Reported-by: Elias Vanderstuyft <elias.vds@gmail.com>
Signed-off-by: Simon Wood <simon@mungewell.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.8.3.2

