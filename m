Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116AbaKROos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:44:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467AbaKROKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:03 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joern Engel <joern@logfs.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 111/206] qla_target: don't delete changed nacls
Date: Tue, 18 Nov 2014 15:07:46 +0100
Message-Id: <769e28594544e6662fdbe69086b8162e04b8cf86.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joern Engel <joern@logfs.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f4c24db1b7ad0ce84409e15744d26c6f86a96840 upstream.

The code is currently riddled with "drop the hardware_lock to avoid a
deadlock" bugs that expose races.  One of those races seems to expose a
valid warning in tcm_qla2xxx_clear_nacl_from_fcport_map.  Add some
bandaid to it.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index f85b9e5c1f05..80a1f9f40aac 100644
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
2.1.3

