Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab3HMGxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:53:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab3HMGdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Nix <nix@esperi.org.uk>,
        Jeff Layton <jlayton@redhat.com>
Subject: [ 29/60] LOCKD: Dont call utsname()->nodename from nlmclnt_setlockargs
Date: Mon, 12 Aug 2013 23:33:56 -0700
Message-Id: <20130813063336.163580595@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 9a1b6bf818e74bb7aabaecb59492b739f2f4d742 upstream.

Firstly, nlmclnt_setlockargs can be called from a reclaimer thread, in
which case we're in entirely the wrong namespace.

Secondly, commit 8aac62706adaaf0fab02c4327761561c8bda9448 (move
exit_task_namespaces() outside of exit_notify()) now means that
exit_task_work() is called after exit_task_namespaces(), which
triggers an Oops when we're freeing up the locks.

Fix this by ensuring that we initialise the nlm_host's rpc_client at mount
time, so that the cl_nodename field is initialised to the value of
utsname()->nodename that the net namespace uses. Then replace the
lockd callers of utsname()->nodename.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Toralf Förster <toralf.foerster@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Nix <nix@esperi.org.uk>
Cc: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/lockd/clntlock.c |   13 +++++++++----
 fs/lockd/clntproc.c |    5 +++--
 2 files changed, 12 insertions(+), 6 deletions(-)

--- a/fs/lockd/clntlock.c
+++ b/fs/lockd/clntlock.c
@@ -64,12 +64,17 @@ struct nlm_host *nlmclnt_init(const stru
 				   nlm_init->protocol, nlm_version,
 				   nlm_init->hostname, nlm_init->noresvport,
 				   nlm_init->net);
-	if (host == NULL) {
-		lockd_down(nlm_init->net);
-		return ERR_PTR(-ENOLCK);
-	}
+	if (host == NULL)
+		goto out_nohost;
+	if (host->h_rpcclnt == NULL && nlm_bind_host(host) == NULL)
+		goto out_nobind;
 
 	return host;
+out_nobind:
+	nlmclnt_release_host(host);
+out_nohost:
+	lockd_down(nlm_init->net);
+	return ERR_PTR(-ENOLCK);
 }
 EXPORT_SYMBOL_GPL(nlmclnt_init);
 
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -125,14 +125,15 @@ static void nlmclnt_setlockargs(struct n
 {
 	struct nlm_args	*argp = &req->a_args;
 	struct nlm_lock	*lock = &argp->lock;
+	char *nodename = req->a_host->h_rpcclnt->cl_nodename;
 
 	nlmclnt_next_cookie(&argp->cookie);
 	memcpy(&lock->fh, NFS_FH(file_inode(fl->fl_file)), sizeof(struct nfs_fh));
-	lock->caller  = utsname()->nodename;
+	lock->caller  = nodename;
 	lock->oh.data = req->a_owner;
 	lock->oh.len  = snprintf(req->a_owner, sizeof(req->a_owner), "%u@%s",
 				(unsigned int)fl->fl_u.nfs_fl.owner->pid,
-				utsname()->nodename);
+				nodename);
 	lock->svid = fl->fl_u.nfs_fl.owner->pid;
 	lock->fl.fl_start = fl->fl_start;
 	lock->fl.fl_end = fl->fl_end;


