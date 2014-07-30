Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaG3WfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:35:14 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:38181 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbaG3WfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:35:10 -0400
Date: Thu, 31 Jul 2014 01:31:30 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Michael L. Semon" <mlsemon35@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, jason.low2@hp.com,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: cred_guard_mutex vs seq_file::lock [was: Re: 3.14.0+/x86:
 lockdep and mutexes not getting along]
Message-ID: <20140730223130.GA22417@node.dhcp.inet.fi>
References: <20140410142918.GU11096@twins.programming.kicks-ass.net>
 <alpine.LNX.2.11.1404060059020.8208@bpserver.ds>
 <20140409121940.GA12890@node.dhcp.inet.fi>
 <26259.1397227827@warthog.procyon.org.uk>
 <20140411150724.GI18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411150724.GI18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 04:07:25PM +0100, Al Viro wrote:
> On Fri, Apr 11, 2014 at 03:50:27PM +0100, David Howells wrote:
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > Al, David, any bright ideas on how to best fix this?
> > 
> > Have the seq_xxx() code throw an error if current->in_execve is true.  I can't
> > think of any circumstance where execve() should be reading anything that uses
> > seq_xxx().
> 
> *cringe*
> 
> I don't like it.  That really should be a responsiblity of specific ->show();
> "I'm going to take that mutex, bugger off if we are in execve()" makes a lot
> more sense than having e.g. seq_read() care of that.  IOW, I would very
> much prefer the patch you've sent last week.
> 
> And yes, it might leave lockdep false positives, but that's better dealt with
> by annotating the sucker ("this guy has a separate lockdep class for its
> ->lock").  E.g. by splitting proc_single_file_operations in two and having
> the one used for those files do lockdep_set_class() in its ->open().

I've got annoyed by the lockdep warning. What about the patch below?

>From 54d8c463e12f23c09d6a2dbf93a4dc9bcb493c67 Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Thu, 31 Jul 2014 00:59:52 +0300
Subject: [PATCH] procfs: silence lockdep warning about read vs. exec seq_file

Testcase:

  cat /proc/self/maps >/dev/null
  chmod +x /proc/self/net/packet
  exec /proc/self/net/packet

It triggers lockdep warning:

	 [ INFO: possible circular locking dependency detected ]
	 3.16.0-rc7-00064-g26bcd8b72563 #8 Not tainted
	 -------------------------------------------------------
	 sh/157 is trying to acquire lock:
	  (&p->lock){+.+.+.}, at: [<ffffffff8117f4f8>] seq_read+0x38/0x3e0

	 but task is already holding lock:
	  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff81160018>] prepare_bprm_creds+0x28/0x90

	 which lock already depends on the new lock.

	 the existing dependency chain (in reverse order) is:

	-> #1 (&sig->cred_guard_mutex){+.+.+.}:
	        [<ffffffff8109a9c1>] __lock_acquire+0x531/0xde0
	        [<ffffffff8109b959>] lock_acquire+0x79/0xd0
	        [<ffffffff8173f838>] mutex_lock_killable_nested+0x68/0x460
	        [<ffffffff811c0d9f>] lock_trace+0x1f/0x60
	        [<ffffffff811c0ed7>] proc_pid_personality+0x17/0x60
	        [<ffffffff811be39b>] proc_single_show+0x4b/0x90
	        [<ffffffff8117f5a0>] seq_read+0xe0/0x3e0
	        [<ffffffff81158f1e>] vfs_read+0x8e/0x170
	        [<ffffffff81159be8>] SyS_read+0x48/0xc0
	        [<ffffffff81743712>] system_call_fastpath+0x16/0x1b

	-> #0 (&p->lock){+.+.+.}:
	        [<ffffffff81097437>] validate_chain.isra.37+0xfe7/0x13b0
	        [<ffffffff8109a9c1>] __lock_acquire+0x531/0xde0
	        [<ffffffff8109b959>] lock_acquire+0x79/0xd0
	        [<ffffffff8173f09a>] mutex_lock_nested+0x6a/0x3d0
	        [<ffffffff8117f4f8>] seq_read+0x38/0x3e0
	        [<ffffffff811bd5f3>] proc_reg_read+0x43/0x70
	        [<ffffffff81158f1e>] vfs_read+0x8e/0x170
	        [<ffffffff8115ea13>] kernel_read+0x43/0x60
	        [<ffffffff8115ec65>] prepare_binprm+0xd5/0x170
	        [<ffffffff811605c8>] do_execve_common.isra.32+0x548/0x800
	        [<ffffffff81160893>] do_execve+0x13/0x20
	        [<ffffffff81160b70>] SyS_execve+0x20/0x30
	        [<ffffffff81743c89>] stub_execve+0x69/0xa0

	 other info that might help us debug this:

	  Possible unsafe locking scenario:

	        CPU0                    CPU1
	        ----                    ----
	   lock(&sig->cred_guard_mutex);
	                                lock(&p->lock);
	                                lock(&sig->cred_guard_mutex);
	   lock(&p->lock);

	  *** DEADLOCK ***

	 1 lock held by sh/157:
	  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff81160018>] prepare_bprm_creds+0x28/0x90

