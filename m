Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934673AbaE2Fge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:36:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239AbaE2Ee5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.14 028/140] HID: core: do not scan constant input report
Date: Wed, 28 May 2014 21:32:47 -0700
Message-Id: <20140529043052.979264443@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -718,6 +718,9 @@ static int hid_scan_main(struct hid_pars
 	case HID_MAIN_ITEM_TAG_END_COLLECTION:
 		break;
 	case HID_MAIN_ITEM_TAG_INPUT:
+		/* ignore constant inputs, they will be ignored by hid-input */
+		if (data & HID_MAIN_ITEM_CONSTANT)
+			break;
 		for (i = 0; i < parser->local.usage_index; i++)
 			hid_scan_input_usage(parser, parser->local.usage[i]);
 		break;


