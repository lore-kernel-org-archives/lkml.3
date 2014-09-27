Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaI0BmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 21:42:05 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:48958 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaI0BmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 21:42:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge E. Hallyn" <serge@hallyn.com>
References: <20140910162155.GA7748@mail.hallyn.com>
	<20140910164212.GA32587@ubuntu-hedt>
	<20140911181034.GA58733@ubuntu-hedt>
	<87d2am3r8a.fsf@x220.int.ebiederm.org>
	<20140924132925.GA48721@ubuntu-hedt>
	<87y4t9ndw5.fsf@x220.int.ebiederm.org>
	<CAJfpegs3QNdKMZWmN324OqHFw+e2qwU9kfkQ491==yP_JRrcWw@mail.gmail.com>
	<87wq8reftb.fsf@x220.int.ebiederm.org>
	<20140925184403.GB28101@ubuntu-hedt>
	<87bnq3a4xy.fsf@x220.int.ebiederm.org>
	<20140925194825.GB39447@ubuntu-hedt>
Date: Fri, 26 Sep 2014 18:41:33 -0700
In-Reply-To: <20140925194825.GB39447@ubuntu-hedt> (Seth Forshee's message of
	"Thu, 25 Sep 2014 14:48:25 -0500")
Message-ID: <874mvtkfg2.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-XM-AID: U2FsdGVkX18I1CPkxRAAYE+mCFqwxhrstjvSZt92JQE=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.3 XM_UncommonTLD01 Less-common TLD
	*  1.0 XMSubGarbage Subject is 100% non-alphanumeric garbage
	*  1.0 T_XMDrugObfuBody_04 obfuscated drug references
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Seth Forshee <seth.forshee@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

Seth Forshee <seth.forshee@canonical.com> writes:

> On Thu, Sep 25, 2014 at 12:14:01PM -0700, Eric W. Biederman wrote:

>> Sorry iattr_to_setattr look for from_kuid and from_kgid.
>> 
>> The call path is
>> fuse_setattr
>>    fuse_do_setattr
>>       iattr_to_fattr.
>
> Bah. Sorry, I misread that originally and thought you were talking about
> something outside of fuse. And I was looking at a tree with my fuse
> changes, so of course I wouldn't have found it.
>
> Actually in 3.17-rc6 I still don't see that iattr_to_fattr (I assume
> this is what you meant) checks the results of the conversion (not that
> it really needs to since it uses init_user_ns), nor any use of EOVERFLOW
> in fuse. Anyway, it's not really important.

True.  I also goofed up in that I was looking at the wrong tree.  My
tree had all of my preliminary fuse patches I worked up a while ago
applied so I did have the error handling in there.

> Well, unless you say otherwise I guess I'll leave it -EINVAL to be
> consistent with chown_common().

That sounds like a good plan.

>> I am on the fence about what to do when a uid from the filesystem server
>> or for other filesystems the on-disk data structures does not map, but
>> make_bad_inode is simpler in conception.  So make_bad_inode seems like
>> a good place to start.   For fuse especially this isn't hard because
>> the make_bad_inode calls are already there to handle a change in i_mode.
>
> I agree that if we're unsure then make_bad_inode is a more logical place
> to start, since it's easier to loosen the restrictions later than to
> tighten them. I've got an initiail implementation that I'm in the
> process of testing. If you want to take a look I've pushed it to:
>
>   git://kernel.ubuntu.com/sforshee/linux.git fuse-userns 

Thanks.  If I can scrape together enough focus I will look at it.

As a second best thing here are my prototype from when I was looking at
performing this fuse conversion last.  Given that you had missed
checking the from_kuid permission checks, it might be worth comparing
and seeing if there is something else in these patches that would be
worth including.

Eric


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-userns-Allow-for-fuse-filesystems-outside-the-initia.patch