It's a false positive: seq files which take cred_guard_mutex are never
executable. Let's use separate lock class for them.

I don't know why we allow "chmod +x" on some proc files, notably net-related.
Is it a bug?

Also I suspect eb94cd96e05d fixes non-existing bug, like this one.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/proc/base.c       | 24 +++++++++++++++++++++++-
 fs/proc/task_mmu.c   | 14 ++++++++++++++
 fs/proc/task_nommu.c |  4 ++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2d696b0c93bf..c05b4a227acb 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -655,9 +655,31 @@ static int proc_single_show(struct seq_file *m, void *v)
 	return ret;
 }
 
+/*
+ * proc_pid_personality() and proc_pid_stack() take cred_guard_mutex via
+ * lock_trace() with seq_file->lock held.
+ * execve(2) calls vfs_read() with cred_guard_mutex held.
+ *
+ * So if you will try to execute a seq_file, lockdep will report a possible
+ * circular locking dependency. It's false-positive, since ONE() files are
+ * never executable.
+ *
+ * Let's set separate lock class for seq_file->lock of ONE() files.
+ */
+static struct lock_class_key proc_single_open_lock_class;
+
 static int proc_single_open(struct inode *inode, struct file *filp)
 {
-	return single_open(filp, proc_single_show, inode);
+	struct seq_file *m;
+	int ret;
+
+	ret = single_open(filp, proc_single_show, inode);
+	if (ret)
+		return ret;
+
+	m = filp->private_data;
+	lockdep_set_class(&m->lock, &proc_single_open_lock_class);
+	return 0;
 }
 
 static const struct file_operations proc_single_file_operations = {
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index cfa63ee92c96..536b9f9a9ff5 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -19,6 +19,18 @@
 #include <asm/tlbflush.h>
 #include "internal.h"
 
+/*
+ * m_start() takes cred_guard_mutex via mm_access() with seq_file->lock held.
+ * execve(2) calls vfs_read() with cred_guard_mutex held.
+ *
+ * So if you will try to execute a seq_file, lockdep will report a possible
+ * circular locking dependency. It's false positive, since m_start() users are
+ * never executable.
+ *
+ * Let's set separate class lock for seq_file->lock of m_start() users.
+ */
+static struct lock_class_key pid_maps_seq_file_lock;
+
 void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
 	unsigned long data, text, lib, swap;
@@ -242,6 +254,7 @@ static int do_maps_open(struct inode *inode, struct file *file,
 		ret = seq_open(file, ops);
 		if (!ret) {
 			struct seq_file *m = file->private_data;
+			lockdep_set_class(&m->lock, &pid_maps_seq_file_lock);
 			m->private = priv;
 		} else {
 			kfree(priv);
@@ -1512,6 +1525,7 @@ static int numa_maps_open(struct inode *inode, struct file *file,
 		ret = seq_open(file, ops);
 		if (!ret) {
 			struct seq_file *m = file->private_data;
+			lockdep_set_class(&m->lock, &pid_maps_seq_file_lock);
 			m->private = priv;
 		} else {
 			kfree(priv);
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 678455d2d683..35a799443990 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -9,6 +9,9 @@
 #include <linux/seq_file.h>
 #include "internal.h"
 
+/* See comment in task_mmu.c */
+static struct lock_class_key pid_maps_seq_file_lock;
+
 /*
  * Logic: we've got two memory sums for each process, "shared", and
  * "non-shared". Shared memory may get counted more than once, for
@@ -277,6 +280,7 @@ static int maps_open(struct inode *inode, struct file *file,
 		ret = seq_open(file, ops);
 		if (!ret) {
 			struct seq_file *m = file->private_data;
+			lockdep_set_class(&m->lock, &pid_maps_seq_file_lock);
 			m->private = priv;
 		} else {
 			kfree(priv);
-- 
 Kirill A. Shutemov
