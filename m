Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbaLBUae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:30:34 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:57109 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550AbaLBUaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:30:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Richard Weinberger <richard@nod.at>,
        Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
	<87h9xez20g.fsf@x220.int.ebiederm.org>
	<CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
	<87mw75ygwp.fsf@x220.int.ebiederm.org>
	<CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
	<87fvcxyf28.fsf_-_@x220.int.ebiederm.org>
Date: Tue, 02 Dec 2014 14:28:18 -0600
In-Reply-To: <87fvcxyf28.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Tue, 02 Dec 2014 14:25:35 -0600")
Message-ID: <874mtdyexp.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+iNs0HIdb2bpBjfruJ5t7uqYaCR7AFpbI=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.2 XMSubMetaSSx_00 1+ SortaSexy Words + 1 Sexy Word
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 974 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 4.2 (0.4%), b_tie_ro: 2.8 (0.3%), parse: 1.60 (0.2%),
	extract_message_metadata: 23 (2.4%), get_uri_detail_list: 6 (0.7%),
	tests_pri_-1000: 7 (0.8%), tests_pri_-950: 1.60 (0.2%), tests_pri_-900: 1.34
	(0.1%), tests_pri_-400: 43 (4.4%), check_bayes: 41 (4.2%), b_tokenize: 18
	(1.9%), b_tok_get_all: 13 (1.3%), b_comp_prob: 3.6 (0.4%), b_tok_touch_all:
	3.6 (0.4%), b_finish: 0.97 (0.1%), tests_pri_0: 876 (90.0%), tests_pri_500:
	11 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: [CFT][PATCH 2/3] userns: Add a knob to disable setgroups on a per user namespace basis
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Expose the knob to user space through a proc file /proc/<pid>/setgroups

  A value of 0 means the setgroups system call is disabled in the
  current processes user namespace and can not be enabled in the
  future in this user namespace.

  A value of 1 means the segtoups system call is enabled.

- Descedent user namespaces inherit the value of setgroups from
  their parents.

- A proc file is used (instead of a sysctl) as sysctls
  currently do not pass in a struct file so file_ns_capable
  is unusable.

- Update new_idmap_permitted to allow unprivileged users to
  establish a mapping of their own gid, as such mappings
  can no longer allow dropping of supplemental groups.

This set of changes restores as much as possible the functionality
that was lost when new_idmap_permitted was modified to not allow
mappinges to be established without privilege.

As this fixes a regression from: "userns: Avoid problems with negative groups"
it is probably a candidate for a backport.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

This patch still needs a little bit of love.
I need to take a hard look at the interaction of barriers and atomic ops,
and it seems I have at least one comment fix that needs to move elsewhere.

But this should be enough to move the conversation forward.

 arch/s390/kernel/compat_linux.c |  1 +
 fs/proc/base.c                  | 31 ++++++++++----
 include/linux/user_namespace.h  |  3 ++
 kernel/groups.c                 |  1 +
 kernel/uid16.c                  |  1 +
 kernel/user.c                   |  1 +
 kernel/user_namespace.c         | 95 ++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 124 insertions(+), 9 deletions(-)

diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index 21c91feeca2d..6d0ee1b089fb 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -252,6 +252,7 @@ COMPAT_SYSCALL_DEFINE2(s390_setgroups16, int, gidsetsize, u16 __user *, grouplis
 	int retval;
 
 	if (!gid_mapping_possible(user_ns) ||
+	    !atomic_read(&user_ns->setgroups_allowed) ||
 	    !capable(CAP_SETGID))
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 772efa45a452..4ebed9f01d97 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2386,7 +2386,7 @@ static int proc_tgid_io_accounting(struct seq_file *m, struct pid_namespace *ns,
 #endif /* CONFIG_TASK_IO_ACCOUNTING */
 
 #ifdef CONFIG_USER_NS
-static int proc_id_map_open(struct inode *inode, struct file *file,
+static int proc_userns_open(struct inode *inode, struct file *file,
 	const struct seq_operations *seq_ops)
 {
 	struct user_namespace *ns = NULL;
@@ -2418,7 +2418,7 @@ err:
 	return ret;
 }
 
-static int proc_id_map_release(struct inode *inode, struct file *file)
+static int proc_userns_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *ns = seq->private;
@@ -2428,17 +2428,17 @@ static int proc_id_map_release(struct inode *inode, struct file *file)
 
 static int proc_uid_map_open(struct inode *inode, struct file *file)
 {
-	return proc_id_map_open(inode, file, &proc_uid_seq_operations);
+	return proc_userns_open(inode, file, &proc_uid_seq_operations);
 }
 
 static int proc_gid_map_open(struct inode *inode, struct file *file)
 {
-	return proc_id_map_open(inode, file, &proc_gid_seq_operations);
+	return proc_userns_open(inode, file, &proc_gid_seq_operations);
 }
 
 static int proc_projid_map_open(struct inode *inode, struct file *file)
 {
-	return proc_id_map_open(inode, file, &proc_projid_seq_operations);
+	return proc_userns_open(inode, file, &proc_projid_seq_operations);
 }
 
 static const struct file_operations proc_uid_map_operations = {
@@ -2446,7 +2446,7 @@ static const struct file_operations proc_uid_map_operations = {
 	.write		= proc_uid_map_write,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= proc_id_map_release,
+	.release	= proc_userns_release,
 };
 
 static const struct file_operations proc_gid_map_operations = {
@@ -2454,7 +2454,7 @@ static const struct file_operations proc_gid_map_operations = {
 	.write		= proc_gid_map_write,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= proc_id_map_release,
+	.release	= proc_userns_release,
 };
 
 static const struct file_operations proc_projid_map_operations = {
@@ -2462,7 +2462,20 @@ static const struct file_operations proc_projid_map_operations = {
 	.write		= proc_projid_map_write,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= proc_id_map_release,
+	.release	= proc_userns_release,
+};
+
+static int proc_setgroups_open(struct inode *inode, struct file *file)
+{
+	return proc_userns_open(inode, file, &proc_setgroups_seq_operations);
+}
+
+static const struct file_operations proc_setgroups_operations = {
+	.open		= proc_setgroups_open,
+	.write		= proc_setgroups_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= proc_userns_release,
 };
 #endif /* CONFIG_USER_NS */
 
@@ -2572,6 +2585,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
+	REG("setgroups",  S_IRUGO|S_IWUSR, proc_setgroups_operations),
 #endif
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	REG("timers",	  S_IRUGO, proc_timers_operations),
@@ -2913,6 +2927,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
+	REG("setgroups",  S_IRUGO|S_IWUSR, proc_setgroups_operations),
 #endif
 };
 
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 26d5e8f5db97..1e8cb168b1d0 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -27,6 +27,7 @@ struct user_namespace {
 	kuid_t			owner;
 	kgid_t			group;
 	unsigned int		proc_inum;
+	atomic_t		setgroups_allowed;
 
 	/* Register of per-UID persistent keyrings for this namespace */
 #ifdef CONFIG_PERSISTENT_KEYRINGS
@@ -65,9 +66,11 @@ struct seq_operations;
 extern const struct seq_operations proc_uid_seq_operations;
 extern const struct seq_operations proc_gid_seq_operations;
 extern const struct seq_operations proc_projid_seq_operations;
+extern const struct seq_operations proc_setgroups_seq_operations;
 extern ssize_t proc_uid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_gid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t, loff_t *);
+extern ssize_t proc_setgroups_write(struct file *, const char __user *, size_t, loff_t *);
 #else
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
diff --git a/kernel/groups.c b/kernel/groups.c
index b9a6a5c7e100..467ae954e859 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -226,6 +226,7 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
 	int retval;
 
 	if (!gid_mapping_possible(user_ns) ||
+	    !atomic_read(&user_ns->setgroups_allowed) ||
 	    !ns_capable(user_ns, CAP_SETGID))
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
diff --git a/kernel/uid16.c b/kernel/uid16.c
index 602c7de2aa11..096962fa1975 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -179,6 +179,7 @@ SYSCALL_DEFINE2(setgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
 	int retval;
 
 	if (!gid_mapping_possible(user_ns) ||
+	    !atomic_read(&user_ns->setgroups_allowed) ||
 	    !ns_capable(user_ns, CAP_SETGID))
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
diff --git a/kernel/user.c b/kernel/user.c
index 4efa39350e44..0d78759f7dbe 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -51,6 +51,7 @@ struct user_namespace init_user_ns = {
 	.owner = GLOBAL_ROOT_UID,
 	.group = GLOBAL_ROOT_GID,
 	.proc_inum = PROC_USER_INIT_INO,
+	.setgroups_allowed	= ATOMIC_INIT(1),
 #ifdef CONFIG_PERSISTENT_KEYRINGS
 	.persistent_keyring_register_sem =
 	__RWSEM_INITIALIZER(init_user_ns.persistent_keyring_register_sem),
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 51d65b444951..521c8d53ee17 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -98,6 +98,7 @@ int create_user_ns(struct cred *new)
 	ns->level = parent_ns->level + 1;
 	ns->owner = owner;
 	ns->group = group;
+	atomic_set(&ns->setgroups_allowed, atomic_read(&parent_ns->setgroups_allowed));
 
 	set_cred_user_ns(new, ns);
 
@@ -640,7 +641,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	if (!page)
 		goto out;
 
-	/* Only allow <= page size writes at the beginning of the file */
+	/* Only allow < page size writes at the beginning of the file */
 	ret = -EINVAL;
 	if ((*ppos != 0) || (count >= PAGE_SIZE))
 		goto out;
@@ -826,6 +827,11 @@ static bool new_idmap_permitted(const struct file *file,
 			kuid_t uid = make_kuid(ns->parent, id);
 			if (uid_eq(uid, cred->euid))
 				return true;
+		} else if (cap_setid == CAP_SETGID) {
+			kgid_t gid = make_kgid(ns->parent, id);
+			if (!atomic_read(&ns->setgroups_allowed) &&
+			    gid_eq(gid, cred->egid))
+				return true;
 		}
 	}
 
@@ -844,6 +850,93 @@ static bool new_idmap_permitted(const struct file *file,
 	return false;
 }
 
+static void *setgroups_m_start(struct seq_file *seq, loff_t *ppos)
+{
+	struct user_namespace *ns = seq->private;
+
+	return (*ppos == 0) ?  ns : NULL;
+}
+
+static void *setgroups_m_next(struct seq_file *seq, void *v, loff_t *ppos)
+{
+	++*ppos;
+	return NULL;
+}
+
+static void setgroups_m_stop(struct seq_file *seq, void *v)
+{
+}
+
+static int setgroups_m_show(struct seq_file *seq, void *v)
+{
+	struct user_namespace *ns = seq->private;
+
+	seq_printf(seq, "%u\n", atomic_read(&ns->setgroups_allowed));
+	return 0;
+}
+
+const struct seq_operations proc_setgroups_seq_operations = {
+	.start	= setgroups_m_start,
+	.stop = setgroups_m_stop,
+	.next = setgroups_m_next,
+	.show = setgroups_m_show,
+};
+
+ssize_t proc_setgroups_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	struct seq_file *seq = file->private_data;
+	struct user_namespace *ns = seq->private;
+	char kbuf[3];
+	int setgroups_allowed;
+	ssize_t ret;
+
+	ret = -EPERM;
+	if (!file_ns_capable(file, ns, CAP_SETGID))
+		goto out;
+
+	/* Only allow a very narrow range of strings to be written */
+	ret = -EINVAL;
+	if ((*ppos != 0) || (count >= sizeof(kbuf)) || (count < 1))
+		goto out;
+
+	/* What was written? */
+	ret = -EFAULT;
+	if (copy_from_user(kbuf, buf, count))
+		goto out;
+	kbuf[count] = '\0';
+
+	/* What is being requested? */
+	ret = -EINVAL;
+	if (kbuf[0] == '0')
+		setgroups_allowed = 0;
+	else if (kbuf[0] == '1')
+		setgroups_allowed = 1;
+	else
+		goto out;
+
+	/* Allow a trailing newline */
+	ret = -EINVAL;
+	if ((count == 2) && (kbuf[1] != '\n'))
+		goto out;
+
+
+	if (setgroups_allowed) {
+		ret = -EINVAL;
+		if (atomic_read(&ns->setgroups_allowed) == 0)
+			goto out;
+	} else {
+		atomic_set(&ns->setgroups_allowed, 0);
+		/* sigh memory barriers! */
+	}
+
+	/* Report a successful write */
+	*ppos = count;
+	ret = count;
+out:
+	return ret;
+}
+
 static void *userns_get(struct task_struct *task)
 {
 	struct user_namespace *user_ns;
-- 
1.9.1