>From 94195ce5b06915846d14eaa35d9274c0315b46a0 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 4 Oct 2012 13:34:45 -0700
Subject: [PATCH 1/4] userns: Allow for fuse filesystems outside the initial user
 namespace

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/fuse/dev.c    | 10 +++++-----
 fs/fuse/dir.c    | 41 ++++++++++++++++++++++++++++++-----------
 fs/fuse/fuse_i.h |  3 +++
 fs/fuse/inode.c  | 10 ++++++++--
 4 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ca887314aba9..e01f30c51b3c 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -124,10 +124,10 @@ static void __fuse_put_request(struct fuse_req *req)
 	atomic_dec(&req->count);
 }
 
-static void fuse_req_init_context(struct fuse_req *req)
+static void fuse_req_init_context(struct fuse_conn *fc, struct fuse_req *req)
 {
-	req->in.h.uid = from_kuid_munged(&init_user_ns, current_fsuid());
-	req->in.h.gid = from_kgid_munged(&init_user_ns, current_fsgid());
+	req->in.h.uid = from_kuid_munged(fc->user_ns, current_fsuid());
+	req->in.h.gid = from_kgid_munged(fc->user_ns, current_fsgid());
 	req->in.h.pid = current->pid;
 }
 
@@ -168,7 +168,7 @@ static struct fuse_req *__fuse_get_req(struct fuse_conn *fc, unsigned npages,
 		goto out;
 	}
 
-	fuse_req_init_context(req);
+	fuse_req_init_context(fc, req);
 	req->waiting = 1;
 	req->background = for_background;
 	return req;
@@ -257,7 +257,7 @@ struct fuse_req *fuse_get_req_nofail_nopages(struct fuse_conn *fc,
 	if (!req)
 		req = get_reserved_req(fc, file);
 
-	fuse_req_init_context(req);
+	fuse_req_init_context(fc, req);
 	req->waiting = 1;
 	req->background = 0;
 	return req;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index de1d84af9f7c..d74c75a057cd 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -886,7 +886,7 @@ static int fuse_link(struct dentry *entry, struct inode *newdir,
 	return err;
 }
 
-static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
+static int fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
 			  struct kstat *stat)
 {
 	unsigned int blkbits;
@@ -905,8 +905,12 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
 	stat->ino = attr->ino;
 	stat->mode = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
 	stat->nlink = attr->nlink;
-	stat->uid = make_kuid(&init_user_ns, attr->uid);
-	stat->gid = make_kgid(&init_user_ns, attr->gid);
+	stat->uid = make_kuid(fc->user_ns, attr->uid);
+	if (!uid_valid(stat->uid))
+		return -EOVERFLOW;
+	stat->gid = make_kgid(fc->user_ns, attr->gid);
+	if (!gid_valid(stat->gid))
+		return -EOVERFLOW;
 	stat->rdev = inode->i_rdev;
 	stat->atime.tv_sec = attr->atime;
 	stat->atime.tv_nsec = attr->atimensec;
@@ -923,6 +927,7 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
 		blkbits = inode->i_sb->s_blocksize_bits;
 
 	stat->blksize = 1 << blkbits;
+	return 0;
 }
 
 static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
@@ -973,7 +978,8 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
 					       attr_timeout(&outarg),
 					       attr_version);
 			if (stat)
-				fuse_fillattr(inode, &outarg.attr, stat);
+				err = fuse_fillattr(inode, &outarg.attr,
+						    stat);
 		}
 	}
 	return err;
@@ -1556,17 +1562,25 @@ static bool update_mtime(unsigned ivalid, bool trust_local_mtime)
 	return true;
 }
 
