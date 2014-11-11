Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaKKLcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:32:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57719 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbaKKLK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 124/170] nfsd4: fix crash on unknown operation number
Date: Tue, 11 Nov 2014 11:08:03 +0000
Message-Id: <1415704129-12709-125-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 51904b08072a8bf2b9ed74d1bd7a5300a614471d upstream.

Unknown operation numbers are caught in nfsd4_decode_compound() which
sets op->opnum to OP_ILLEGAL and op->status to nfserr_op_illegal.  The
error causes the main loop in nfsd4_proc_compound() to skip most
processing.  But nfsd4_proc_compound also peeks ahead at the next
operation in one case and doesn't take similar precautions there.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfs4proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 2cbe5d09166a..5d3031ecb1df 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1231,7 +1231,8 @@ static bool need_wrongsec_check(struct svc_rqst *rqstp)
 	 */
 	if (argp->opcnt == resp->opcnt)
 		return false;
-
+	if (next->opnum == OP_ILLEGAL)
+		return false;
 	nextd = OPDESC(next);
 	/*
 	 * Rest of 2.6.3.1.1: certain operations will return WRONGSEC
-- 
2.1.0

