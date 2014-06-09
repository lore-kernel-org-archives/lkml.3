Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936454AbaFIJ1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:27:48 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936439AbaFIJ1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:27:40 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 118/146] target: Don't allow setting WC emulation if device doesn't support
Date: Mon,  9 Jun 2014 10:50:53 +0200
Message-Id: <86a063701078cb9b6037e0b627d448e5a53d1b7e.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Grover <agrover@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 07b8dae38b09bcfede7e726f172e39b5ce8390d9 upstream.

Just like for pSCSI, if the transport sets get_write_cache, then it is
not valid to enable write cache emulation for it. Return an error.

see https://bugzilla.redhat.com/show_bug.cgi?id=1082675

Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/target_core_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index e5e39658034c..e31ec5cf0c36 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -799,10 +799,10 @@ int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
 		pr_err("emulate_write_cache not supported for pSCSI\n");
 		return -EINVAL;
 	}
-	if (dev->transport->get_write_cache) {
-		pr_warn("emulate_write_cache cannot be changed when underlying"
-			" HW reports WriteCacheEnabled, ignoring request\n");
-		return 0;
+	if (flag &&
+	    dev->transport->get_write_cache) {
+		pr_err("emulate_write_cache not supported for this device\n");
+		return -EINVAL;
 	}
 
 	dev->dev_attrib.emulate_write_cache = flag;
-- 
1.9.3

