Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161697Ab3LFNDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:03:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44307 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243Ab3LFNDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Simon Wood <simon@mungewell.org>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 158/272] HID:hid-lg4ff: Scale autocentering force properly on Logitech wheel
Date: Fri,  6 Dec 2013 12:57:27 +0000
Message-Id: <1386334761-25517-159-git-send-email-luis.henriques@canonical.com>
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

commit f8c231569a7a455dfa1907294a46ba52b3aa8859 upstream.

Adjust the scaling and lineartity to match that of the Windows
driver (from MOMO testing).

Reported-by: Elias Vanderstuyft <elias.vds@gmail.com>
Signed-off-by: Simon Wood <simon@mungewell.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.8.3.2

