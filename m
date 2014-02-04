Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935071AbaBDWVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:21:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933924AbaBDVIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Amir Shehata <amir.shehata@intel.com>,
        Liang Zhen <liang.zhen@intel.com>,
        Doug Oucharek <doug.s.oucharek@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 3.12 050/133] staging/lustre/ptlrpc: Fix a crash when dereferencing NULL pointer
Date: Tue,  4 Feb 2014 13:07:31 -0800
Message-Id: <20140204210738.449605827@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Shehata <amir.shehata@intel.com>

commit 3c92a0bf4d72737035a16c4fe357ccd439c9b7d2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
@@ -179,7 +179,7 @@ int ptlrpc_register_bulk(struct ptlrpc_r
 				  LNET_UNLINK, LNET_INS_AFTER, &me_h);
 		if (rc != 0) {
 			CERROR("%s: LNetMEAttach failed x"LPU64"/%d: rc = %d\n",
-			       desc->bd_export->exp_obd->obd_name, xid,
+			       desc->bd_import->imp_obd->obd_name, xid,
 			       posted_md, rc);
 			break;
 		}
@@ -189,7 +189,7 @@ int ptlrpc_register_bulk(struct ptlrpc_r
 				  &desc->bd_mds[posted_md]);
 		if (rc != 0) {
 			CERROR("%s: LNetMDAttach failed x"LPU64"/%d: rc = %d\n",
-			       desc->bd_export->exp_obd->obd_name, xid,
+			       desc->bd_import->imp_obd->obd_name, xid,
 			       posted_md, rc);
 			rc2 = LNetMEUnlink(me_h);
 			LASSERT(rc2 == 0);
@@ -219,7 +219,7 @@ int ptlrpc_register_bulk(struct ptlrpc_r
 	/* Holler if peer manages to touch buffers before he knows the xid */
 	if (desc->bd_md_count != total_md)
 		CWARN("%s: Peer %s touched %d buffers while I registered\n",
-		      desc->bd_export->exp_obd->obd_name, libcfs_id2str(peer),
+		      desc->bd_import->imp_obd->obd_name, libcfs_id2str(peer),
 		      total_md - desc->bd_md_count);
 	spin_unlock(&desc->bd_lock);
 


