Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaBEUFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:05:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:54708 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbaBEUF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:26 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jonathan Nieder <jrnieder@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 077/213] NFSv4: Revalidate uid/gid after open
Date: Wed, 5 Feb 2014 15:00:32 -0500
Message-ID: <1391630568-49251-78-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Nieder <jrnieder@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

This is a shorter (and more appropriate for stable kernels) analog to
the following upstream commit:

commit 6926afd1925a54a13684ebe05987868890665e2b
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Sat Jan 7 13:22:46 2012 -0500

    NFSv4: Save the owner/group name string when doing open

    ...so that we can do the uid/gid mapping outside the asynchronous RPC
    context.
    This fixes a bug in the current NFSv4 atomic open code where the client
    isn't able to determine what the true uid/gid fields of the file are,
    (because the asynchronous nature of the OPEN call denies it the ability
    to do an upcall) and so fills them with default values, marking the
    inode as needing revalidation.
    Unfortunately, in some cases, the VFS will do some additional sanity
    checks on the file, and may override the server's decision to allow
    the open because it sees the wrong owner/group fields.

    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

Without this patch, logging into two different machines with home
directories mounted over NFS4 and then running "vim" and typing ":q"
in each reliably produces the following error on the second machine:

	E137: Viminfo file is not writable: /users/system/rtheys/.viminfo

This regression was introduced by 80e52aced138 ("NFSv4: Don't do
idmapper upcalls for asynchronous RPC calls", merged during the 2.6.32
cycle) --- after the OPEN call, .viminfo has the default values for
st_uid and st_gid (0xfffffffe) cached because we do not want to let
rpciod wait for an idmapper upcall to fill them in.

The fix used in mainline is to save the owner and group as strings and
perform the upcall in _nfs4_proc_open outside the rpciod context,
which takes about 600 lines.  For stable, we can do something similar
with a one-liner: make open check for the stale fields and make a
(synchronous) GETATTR call to fill them when needed.

Trond dictated the patch, I typed it in, and Rik tested it.

Addresses http://bugs.debian.org/659111 and
          https://bugzilla.redhat.com/789298

Reported-by: Rik Theys <Rik.Theys@esat.kuleuven.be>
Explained-by: David Flyn <davidf@rd.bbc.co.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Tested-by: Rik Theys <Rik.Theys@esat.kuleuven.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[PG: commit 19165bdbb3622cfca0ff66e8b30248d469b849d6 in v3.0.32]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfs/nfs4proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 8dd330925ede..96e440aba77e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1669,6 +1669,7 @@ static int _nfs4_do_open(struct inode *dir, struct path *path, fmode_t fmode, in
 		goto err_opendata_put;
 	if (server->caps & NFS_CAP_POSIX_LOCK)
 		set_bit(NFS_STATE_POSIX_LOCKS, &state->flags);
+	nfs_revalidate_inode(server, state->inode);
 	nfs4_opendata_put(opendata);
 	nfs4_put_state_owner(sp);
 	*res = state;
-- 
1.8.5.2

