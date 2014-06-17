Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966820AbaFQVvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:51:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54578 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966802AbaFQVvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 133/212] target: Don't allow setting WC emulation if device doesn't support
Date: Tue, 17 Jun 2014 14:43:47 -0700
Message-Id: <1403041506-13646-134-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Grover <agrover@redhat.com>

commit 07b8dae38b09bcfede7e726f172e39b5ce8390d9 upstream.

Just like for pSCSI, if the transport sets get_write_cache, then it is
not valid to enable write cache emulation for it. Return an error.

see https://bugzilla.redhat.com/show_bug.cgi?id=1082675

Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/target_core_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index d06de84..8d27ba6 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -798,10 +798,10 @@ int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
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
1.9.1

