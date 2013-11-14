Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3KNQvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:51:52 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:40447 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613Ab3KNQks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:40:48 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 36/39] staging/lustre/build: fix 'no effect' errors
Date: Fri, 15 Nov 2013 00:32:59 +0800
Message-Id: <1384446782-13741-37-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Buisson <sebastien.buisson@bull.net>

Fix 'no effect' issues found by Coverity version 6.5.1:
Unsigned compared against 0 (NO_EFFECT)
This greater-than-or-equal-to-zero comparison of an unsigned value
is always true.

Lustre-change: http://review.whamcloud.com/7166
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3097
Signed-off-by: Sebastien Buisson <sebastien.buisson@bull.net>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/xattr.c     |    5 ++---
 drivers/staging/lustre/lustre/lmv/lmv_obd.c     |    2 +-
 drivers/staging/lustre/lustre/lov/lov_obd.c     |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c |    1 -
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index b6cb0db..b1384ff 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -410,11 +410,10 @@ getxattr_nocache:
 	}
 
 #ifdef CONFIG_FS_POSIX_ACL
-	if (rce && rce->rce_ops == RMT_LSETFACL) {
+	if (rce != NULL && rce->rce_ops == RMT_LSETFACL) {
 		ext_acl_xattr_header *acl;
 
-		acl = lustre_posix_acl_xattr_2ext((posix_acl_xattr_header *)buffer,
-						rc);
+		acl = lustre_posix_acl_xattr_2ext(buffer, rc);
 		if (IS_ERR(acl))
 			GOTO(out, rc = PTR_ERR(acl));
 
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index 2587f1a..d3e7d6b 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -947,7 +947,7 @@ static int lmv_iocontrol(unsigned int cmd, struct obd_export *exp,
 		struct obd_quotactl *oqctl;
 
 		if (qctl->qc_valid == QC_MDTIDX) {
-			if (qctl->qc_idx < 0 || count <= qctl->qc_idx)
+			if (count <= qctl->qc_idx)
 				return -EINVAL;
 
 			tgt = lmv->tgts[qctl->qc_idx];
diff --git a/drivers/staging/lustre/lustre/lov/lov_obd.c b/drivers/staging/lustre/lustre/lov/lov_obd.c
index 4783450..b35a654 100644
--- a/drivers/staging/lustre/lustre/lov/lov_obd.c
+++ b/drivers/staging/lustre/lustre/lov/lov_obd.c
@@ -1982,7 +1982,7 @@ static int lov_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 		struct obd_quotactl *oqctl;
 
 		if (qctl->qc_valid == QC_OSTIDX) {
-			if (qctl->qc_idx < 0 || count <= qctl->qc_idx)
+			if (count <= qctl->qc_idx)
 				return -EINVAL;
 
 			tgt = lov->lov_tgts[qctl->qc_idx];
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
index 316103a..b9a3e6f 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
@@ -451,7 +451,6 @@ out:
 static inline void enc_pools_wakeup(void)
 {
 	LASSERT(spin_is_locked(&page_pools.epp_lock));
-	LASSERT(page_pools.epp_waitqlen >= 0);
 
 	if (unlikely(page_pools.epp_waitqlen)) {
 		LASSERT(waitqueue_active(&page_pools.epp_waitq));
-- 
1.7.9.5

