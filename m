Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3EHCks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:40:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53932 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133Ab3EHCkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:40:46 -0400
X-Sasl-enc: vmVQgMJFeaZwIniDaYzIlSePm4pDfgS09ogegV8t1oCJ 1367980845
Subject: [PATCH] autofs4: translate pids to the right namespace for the
 daemon
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Ian Kent <raven@themaw.net>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sukadev Bhattiprolu <sukadev@us.ibm.com>,
        Eric Biederman <ebiederm@xmission.com>
Date: Wed, 08 May 2013 10:40:42 +0800
Message-ID: <20130508024041.4314.4134.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The PID and the TGID of the process tringgering the mount are sent to the
daemon.  Currently the global pid values are sent (ones valid in the initial pid
namespace) but this is wrong if the autofs daemon itself is not running in the
initial pid namespace.

So send the pid values that are valid in the namespace of the autofs daemon.

The namespace to use is taken from the oz_pgrp pid pointer, which was set at
mount time to the mounting process' pid namespace.

If the pid translation fails (the triggering process is in an unrelated pid
namespace) then the automount fails with ENOENT.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Eric Biederman <ebiederm@xmission.com>
---
 fs/autofs4/waitq.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 3db70da..309ca6b 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -353,11 +353,23 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 	struct qstr qstr;
 	char *name;
 	int status, ret, type;
+	pid_t pid;
+	pid_t tgid;
 
 	/* In catatonic mode, we don't wait for nobody */
 	if (sbi->catatonic)
 		return -ENOENT;
 
+	/*
+	 * Try translating pids to the namespace of the daemon.
+	 *
+	 * Zero means failure: we are in an unrelated pid namespace.
+	 */
+	pid = task_pid_nr_ns(current, ns_of_pid(sbi->oz_pgrp));
+	tgid = task_tgid_nr_ns(current, ns_of_pid(sbi->oz_pgrp));
+	if (pid == 0 || tgid == 0)
+		return -ENOENT;
+
 	if (!dentry->d_inode) {
 		/*
 		 * A wait for a negative dentry is invalid for certain
@@ -423,8 +435,8 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		wq->ino = autofs4_get_ino(sbi);
 		wq->uid = current_uid();
 		wq->gid = current_gid();
-		wq->pid = current->pid;
-		wq->tgid = current->tgid;
+		wq->pid = pid;
+		wq->tgid = tgid;
 		wq->status = -EINTR; /* Status return if interrupted */
 		wq->wait_ctr = 2;
 		mutex_unlock(&sbi->wq_mutex);

