Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaGHVqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:46:00 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:57768 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaGHVp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:45:59 -0400
Date: Wed, 9 Jul 2014 00:45:57 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: [PATCH 2/2] proc: faster /proc/$PID lookup
Message-ID: <20140708214557.GB2256@p183.telecom.by>
References: <20140708214041.GA2256@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708214041.GA2256@p183.telecom.by>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently lookup for /proc/$PID first goes through spinlock and
whole list of misc /proc entries only to confirm that, yes,
/proc/42 can not possibly match random proc entry.

List is is several dozens entries long (52 entries on my setup).

None of this is necessary.

Try to convert dentry name to integer first.
If it works, it must be /proc/$PID.
If it doesn't, it must be random proc entry.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c |    2 +-
 fs/proc/root.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2780,7 +2780,7 @@ out:
 
 struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsigned int flags)
 {
-	int result = 0;
+	int result = -ENOENT;
 	struct task_struct *task;
 	unsigned tgid;
 	struct pid_namespace *ns;
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -199,10 +199,10 @@ static int proc_root_getattr(struct vfsmount *mnt, struct dentry *dentry, struct
 
 static struct dentry *proc_root_lookup(struct inode * dir, struct dentry * dentry, unsigned int flags)
 {
-	if (!proc_lookup(dir, dentry, flags))
+	if (!proc_pid_lookup(dir, dentry, flags))
 		return NULL;
 	
-	return proc_pid_lookup(dir, dentry, flags);
+	return proc_lookup(dir, dentry, flags);
 }
 
 static int proc_root_readdir(struct file *file, struct dir_context *ctx)
