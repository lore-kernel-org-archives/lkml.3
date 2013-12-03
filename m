Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3LCOGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:06:33 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60663 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3LCOEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:04:45 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Amir Shehata <amir.shehata@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v3 09/15] staging/lustre/ptlrpc: Fix a crash when dereferencing NULL pointer
Date: Tue,  3 Dec 2013 21:58:47 +0800
Message-Id: <1386079133-6459-10-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
References: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amir Shehata <amir.shehata@intel.com>

When a system runs out of memory and the function
ptlrpc_register_bulk() is called from ptl_send_rpc() the call to
LNetMEAttach() fails due to failure to allocate memory.  This forces
the code into an error path, which most probably previously went
untested.  The error path:
if (rc != 0) {
        CERROR("%s: LNetMEAttach failed x"LPU64"/%d: rc = %dn",
                desc->bd_export->exp_obd->obd_name, xid,
                posted_md, rc);
        break;
}
This print assumes that desc->bd_export is not NULL.  However, it is.
In fact it is expected to be NULL.  desc->bd_import is the correct
structure to access in this case.

Lustre-change: http://review.whamcloud.com/7121
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3585
Cc: stable <stable@vger.kernel.org> # 3.12
Signed-off-by: Amir Shehata <amir.shehata@intel.com>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Doug Oucharek <doug.s.oucharek@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
index 5f2aa7a..3c6bf23 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
@@ -180,7 +180,7 @@ int ptlrpc_register_bulk(struct ptlrpc_request *req)
 				  LNET_UNLINK, LNET_INS_AFTER, &me_h);
 		if (rc != 0) {
 			CERROR("%s: LNetMEAttach failed x"LPU64"/%d: rc = %d\n",
-			       desc->bd_export->exp_obd->obd_name, xid,
+			       desc->bd_import->imp_obd->obd_name, xid,
 			       posted_md, rc);
 			break;
 		}
@@ -190,7 +190,7 @@ int ptlrpc_register_bulk(struct ptlrpc_request *req)
 				  &desc->bd_mds[posted_md]);
 		if (rc != 0) {
 			CERROR("%s: LNetMDAttach failed x"LPU64"/%d: rc = %d\n",
-			       desc->bd_export->exp_obd->obd_name, xid,
+			       desc->bd_import->imp_obd->obd_name, xid,
 			       posted_md, rc);
 			rc2 = LNetMEUnlink(me_h);
 			LASSERT(rc2 == 0);
@@ -220,7 +220,7 @@ int ptlrpc_register_bulk(struct ptlrpc_request *req)
 	/* Holler if peer manages to touch buffers before he knows the xid */
 	if (desc->bd_md_count != total_md)
 		CWARN("%s: Peer %s touched %d buffers while I registered\n",
-		      desc->bd_export->exp_obd->obd_name, libcfs_id2str(peer),
+		      desc->bd_import->imp_obd->obd_name, libcfs_id2str(peer),
 		      total_md - desc->bd_md_count);
 	spin_unlock(&desc->bd_lock);
 
-- 
1.7.9.5

