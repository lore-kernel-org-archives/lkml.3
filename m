Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935900AbaICXZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:25:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150AbaICWP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:15:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.14 86/88] NFSv3: Fix another acl regression
Date: Wed,  3 Sep 2014 15:06:00 -0700
Message-Id: <20140903220518.522036048@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit f87d928f6d98644d39809a013a22f981d39017cf upstream.

When creating a new object on the NFS server, we should not be sending
posix setacl requests unless the preceding posix_acl_create returned a
non-trivial acl. Doing so, causes Solaris servers in particular to
return an EINVAL.

Fixes: 013cdf1088d72 (nfs: use generic posix ACL infrastructure,,,)
Resolves: https://bugzilla.redhat.com/show_bug.cgi?id=1132786
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs3acl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -129,7 +129,10 @@ static int __nfs3_proc_setacls(struct in
 		.rpc_argp	= &args,
 		.rpc_resp	= &fattr,
 	};
-	int status;
+	int status = 0;
+
+	if (acl == NULL && (!S_ISDIR(inode->i_mode) || dfacl == NULL))
+		goto out;
 
 	status = -EOPNOTSUPP;
 	if (!nfs_server_capable(inode, NFS_CAP_ACLS))


