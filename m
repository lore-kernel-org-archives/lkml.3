Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628Ab3K0BXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:23:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729Ab3K0A7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 3.12 067/116] NFS: Fix a missing initialisation when reading the SELinux label
Date: Tue, 26 Nov 2013 16:57:20 -0800
Message-Id: <20131127005741.574189363@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit fcb63a9bd8427fc584229048ea14f1453dc9a2e1 upstream.

Ensure that _nfs4_do_get_security_label() also initialises the
SEQUENCE call correctly, by having it call into nfs4_call_sync().

Reported-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4570,7 +4570,7 @@ static int _nfs4_get_security_label(stru
 	struct nfs4_label label = {0, 0, buflen, buf};
 
 	u32 bitmask[3] = { 0, 0, FATTR4_WORD2_SECURITY_LABEL };
-	struct nfs4_getattr_arg args = {
+	struct nfs4_getattr_arg arg = {
 		.fh		= NFS_FH(inode),
 		.bitmask	= bitmask,
 	};
@@ -4581,14 +4581,14 @@ static int _nfs4_get_security_label(stru
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


