Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbaIWCpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:45:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:38401 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbaIWCkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:40:17 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 30/45] HID: picolcd: sanity check report size in raw_event() callback
Date: Tue, 23 Sep 2014 10:31:32 +0800
Message-Id: <1411439507-30391-30-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 844817e47eef14141cf59b8d5ac08dd11c0a9189 upstream.

The report passed to us from transport driver could potentially be
arbitrarily large, therefore we better sanity-check it so that raw_data
that we hold in picolcd_pending structure are always kept within proper
bounds.

Reported-by: Steven Vittitoe <scvitti@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[lizf: Backported to 3.4: adjust filename]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/hid/hid-picolcd.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 95f9047..4e37b1f 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -2370,6 +2370,12 @@ static int picolcd_raw_event(struct hid_device *hdev,
 	if (!data)
 		return 1;
 
+	if (size > 64) {
+		hid_warn(hdev, "invalid size value (%d) for picolcd raw event\n",
+				size);
+		return 0;
+	}
+
 	if (report->id == REPORT_KEY_STATE) {
 		if (data->input_keys)
 			ret = picolcd_raw_keypad(data, report, raw_data+1, size-1);
-- 
1.7.9.5

