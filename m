Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaKFWo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:44:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59138 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbaKFWoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:20 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joern Engel <joern@logfs.org>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 064/162] qla_target: don't delete changed nacls
Date: Thu,  6 Nov 2014 14:35:28 -0800
Message-Id: <1415313426-9622-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joern Engel <joern@logfs.org>

commit f4c24db1b7ad0ce84409e15744d26c6f86a96840 upstream.

The code is currently riddled with "drop the hardware_lock to avoid a
deadlock" bugs that expose races.  One of those races seems to expose a
valid warning in tcm_qla2xxx_clear_nacl_from_fcport_map.  Add some
bandaid to it.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7eb19be..b93f24a 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -740,7 +740,16 @@ static void tcm_qla2xxx_clear_nacl_from_fcport_map(struct qla_tgt_sess *sess)
 	pr_debug("fc_rport domain: port_id 0x%06x\n", nacl->nport_id);
 
 	node = btree_remove32(&lport->lport_fcport_map, nacl->nport_id);
-	WARN_ON(node && (node != se_nacl));
+	if (WARN_ON(node && (node != se_nacl))) {
+		/*
+		 * The nacl no longer matches what we think it should be.
+		 * Most likely a new dynamic acl has been added while
+		 * someone dropped the hardware lock.  It clearly is a
+		 * bug elsewhere, but this bit can't make things worse.
+		 */
+		btree_insert32(&lport->lport_fcport_map, nacl->nport_id,
+			       node, GFP_ATOMIC);
+	}
 
 	pr_debug("Removed from fcport_map: %p for WWNN: 0x%016LX, port_id: 0x%06x\n",
 	    se_nacl, nacl->nport_wwnn, nacl->nport_id);
-- 
1.9.1

