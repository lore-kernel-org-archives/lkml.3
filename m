Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935168AbaE2OUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:20:43 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59328 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933164AbaE2Nta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 031/103] HID: core: do not scan constant input report
Date: Thu, 29 May 2014 15:48:16 +0200
Message-Id: <3802414792ab9256690acb4897e02102fb4bab67.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 30abb14ff618..0335f86502c2 100644
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
1.9.3

