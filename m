Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbaIWCkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:40:18 -0400
Received: from mail.kernel.org ([198.145.19.201]:38374 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbaIWCkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:40:14 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 29/45] HID: magicmouse: sanity check report size in raw_event() callback
Date: Tue, 23 Sep 2014 10:31:31 +0800
Message-Id: <1411439507-30391-29-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit c54def7bd64d7c0b6993336abcffb8444795bf38 upstream.

The report passed to us from transport driver could potentially be
arbitrarily large, therefore we better sanity-check it so that
magicmouse_emit_touch() gets only valid values of raw_id.

Reported-by: Steven Vittitoe <scvitti@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/hid/hid-magicmouse.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 7cf3ffe..81356f6 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -308,6 +308,11 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		if (size < 4 || ((size - 4) % 9) != 0)
 			return 0;
 		npoints = (size - 4) / 9;
+		if (npoints > 15) {
+			hid_warn(hdev, "invalid size value (%d) for TRACKPAD_REPORT_ID\n",
+					size);
+			return 0;
+		}
 		msc->ntouches = 0;
 		for (ii = 0; ii < npoints; ii++)
 			magicmouse_emit_touch(msc, ii, data + ii * 9 + 4);
@@ -331,6 +336,11 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		if (size < 6 || ((size - 6) % 8) != 0)
 			return 0;
 		npoints = (size - 6) / 8;
+		if (npoints > 15) {
+			hid_warn(hdev, "invalid size value (%d) for MOUSE_REPORT_ID\n",
+					size);
+			return 0;
+		}
 		msc->ntouches = 0;
 		for (ii = 0; ii < npoints; ii++)
 			magicmouse_emit_touch(msc, ii, data + ii * 8 + 6);
-- 
1.7.9.5

