Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaKRO1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:27:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbaKROKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:18 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 180/206] nfsd4: fix crash on unknown operation number
Date: Tue, 18 Nov 2014 15:08:55 +0100
Message-Id: <613a5ea57f0ed08228311a46b84155986949c7d4.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 51904b08072a8bf2b9ed74d1bd7a5300a614471d upstream.

Unknown operation numbers are caught in nfsd4_decode_compound() which
sets op->opnum to OP_ILLEGAL and op->status to nfserr_op_illegal.  The
error causes the main loop in nfsd4_proc_compound() to skip most
processing.  But nfsd4_proc_compound also peeks ahead at the next
operation in one case and doesn't take similar precautions there.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfsd/nfs4proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 08c8e023c157..25024d5060da 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1233,7 +1233,8 @@ static bool need_wrongsec_check(struct svc_rqst *rqstp)
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
2.1.3

