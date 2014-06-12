Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaFLXSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:18:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaFLXSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:18:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@dev.mellanox.co.il>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 05/19] iser-target: Fix multi network portal shutdown regression
Date: Thu, 12 Jun 2014 16:21:42 -0700
Message-Id: <20140612232138.875151411@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232138.561318739@linuxfoundation.org>
References: <20140612232138.561318739@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c     |    1 +
 drivers/target/iscsi/iscsi_target_tpg.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

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
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -184,7 +184,8 @@ static void iscsit_clear_tpg_np_login_th
 		return;
 	}
 
-	tpg_np->tpg_np->enabled = false;
+	if (shutdown)
+		tpg_np->tpg_np->enabled = false;
 	iscsit_reset_np_thread(tpg_np->tpg_np, tpg_np, tpg, shutdown);
 }
 