-static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg,
-			   bool trust_local_cmtime)
+static int iattr_to_fattr(struct fuse_conn *fc, struct iattr *iattr,
+			   struct fuse_setattr_in *arg, bool trust_local_cmtime)
 {
 	unsigned ivalid = iattr->ia_valid;
 
 	if (ivalid & ATTR_MODE)
 		arg->valid |= FATTR_MODE,   arg->mode = iattr->ia_mode;
-	if (ivalid & ATTR_UID)
-		arg->valid |= FATTR_UID,    arg->uid = from_kuid(&init_user_ns, iattr->ia_uid);
-	if (ivalid & ATTR_GID)
-		arg->valid |= FATTR_GID,    arg->gid = from_kgid(&init_user_ns, iattr->ia_gid);
+	if (ivalid & ATTR_UID) {
+		arg->valid |= FATTR_UID;
+		arg->uid = from_kuid(fc->user_ns, iattr->ia_uid);
+		if (arg->uid == (uid_t)-1)
+			return -EOVERFLOW;
+	}
+	if (ivalid & ATTR_GID) {
+		arg->valid |= FATTR_GID;
+		arg->gid = from_kgid(fc->user_ns, iattr->ia_gid);
+		if (arg->gid == (gid_t)-1)
+			return -EOVERFLOW;
+	}
 	if (ivalid & ATTR_SIZE)
 		arg->valid |= FATTR_SIZE,   arg->size = iattr->ia_size;
 	if (ivalid & ATTR_ATIME) {
@@ -1588,6 +1602,7 @@ static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg,
 		arg->ctime = iattr->ia_ctime.tv_sec;
 		arg->ctimensec = iattr->ia_ctime.tv_nsec;
 	}
+	return 0;
 }
 
 /*
@@ -1741,7 +1756,11 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));
-	iattr_to_fattr(attr, &inarg, trust_local_cmtime);
+	err = iattr_to_fattr(fc, attr, &inarg, trust_local_cmtime);
+	if (err) {
+		goto error;
+	}
+
 	if (file) {
 		struct fuse_file *ff = file->private_data;
 		inarg.valid |= FATTR_FH;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e8e47a6ab518..e7dbbb5d62b4 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -598,6 +598,9 @@ struct fuse_conn {
 
 	/** Read/write semaphore to hold when accessing sb. */
 	struct rw_semaphore killsb;
+
+	/** User namespace to communicate uids and gids to the fuse daemon */
+	struct user_namespace *user_ns;
 };
 
 static inline struct fuse_conn *get_fuse_conn_super(struct super_block *sb)
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 03246cd9d47a..894288f7ad67 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -20,6 +20,7 @@
 #include <linux/random.h>
 #include <linux/sched.h>
 #include <linux/exportfs.h>
+#include <linux/user_namespace.h>
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Filesystem in Userspace");
@@ -577,8 +578,8 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
 	struct super_block *sb = root->d_sb;
 	struct fuse_conn *fc = get_fuse_conn_super(sb);
 
-	seq_printf(m, ",user_id=%u", from_kuid_munged(&init_user_ns, fc->user_id));
-	seq_printf(m, ",group_id=%u", from_kgid_munged(&init_user_ns, fc->group_id));
+	seq_printf(m, ",user_id=%u", from_kuid_munged(fc->user_ns, fc->user_id));
+	seq_printf(m, ",group_id=%u", from_kgid_munged(fc->user_ns, fc->group_id));
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS)
 		seq_puts(m, ",default_permissions");
 	if (fc->flags & FUSE_ALLOW_OTHER)
@@ -616,6 +617,7 @@ void fuse_conn_init(struct fuse_conn *fc)
 	fc->initialized = 0;
 	fc->attr_version = 1;
 	get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
+	fc->user_ns = get_user_ns(current_user_ns());
 }
 EXPORT_SYMBOL_GPL(fuse_conn_init);
 
@@ -624,6 +626,8 @@ void fuse_conn_put(struct fuse_conn *fc)
 	if (atomic_dec_and_test(&fc->count)) {
 		if (fc->destroy_req)
 			fuse_request_free(fc->destroy_req);
+		put_user_ns(fc->user_ns);
+		fc->user_ns = NULL;
 		fc->release(fc);
 	}
 }
