Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaLPLzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 06:55:44 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34117 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaLPLzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 06:55:41 -0500
Date: Tue, 16 Dec 2014 03:55:37 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [BUG, linux-next] spawn PID 1 without CLONE_FS, wireless inop
Message-ID: <20141216115537.GA1259@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all,

The wireless network interface has become inoperative when running
linux-next 20141216 on a Lenovo Carbon X1.  It is completely
non-existent and `ip addr` doesn't show it.  A bisect has found that
the bug was introduced by the following commit.

  commit 9d328afb18f05c25686102ad890a67bb3ca38aab
  Author: Al Viro <viro@zeniv.linux.org.uk>
  Date:   Thu Dec 11 22:34:21 2014 -0500
  
      spawn PID 1 without CLONE_FS, give kernel threads zero umask
      
      Don't give PID 1 init_fs, give it a copy of its own when it's
  spawned.
      Then we can make init_fs.umode zero, and have both the PID 1 and
      everything that gets spawned by call_usermodehelper() set
  ->fs->umask
      to old value (0022) early on.
      
      Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Below is my network interface information.  And the iwlwifi modules are
being used.

  $ lspci
  ...
  03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205
  [Taylor Peak] (rev 96)
  ...

And the patch which introduced this bug is included below.

>From 9d328afb18f05c25686102ad890a67bb3ca38aab Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Thu, 11 Dec 2014 22:34:21 -0500
Subject: [PATCH] spawn PID 1 without CLONE_FS, give kernel threads zero umask

Don't give PID 1 init_fs, give it a copy of its own when it's spawned.
Then we can make init_fs.umode zero, and have both the PID 1 and
everything that gets spawned by call_usermodehelper() set ->fs->umask
to old value (0022) early on.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/fs_struct.c | 2 +-
 init/main.c    | 4 +++-
 kernel/kmod.c  | 2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index 7dca743..2242c40 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -162,5 +162,5 @@ struct fs_struct init_fs = {
 	.users		= 1,
 	.lock		= __SPIN_LOCK_UNLOCKED(init_fs.lock),
 	.seq		= SEQCNT_ZERO(init_fs.seq),
-	.umask		= 0022,
+	.umask		= 0,
 };
diff --git a/init/main.c b/init/main.c
index 40240c8..3a169a2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -79,6 +79,7 @@
 #include <linux/random.h>
 #include <linux/list.h>
 #include <linux/proc_ns.h>
+#include <linux/fs_struct.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -401,7 +402,7 @@ static noinline void __init_refok rest_init(void)
 	 * the init task will end up wanting to create kthreads, which, if
 	 * we schedule it before we create kthreadd, will OOPS.
 	 */
-	kernel_thread(kernel_init, NULL, CLONE_FS);
+	kernel_thread(kernel_init, NULL, 0);
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
 	rcu_read_lock();
@@ -933,6 +934,7 @@ static int __ref kernel_init(void *unused)
 {
 	int ret;
 
+	current->fs->umask = 0022;
 	kernel_init_freeable();
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 80f7a6d..8879506 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -39,6 +39,7 @@
 #include <linux/rwsem.h>
 #include <linux/ptrace.h>
 #include <linux/async.h>
+#include <linux/fs_struct.h>
 #include <asm/uaccess.h>
 
 #include <trace/events/module.h>
@@ -227,6 +228,7 @@ static int ____call_usermodehelper(void *data)
 	struct cred *new;
 	int retval;
 
+	current->fs->umask = 0022;
 	spin_lock_irq(&current->sighand->siglock);
 	flush_signal_handlers(current, 1);
 	spin_unlock_irq(&current->sighand->siglock);
-- 
2.1.3

Let me know if I can provided any further information that would be helpful.

-- 
- Jeremiah Mahler
