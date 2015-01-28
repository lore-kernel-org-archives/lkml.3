Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419AbbA1EXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:23:05 -0500
Received: from mail.kernel.org ([198.145.29.136]:40180 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934403AbbA1EXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:23:00 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 102/177] nfsd4: fix crash on unknown operation number
Date: Wed, 28 Jan 2015 12:09:20 +0800
Message-Id: <1422418236-12852-193-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 51904b08072a8bf2b9ed74d1bd7a5300a614471d upstream.

Unknown operation numbers are caught in nfsd4_decode_compound() which
sets op->opnum to OP_ILLEGAL and op->status to nfserr_op_illegal.  The
error causes the main loop in nfsd4_proc_compound() to skip most
processing.  But nfsd4_proc_compound also peeks ahead at the next
operation in one case and doesn't take similar precautions there.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/nfsd/nfs4proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 22beaff..b2ce878 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1132,7 +1132,8 @@ static bool need_wrongsec_check(struct svc_rqst *rqstp)
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
1.9.1

