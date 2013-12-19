Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3LSMra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:47:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44829 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab3LSL5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 086/208] [SCSI] bfa: Fix crash when symb name set for offline vport
Date: Thu, 19 Dec 2013 11:53:04 +0000
Message-Id: <1387454106-19326-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijaya Mohan Guvva <vmohan@brocade.com>

commit 22a08538dca5c0630226f1c0c58dccd12e463d22 upstream.

This patch fixes a crash when tried setting symbolic name for an offline
vport through sysfs. Crash is due to uninitialized pointer lport->ns,
which gets initialized only on linkup (port online).

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/bfa/bfa_fcs.h       |  1 +
 drivers/scsi/bfa/bfa_fcs_lport.c | 14 +++++++++++---
 drivers/scsi/bfa/bfad_attr.c     |  7 ++-----
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index 94d5d01..42bcb97 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -296,6 +296,7 @@ wwn_t bfa_fcs_lport_get_rport(struct bfa_fcs_lport_s *port, wwn_t wwn,
 struct bfa_fcs_lport_s *bfa_fcs_lookup_port(struct bfa_fcs_s *fcs,
 					    u16 vf_id, wwn_t lpwwn);
 
+void bfa_fcs_lport_set_symname(struct bfa_fcs_lport_s *port, char *symname);
 void bfa_fcs_lport_get_info(struct bfa_fcs_lport_s *port,
 			    struct bfa_lport_info_s *port_info);
 void bfa_fcs_lport_get_attr(struct bfa_fcs_lport_s *port,
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 2f61a5a..f5e4e61 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -1097,6 +1097,17 @@ bfa_fcs_lport_init(struct bfa_fcs_lport_s *lport,
 	bfa_sm_send_event(lport, BFA_FCS_PORT_SM_CREATE);
 }
 
+void
+bfa_fcs_lport_set_symname(struct bfa_fcs_lport_s *port,
+				char *symname)
+{
+	strcpy(port->port_cfg.sym_name.symname, symname);
+
+	if (bfa_sm_cmp_state(port, bfa_fcs_lport_sm_online))
+		bfa_fcs_lport_ns_util_send_rspn_id(
+			BFA_FCS_GET_NS_FROM_PORT(port), NULL);
+}
+
 /*
  *  fcs_lport_api
  */
@@ -5140,9 +5151,6 @@ bfa_fcs_lport_ns_util_send_rspn_id(void *cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	u8 *psymbl = &symbl[0];
 	int len;
 
-	if (!bfa_sm_cmp_state(port, bfa_fcs_lport_sm_online))
-		return;
-
 	/* Avoid sending RSPN in the following states. */
 	if (bfa_sm_cmp_state(ns, bfa_fcs_lport_ns_sm_offline) ||
 	    bfa_sm_cmp_state(ns, bfa_fcs_lport_ns_sm_plogi_sending) ||
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index e9a681d..40be670 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -593,11 +593,8 @@ bfad_im_vport_set_symbolic_name(struct fc_vport *fc_vport)
 		return;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	if (strlen(sym_name) > 0) {
-		strcpy(fcs_vport->lport.port_cfg.sym_name.symname, sym_name);
-		bfa_fcs_lport_ns_util_send_rspn_id(
-			BFA_FCS_GET_NS_FROM_PORT((&fcs_vport->lport)), NULL);
-	}
+	if (strlen(sym_name) > 0)
+		bfa_fcs_lport_set_symname(&fcs_vport->lport, sym_name);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 }
 
-- 
1.8.3.2

