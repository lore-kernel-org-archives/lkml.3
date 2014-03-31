Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaCaR1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:27:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbaCaR1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:27:16 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Reyad Attiyat <reyad.attiyat@gmail.com>, Derya <derya.kiran@yahoo.de>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] HID: core: do not scan constant input report
Date: Mon, 31 Mar 2014 13:27:10 -0400
Message-Id: <1396286830-2795-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1396286830-2795-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1396286830-2795-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Microsoft Surface Type/Touch Cover 2 is a fancy device which advertised
itself as a multitouch device but with constant input reports.
This way, hid_scan_report() gives the group MULTITOUCH to it, but
hid-multitouch can not handle it due to the constant collection ignored
by hid-input.

To prevent such crap in the future, and while we do not fix this particular
device, make the scan_report coherent with hid-input.c, and ignore constant
input reports.

CC: stable@vger.kernel.org # 3.12+
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index bb5c494..8a5384c 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -718,6 +718,9 @@ static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
 	case HID_MAIN_ITEM_TAG_END_COLLECTION:
 		break;
 	case HID_MAIN_ITEM_TAG_INPUT:
+		/* ignore constant inputs, they will be ignored by hid-input */
+		if (data & HID_MAIN_ITEM_CONSTANT)
+			break;
 		for (i = 0; i < parser->local.usage_index; i++)
 			hid_scan_input_usage(parser, parser->local.usage[i]);
 		break;
-- 
1.9.0

