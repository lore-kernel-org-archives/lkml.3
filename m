Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab3LBTfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:35:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab3LBTS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Elias Vanderstuyft <elias.vds@gmail.com>,
        Simon Wood <simon@mungewell.org>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.12 181/212] HID:hid-lg4ff: Scale autocentering force properly on Logitech wheel
Date: Mon,  2 Dec 2013 11:16:12 -0800
Message-Id: <20131202191308.690305989@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Wood <simon@mungewell.org>

commit f8c231569a7a455dfa1907294a46ba52b3aa8859 upstream.

Adjust the scaling and lineartity to match that of the Windows
driver (from MOMO testing).

Reported-by: Elias Vanderstuyft <elias.vds@gmail.com>
Signed-off-by: Simon Wood <simon@mungewell.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-lg4ff.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -218,12 +218,21 @@ static void hid_lg4ff_set_autocenter_def
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
 


