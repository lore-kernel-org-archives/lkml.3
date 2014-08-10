Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaHJT0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 15:26:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbaHJTZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 15:25:57 -0400
Date: Sun, 10 Aug 2014 21:23:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] introduce proc_inode->pid_entry
Message-ID: <20140810192324.GA31721@redhat.com>
References: <20140808185732.GA760@redhat.com> <87d2caod0g.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <87d2caod0g.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 08/08, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > To me it looks a bit annoying that task_mmu.c needs 6 seq_operations's and
> > 6 file_operations's to handle /proc/pid/*maps*. And _only_ because ->show()
> > differs.
> >
> > Eric, et al, what do you think? At least something like 1-3 looks like a
> > good cleanup imho. And afaics we can do more cleanups on top.
>
>
> I see where you are getting annoyed.
>
> Taking a quick look at task_mmu.c  It looks like the tgid vs pid logic
> to decided which stack or stacks to display is simply incorrect.

Yes, probably, but please forget this for now. Because,

> Given where you are starting I think tack_mmu.c code that decides
> when/which stack deserves a serious audit.

Yes. And more. At least this code needs more cleanups. ->task should
die or at least we should avoid get/put_task_struct, ->pid can die too,
hold_task_mempolicy() doesn't look correct (at least the "prevent changing
our mempolicy while show_numa_maps" comment and down_write() in
do_set_mempolicy(). I am going to try to cleanup this a bit after I change
task_nommu.c to avoid mm_access() in m_start().

But this is off-topic,

> At a practical level moving pid_entry into the proc inode is ugly
> especially for the hack that is is_tgid_pid_entry.

Well, I am not going to argue with maintainer, mostly simply because
I do not understand this code enough ;)

But let me say that I disagree. We already have ->fd, and ->sysctl*.
I see nothing wrong if *id_base_stuff files have more info for free.

And imo proc_inode->sysctl* is much worse. Simply because they are
not private to fs/proc/proc_sysctl.c.

Could you please look into the attached mbox? I am just curious if we
can do something like this in a clean way. In particular, please look at
"Note:" comment in 3/3. Perhaps proc_sys_init() can do proc_get_inode(),
initialize/instantiate it...

To clarify, of course it is not that I want to shrink sizeof(proc_inode).
Just to me it doesn't look clean that proc_evict_inode() has to do
sysctl_head_put(), grab_header() assumes that ->sysctl == NULL means
sysctl_table_root.*, etc.

> That test could be implemented more easily by looking at the parent
> directories inode operations and seeing if they are
> proc_root_inode_operations.

Hmm. Looking at inode? How?

Oleg.

--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="U.m"

>From a4c94461ae18b2d6cc2e8a9cfb042d0b6cc46e86 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Sat, 9 Aug 2014 17:25:53 +0200
Subject: [PATCH 1/3] proc: introduce proc_sys_evict_inode()

Preparation. Shift the sysctl_head_put() code from proc_evict_inode()
into the new trivial helper, make sysctl_head_put() static.

