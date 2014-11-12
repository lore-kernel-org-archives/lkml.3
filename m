Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440AbaKLBwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:52:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966217AbaKLBwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:52:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joern Engel <joern@logfs.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 060/123] qla_target: dont delete changed nacls
Date: Wed, 12 Nov 2014 10:17:06 +0900
Message-Id: <20141112011721.751100958@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joern Engel <joern@logfs.org>

commit f4c24db1b7ad0ce84409e15744d26c6f86a96840 upstream.

The code is currently riddled with "drop the hardware_lock to avoid a
deadlock" bugs that expose races.  One of those races seems to expose a
valid warning in tcm_qla2xxx_clear_nacl_from_fcport_map.  Add some
bandaid to it.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -762,7 +762,16 @@ static void tcm_qla2xxx_clear_nacl_from_
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