@@ -1033,6 +1037,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_time_gran = 1;
 	sb->s_export_op = &fuse_export_operations;
+	sb->s_user_ns = get_user_ns(current_user_ns());
 
 	file = fget(d.fd);
 	err = -EINVAL;
@@ -1149,6 +1154,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
 	}
 
 	kill_anon_super(sb);
+	put_user_ns(sb->s_user_ns);
 }
 
 static struct file_system_type fuse_fs_type = {
-- 
1.9.1


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0002-fuse-Teach-fuse-how-to-handle-the-pid-namespace.patch

>From 9bdaa744858d296f361a92c8940c33f878aec169 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 4 Oct 2012 13:42:34 -0700
Subject: [PATCH 2/4] fuse: Teach fuse how to handle the pid namespace.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/fuse/dev.c    |  2 +-
 fs/fuse/file.c   | 17 ++++++++++-------
 fs/fuse/fuse_i.h |  3 +++
 fs/fuse/inode.c  |  4 ++++
 4 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index e01f30c51b3c..448775701763 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -128,7 +128,7 @@ static void fuse_req_init_context(struct fuse_conn *fc, struct fuse_req *req)
 {
 	req->in.h.uid = from_kuid_munged(fc->user_ns, current_fsuid());
 	req->in.h.gid = from_kgid_munged(fc->user_ns, current_fsgid());
-	req->in.h.pid = current->pid;
+	req->in.h.pid = pid_nr_ns(task_pid(current), fc->pid_ns);
 }
 
 static bool fuse_block_alloc(struct fuse_conn *fc, bool for_background)
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 912061ac4baf..2d52801fa5dd 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2130,7 +2130,8 @@ static int fuse_direct_mmap(struct file *file, struct vm_area_struct *vma)
 	return generic_file_mmap(file, vma);
 }
 
-static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
+static int convert_fuse_file_lock(struct fuse_conn *fc,
+				  const struct fuse_file_lock *ffl,
 				  struct file_lock *fl)
 {
 	switch (ffl->type) {
@@ -2145,7 +2146,9 @@ static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
 
 		fl->fl_start = ffl->start;
 		fl->fl_end = ffl->end;
-		fl->fl_pid = ffl->pid;
+		rcu_read_lock();
+		fl->fl_pid = pid_vnr(find_pid_ns(ffl->pid, fc->pid_ns));
+		rcu_read_unlock();
 		break;
 
 	default:
@@ -2156,7 +2159,7 @@ static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
 }
 
 static void fuse_lk_fill(struct fuse_req *req, struct file *file,
-			 const struct file_lock *fl, int opcode, pid_t pid,
+			 const struct file_lock *fl, int opcode, struct pid *pid,
 			 int flock)
 {
 	struct inode *inode = file_inode(file);
@@ -2169,7 +2172,7 @@ static void fuse_lk_fill(struct fuse_req *req, struct file *file,
 	arg->lk.start = fl->fl_start;
 	arg->lk.end = fl->fl_end;
 	arg->lk.type = fl->fl_type;
-	arg->lk.pid = pid;
+	arg->lk.pid = pid_nr_ns(pid, fc->pid_ns);
 	if (flock)
 		arg->lk_flags |= FUSE_LK_FLOCK;
 	req->in.h.opcode = opcode;
@@ -2191,7 +2194,7 @@ static int fuse_getlk(struct file *file, struct file_lock *fl)
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	fuse_lk_fill(req, file, fl, FUSE_GETLK, 0, 0);
+	fuse_lk_fill(req, file, fl, FUSE_GETLK, NULL, 0);
 	req->out.numargs = 1;
 	req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
@@ -2199,7 +2202,7 @@ static int fuse_getlk(struct file *file, struct file_lock *fl)
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err)
-		err = convert_fuse_file_lock(&outarg.lk, fl);
+		err = convert_fuse_file_lock(fc, &outarg.lk, fl);
 
 	return err;
 }
@@ -2210,7 +2213,7 @@ static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_req *req;
 	int opcode = (fl->fl_flags & FL_SLEEP) ? FUSE_SETLKW : FUSE_SETLK;
-	pid_t pid = fl->fl_type != F_UNLCK ? current->tgid : 0;
+	struct pid *pid = fl->fl_type != F_UNLCK ? task_tgid(current) : NULL;
 	int err;
 
 	if (fl->fl_lmops && fl->fl_lmops->lm_grant) {
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e7dbbb5d62b4..5d93f87e9960 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -601,6 +601,9 @@ struct fuse_conn {
 
 	/** User namespace to communicate uids and gids to the fuse daemon */
 	struct user_namespace *user_ns;
+
+	/** Pid namespace to communicate pids to the fuse daemon */
+	struct pid_namespace *pid_ns;
 };
 
 static inline struct fuse_conn *get_fuse_conn_super(struct super_block *sb)
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 894288f7ad67..5284d7fda269 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/exportfs.h>
 #include <linux/user_namespace.h>
+#include <linux/pid_namespace.h>
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Filesystem in Userspace");
@@ -618,6 +619,7 @@ void fuse_conn_init(struct fuse_conn *fc)
 	fc->attr_version = 1;
 	get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
 	fc->user_ns = get_user_ns(current_user_ns());
+	fc->pid_ns = get_pid_ns(task_active_pid_ns(current));
 }
 EXPORT_SYMBOL_GPL(fuse_conn_init);
 
@@ -628,6 +630,8 @@ void fuse_conn_put(struct fuse_conn *fc)
 			fuse_request_free(fc->destroy_req);
 		put_user_ns(fc->user_ns);
 		fc->user_ns = NULL;
+		put_pid_ns(fc->pid_ns);
+		fc->pid_ns = NULL;
 		fc->release(fc);
 	}
 }
