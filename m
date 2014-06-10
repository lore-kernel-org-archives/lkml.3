Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaFJTrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:47:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34808 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaFJTqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:46:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 002/160] HID: core: do not scan constant input report
Date: Tue, 10 Jun 2014 12:44:02 -0700
Message-Id: <1402429600-20477-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit e24d0d399b2fce71b627043e900ef28283850482 upstream.

The Microsoft Surface Type/Touch Cover 2 is a fancy device which advertised
itself as a multitouch device but with constant input reports.
This way, hid_scan_report() gives the group MULTITOUCH to it, but
hid-multitouch can not handle it due to the constant collection ignored
by hid-input.

To prevent such crap in the future, and while we do not fix this particular
device, make the scan_report coherent with hid-input.c, and ignore constant
input reports.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/hid-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 253fe23..12f1a45 100644
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
1.9.1

