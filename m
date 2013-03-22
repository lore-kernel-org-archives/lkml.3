Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423322Ab3CVV2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:28:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43105 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423270Ab3CVV2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:28:40 -0400
Date: Fri, 22 Mar 2013 21:28:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [CFT] Re: VFS deadlock ?
Message-ID: <20130322212835.GR21522@ZenIV.linux.org.uk>
References: <20130322001257.GH21522@ZenIV.linux.org.uk>
 <CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
 <20130322012208.GJ21522@ZenIV.linux.org.uk>
 <CA+55aFzPD08kJi=x8wLBi5FAjr1TqSGXWbv5KXy5Ymm0PJL0wA@mail.gmail.com>
 <20130322014037.GK21522@ZenIV.linux.org.uk>
 <20130322043715.GL21522@ZenIV.linux.org.uk>
 <CA+55aFzUobqDR0RSh8t18m32BdTvm4k7j2PCseXpFVCH_gR=Fw@mail.gmail.com>
 <20130322051817.GM21522@ZenIV.linux.org.uk>
 <CA+55aFzbV81KQh_f0=wti9=_6=PXu37z0+NJymhDvzv13GgpuA@mail.gmail.com>
 <CA+55aFwACJ+JQHMTGf7waFOygOV8NA0nRhnJVZJg6+bV_7O=4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwACJ+JQHMTGf7waFOygOV8NA0nRhnJVZJg6+bV_7O=4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 12:43:50PM -0700, Linus Torvalds wrote:
> I tested this out by just having a process that keeps stat'ing the
> same /proc inode over and over and over again, which should be pretty
> much the worst-case situation (because we will delete the dentry after
> each stat, and so we'll repopulate it for each stat)
> 
> The allocation overhead seems to be in the noise. The real costs are
> all in proc_lookup_de() just finding the entry, with strlen/strcmp
> being much hotter. So if we actually care about performance for these
> cases, what we would actually want to do is to just cache the dentries
> and have some kind of timeout instead of getting rid of them
> immediately. That would get rid of the lookup costs, and in the
> process also get rid of the constant inode allocation/deallocation
> costs.

As far as I can see, the whole thing is fairly cold, both the globals
and per-netns stuff...  /proc/<pid> is a different story, and /proc/sys
can also get hit quite a bit, but those... nope.

> There was also some locking overhead, but that's also mainly
> dentry-related, with the inode side being visible but not dominant.
> Again, not immediately expiring the dentries would make all that just
> go away.
> 
> Regardless, the patch seems to be the right thing to do. It actually
> simplifies /proc, seems to fix the problem for Dave, and is small and
> should be trivial to backport. I've committed it and marked it for
> stable. Let's hope there won't be any nasty surprises, but it does
> seem to be the simplest non-hacky patch.

ACK.  It might make sense to look into the making procfs retain dentries
better, but I seriously suspect that we would get much bigger win simply
from
	* refusing to create an entry with numeric name in procfs root
	* reordering the proc_root_lookup() - try the per-process first.
The thing is, proc_pid_lookup() will start with looking if name is a decimal
number; that'll immediately reject the ones that should be handled by
proc_lookup().  proc_lookup() miss, OTOH, costs more.  Sure, the length
won't match for the most of them, but grabbing spinlock / walking the list /
comparing the legth for each entry / dropping the spinlock is going to be
more costly than checking that a short string isn't a decimal number.  And
we look there for /proc/<pid>/something a lot more...

IOW, I suspect that something like (very lightly tested) patch below would
be more useful than anything we can get from playing with dcache retention.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 69078c7..02b07c7 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2727,12 +2727,12 @@ out:
 
 struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsigned int flags)
 {
-	struct dentry *result = NULL;
+	struct dentry *result = ERR_PTR(-ENOENT);
 	struct task_struct *task;
 	unsigned tgid;
 	struct pid_namespace *ns;
 
-	tgid = name_to_int(dentry);
+	tgid = name_to_int(&dentry->d_name);
 	if (tgid == ~0U)
 		goto out;
 
@@ -2990,7 +2990,7 @@ static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry
 	if (!leader)
 		goto out_no_task;
 
-	tid = name_to_int(dentry);
+	tid = name_to_int(&dentry->d_name);
 	if (tid == ~0U)
 		goto out;
 
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index d7a4a28..5f4286c 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -205,7 +205,7 @@ static struct dentry *proc_lookupfd_common(struct inode *dir,
 {
 	struct task_struct *task = get_proc_task(dir);
 	struct dentry *result = ERR_PTR(-ENOENT);
-	unsigned fd = name_to_int(dentry);
+	unsigned fd = name_to_int(&dentry->d_name);
 
 	if (!task)
 		goto out_no_task;
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 4b3b3ff..e13d2da 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -580,7 +580,7 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 {
 	struct proc_dir_entry *ent = NULL;
 	const char *fn = name;
-	unsigned int len;
+	struct qstr q;
 
 	/* make sure name is valid */
 	if (!name || !strlen(name))
@@ -593,14 +593,17 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 	if (strchr(fn, '/'))
 		goto out;
 
-	len = strlen(fn);
+	q.name = fn;
+	q.len = strlen(fn);
+	if (*parent == &proc_root && name_to_int(&q) != ~0U)
+		return NULL;
 
-	ent = kzalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
+	ent = kzalloc(sizeof(struct proc_dir_entry) + q.len + 1, GFP_KERNEL);
 	if (!ent)
 		goto out;
 
-	memcpy(ent->name, fn, len + 1);
-	ent->namelen = len;
+	memcpy(ent->name, q.name, q.len + 1);
+	ent->namelen = q.len;
 	ent->mode = mode;
 	ent->nlink = nlink;
 	atomic_set(&ent->count, 1);
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 85ff3a4..fba6da2 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -123,10 +123,10 @@ static inline int pid_delete_dentry(const struct dentry * dentry)
 	return !proc_pid(dentry->d_inode)->tasks[PIDTYPE_PID].first;
 }
 
-static inline unsigned name_to_int(struct dentry *dentry)
+static inline unsigned name_to_int(struct qstr *qstr)
 {
-	const char *name = dentry->d_name.name;
-	int len = dentry->d_name.len;
+	const char *name = qstr->name;
+	int len = qstr->len;
 	unsigned n = 0;
 
 	if (len > 1 && *name == '0')
diff --git a/fs/proc/root.c b/fs/proc/root.c
index c6e9fac..67c9dc4 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -190,10 +190,10 @@ static int proc_root_getattr(struct vfsmount *mnt, struct dentry *dentry, struct
 
 static struct dentry *proc_root_lookup(struct inode * dir, struct dentry * dentry, unsigned int flags)
 {
-	if (!proc_lookup(dir, dentry, flags))
+	if (!proc_pid_lookup(dir, dentry, flags))
 		return NULL;
 	
-	return proc_pid_lookup(dir, dentry, flags);
+	return proc_lookup(dir, dentry, flags);
 }
 
 static int proc_root_readdir(struct file * filp,

