Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaFWIs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:48:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55555 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Sagi Grimberg <sagig@dev.mellanox.co.il>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 064/111] iser-target: Fix multi network portal shutdown regression
Date: Mon, 23 Jun 2014 10:31:39 +0200
Message-Id: <a51660781e72c3663e4e7f7a09b625a38c3d1f1a.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2363d196686e44c0158929e7cf96c8589a24a81b upstream.

This patch fixes a iser-target specific regression introduced in
v3.15-rc6 with:

commit 14f4b54fe38f3a8f8392a50b951c8aa43b63687a
Author: Sagi Grimberg <sagig@mellanox.com>
Date:   Tue Apr 29 13:13:47 2014 +0300

    Target/iscsi,iser: Avoid accepting transport connections during stop stage

where the change to set iscsi_np->enabled = false within
iscsit_clear_tpg_np_login_thread() meant that a iscsi_np with
two iscsi_tpg_np exports would have it's parent iscsi_np set
to a disabled state, even if other iscsi_tpg_np exports still
existed.

This patch changes iscsit_clear_tpg_np_login_thread() to only
set iscsi_np->enabled = false when shutdown = true, and also
changes iscsit_del_np() to set iscsi_np->enabled = true when
iscsi_np->np_exports is non zero.

Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/iscsi/iscsi_target.c     | 1 +
 drivers/target/iscsi/iscsi_target_tpg.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 004e484a71cd..6f69e4e3af8c 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -460,6 +460,7 @@ int iscsit_del_np(struct iscsi_np *np)
 	spin_lock_bh(&np->np_thread_lock);
 	np->np_exports--;
 	if (np->np_exports) {
+		np->enabled = true;
 		spin_unlock_bh(&np->np_thread_lock);
 		return 0;
 	}
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index adc9393f79e5..b713d63a86f7 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -184,7 +184,8 @@ static void iscsit_clear_tpg_np_login_thread(
 		return;
 	}
 
-	tpg_np->tpg_np->enabled = false;
+	if (shutdown)
+		tpg_np->tpg_np->enabled = false;
 	iscsit_reset_np_thread(tpg_np->tpg_np, tpg_np, tpg, shutdown);
 }
 
-- 
2.0.0

