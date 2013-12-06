Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162408Ab3LFNOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:14:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44709 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162057Ab3LFNFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:05:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 242/272] NFS: Fix a missing initialisation when reading the SELinux label
Date: Fri,  6 Dec 2013 12:58:51 +0000
Message-Id: <1386334761-25517-243-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit fcb63a9bd8427fc584229048ea14f1453dc9a2e1 upstream.

Ensure that _nfs4_do_get_security_label() also initialises the
SEQUENCE call correctly, by having it call into nfs4_call_sync().

Reported-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/nfs4proc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index b227e12..ecca3b5 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4409,7 +4409,7 @@ static int _nfs4_get_security_label(struct inode *inode, void *buf,
 	struct nfs4_label label = {0, 0, buflen, buf};
 
 	u32 bitmask[3] = { 0, 0, FATTR4_WORD2_SECURITY_LABEL };
-	struct nfs4_getattr_arg args = {
+	struct nfs4_getattr_arg arg = {
 		.fh		= NFS_FH(inode),
 		.bitmask	= bitmask,
 	};
@@ -4420,14 +4420,14 @@ static int _nfs4_get_security_label(struct inode *inode, void *buf,
 	};
 	struct rpc_message msg = {
 		.rpc_proc	= &nfs4_procedures[NFSPROC4_CLNT_GETATTR],
-		.rpc_argp	= &args,
+		.rpc_argp	= &arg,
 		.rpc_resp	= &res,
 	};
 	int ret;
 
 	nfs_fattr_init(&fattr);
 
-	ret = rpc_call_sync(server->client, &msg, 0);
+	ret = nfs4_call_sync(server->client, server, &msg, &arg.seq_args, &res.seq_res, 0);
 	if (ret)
 		return ret;
 	if (!(fattr.valid & NFS_ATTR_FATTR_V4_SECURITY_LABEL))
-- 
1.8.3.2

