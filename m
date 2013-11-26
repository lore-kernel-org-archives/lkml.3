Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab3KZPJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 10:09:01 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:54179 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab3KZPI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 10:08:58 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Amir Shehata <amir.shehata@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v2 10/12] staging/lustre/ptlrpc: Fix a crash when dereferencing NULL pointer
Date: Tue, 26 Nov 2013 23:04:44 +0800
Message-Id: <1385478286-5525-11-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385478286-5525-1-git-send-email-bergwolf@gmail.com>
References: <1385478286-5525-1-git-send-email-bergwolf@gmail.com>
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
index 499e4be..23b259d 100644
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