---
 fs/proc/inode.c       |    8 ++------
 fs/proc/internal.h    |    4 ++--
 fs/proc/proc_sysctl.c |   13 ++++++++++++-
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 0adbc02..9f6715a 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -31,7 +31,6 @@
 static void proc_evict_inode(struct inode *inode)
 {
 	struct proc_dir_entry *de;
-	struct ctl_table_header *head;
 	const struct proc_ns_operations *ns_ops;
 	void *ns;
 
@@ -45,11 +44,8 @@ static void proc_evict_inode(struct inode *inode)
 	de = PROC_I(inode)->pde;
 	if (de)
 		pde_put(de);
-	head = PROC_I(inode)->sysctl;
-	if (head) {
-		RCU_INIT_POINTER(PROC_I(inode)->sysctl, NULL);
-		sysctl_head_put(head);
-	}
+
+	proc_sys_evict_inode(inode);
 	/* Release any associated namespace */
 	ns_ops = PROC_I(inode)->ns.ns_ops;
 	ns = PROC_I(inode)->ns.ns;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 78784cd..7ce3262 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -238,10 +238,10 @@ extern int proc_setup_self(struct super_block *);
  */
 #ifdef CONFIG_PROC_SYSCTL
 extern int proc_sys_init(void);
-extern void sysctl_head_put(struct ctl_table_header *);
+extern void proc_sys_evict_inode(struct inode *inode);
 #else
 static inline void proc_sys_init(void) { }
-static inline void sysctl_head_put(struct ctl_table_header *head) { }
+static inline void proc_sys_evict_inode(struct inode *inode) { }
 #endif
 
 /*
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 7129046..2fa67e7 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -256,7 +256,7 @@ static void sysctl_head_get(struct ctl_table_header *head)
 	spin_unlock(&sysctl_lock);
 }
 
-void sysctl_head_put(struct ctl_table_header *head)
+static void sysctl_head_put(struct ctl_table_header *head)
 {
 	spin_lock(&sysctl_lock);
 	if (!--head->count)
@@ -264,6 +264,17 @@ void sysctl_head_put(struct ctl_table_header *head)
 	spin_unlock(&sysctl_lock);
 }
 
+void proc_sys_evict_inode(struct inode *inode)
+{
+	struct ctl_table_header *head;
+
+	head = PROC_I(inode)->sysctl;
+	if (head) {
+		RCU_INIT_POINTER(PROC_I(inode)->sysctl, NULL);
+		sysctl_head_put(head);
+	}
+}
+
 static struct ctl_table_header *sysctl_head_grab(struct ctl_table_header *head)
 {
 	BUG_ON(!head);
-- 
1.5.5.1


>From e0b42f4770cd76069e4e70e48e4e7bfa84fab4bf Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Sat, 9 Aug 2014 17:37:31 +0200
Subject: [PATCH 2/3] proc: change proc_sys_evict_inode() to check inode->i_op

Change proc_sys_evict_inode() to verify that this inode is really
a /proc/sys inode before using ->sysctl.

---
 fs/proc/proc_sysctl.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 2fa67e7..863aaee 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -268,6 +268,10 @@ void proc_sys_evict_inode(struct inode *inode)
 {
 	struct ctl_table_header *head;
 
+	if (inode->i_op != &proc_sys_inode_operations &&
+	    inode->i_op != &proc_sys_dir_operations)
+		return;
+
 	head = PROC_I(inode)->sysctl;
 	if (head) {
 		RCU_INIT_POINTER(PROC_I(inode)->sysctl, NULL);
-- 
1.5.5.1


>From 9c8e98fc45f091d5d2a4bfc6dcd86b67275160a1 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Sun, 10 Aug 2014 17:37:25 +0200
Subject: [PATCH 3/3] proc: place proc_inode->sysctl* and proc_inode->fd into a union

->sysctl* and ->fd members can share the memory, add a union.

Note: unfortunately proc_alloc_inode() still has to initialize ->sysctl*
members. And the only (afaics) reason is that proc_mkdir("sys") relies
on ->sysctl == NULL which means sysctl_table_root in grab_header(). It
would be nice to initialize these members after proc_get_inode("sys")
somehow and remove the special "NULL means global root" case in proc_sys
paths somehow, but I do not see how.

---
 fs/proc/internal.h |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 7ce3262..8d35ac0 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -60,11 +60,15 @@ union proc_op {
 
 struct proc_inode {
 	struct pid *pid;
-	int fd;
-	union proc_op op;
 	struct proc_dir_entry *pde;
-	struct ctl_table_header *sysctl;
-	struct ctl_table *sysctl_entry;
+	union proc_op op;
+	union {
+		struct {
+			struct ctl_table_header *sysctl;
+			struct ctl_table *sysctl_entry;
+		};
+		int fd;
+	};
 	struct proc_ns ns;
 	struct inode vfs_inode;
 };
-- 
1.5.5.1


--sm4nu43k4a2Rpi4c--