-- 
1.9.1


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0003-userns-fuse-unprivileged-mount-suport.patch

>From 55226d169826abd110d9bc60a6b079f6be3f6a46 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 5 Oct 2012 10:18:28 -0700
Subject: [PATCH 3/4] userns: fuse unprivileged mount suport

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/fuse/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 5284d7fda269..75f5326868e0 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1164,7 +1164,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
 static struct file_system_type fuse_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuse",
-	.fs_flags	= FS_HAS_SUBTYPE,
+	.fs_flags	= FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
 	.mount		= fuse_mount,
 	.kill_sb	= fuse_kill_sb_anon,
 };
-- 
1.9.1


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0004-fuse-Only-allow-read-writing-user-xattrs.patch

>From 6ae88ecfe4e8c8998478932ca225d1d9753b6c4b Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 5 Oct 2012 14:33:36 -0700
Subject: [PATCH 4/4] fuse: Only allow read/writing user xattrs

In the context of unprivileged mounts supporting anything except
xattrs with the "user." prefix seems foolish.  Return -EOPNOSUPP
for all other types of xattrs.

Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/fuse/dir.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index d74c75a057cd..d84f5b819fab 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -13,6 +13,7 @@
 #include <linux/sched.h>
 #include <linux/namei.h>
 #include <linux/slab.h>
+#include <linux/xattr.h>
 
 static bool fuse_use_readdirplus(struct inode *dir, struct dir_context *ctx)
 {
@@ -1868,6 +1869,9 @@ static int fuse_setxattr(struct dentry *entry, const char *name,
 	if (fc->no_setxattr)
 		return -EOPNOTSUPP;
 
+	if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
+		return -EOPNOTSUPP;
+
 	req = fuse_get_req_nopages(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -1911,6 +1915,9 @@ static ssize_t fuse_getxattr(struct dentry *entry, const char *name,
 	if (fc->no_getxattr)
 		return -EOPNOTSUPP;
 
+	if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
+		return -EOPNOTSUPP;
+
 	req = fuse_get_req_nopages(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
-- 
1.9.1


--=-=-=--
