Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbbAVCq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:46:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50797 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894AbbAVCqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:46:16 -0500
Date: Wed, 21 Jan 2015 18:45:54 -0800
From: Calvin Owens <calvinowens@fb.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: [RFC][PATCH] procfs: Always expose /proc/<pid>/map_files/ and make
 it readable
Message-ID: <20150122024554.GB23762@mail.thefacebook.com>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
 <20150114152501.GB9820@node.dhcp.inet.fi>
 <20150114153323.GF2253@moon>
 <20150114204653.GA26698@mail.thefacebook.com>
 <20150114211613.GH2253@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20150114211613.GH2253@moon>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-22_01:2015-01-22,2015-01-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.128698695412054 urlsuspect_oldscore=0.128698695412054
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.128698695412054 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501220029
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, /proc/<pid>/map_files/ is restricted to CAP_SYS_ADMIN, and
is only exposed if CONFIG_CHECKPOINT_RESTORE is set. This interface
is very useful for enumerating the files mapped into a process when
the more verbose information in /proc/<pid>/maps is not needed.

This patch moves the folder out from behind CHECKPOINT_RESTORE, and
removes the CAP_SYS_ADMIN restrictions. To avoid exposing files to
processes for whom they may not be visible, a follow_link() stub is
added to the inode_operations struct attached to the symlinks that
prevent them from being followed without CAP_SYS_ADMIN.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 fs/proc/base.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3f3d7ae..7d48003 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1632,8 +1632,6 @@ end_instantiate:
 	return dir_emit(ctx, name, len, 1, DT_UNKNOWN);
 }
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
-
 /*
  * dname_to_vma_addr - maps a dentry name into two unsigned longs
  * which represent vma start and end addresses.
@@ -1660,11 +1658,6 @@ static int map_files_d_revalidate(struct dentry *dentry, unsigned int flags)
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
 
-	if (!capable(CAP_SYS_ADMIN)) {
-		status = -EPERM;
-		goto out_notask;
-	}
-
 	inode = dentry->d_inode;
 	task = get_proc_task(inode);
 	if (!task)
@@ -1753,6 +1746,28 @@ struct map_files_info {
 	unsigned char	name[4*sizeof(long)+2]; /* max: %lx-%lx\0 */
 };
 
+/*
+ * Allowing any user to follow the symlinks in /proc/<pid>/map_files/ could
+ * allow processes to access files that should not be visible to them, so
+ * restrict follow_link() to CAP_SYS_ADMIN for these files.
+ */
+static void *proc_map_files_follow_link(struct dentry *d, struct nameidata *n)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	return proc_pid_follow_link(d, n);
+}
+
+/*
+ * Identical to proc_pid_link_inode_operations except for follow_link()
+ */
+static const struct inode_operations proc_map_files_link_inode_operations = {
+	.readlink	= proc_pid_readlink,
+	.follow_link	= proc_map_files_follow_link,
+	.setattr	= proc_setattr,
+};
+
 static int
 proc_map_files_instantiate(struct inode *dir, struct dentry *dentry,
 			   struct task_struct *task, const void *ptr)
@@ -1768,7 +1783,7 @@ proc_map_files_instantiate(struct inode *dir, struct dentry *dentry,
 	ei = PROC_I(inode);
 	ei->op.proc_get_link = proc_map_files_get_link;
 
-	inode->i_op = &proc_pid_link_inode_operations;
+	inode->i_op = &proc_map_files_link_inode_operations;
 	inode->i_size = 64;
 	inode->i_mode = S_IFLNK;
 
@@ -1792,10 +1807,6 @@ static struct dentry *proc_map_files_lookup(struct inode *dir,
 	int result;
 	struct mm_struct *mm;
 
-	result = -EPERM;
-	if (!capable(CAP_SYS_ADMIN))
-		goto out;
-
 	result = -ENOENT;
 	task = get_proc_task(dir);
 	if (!task)
@@ -1849,10 +1860,6 @@ proc_map_files_readdir(struct file *file, struct dir_context *ctx)
 	struct map_files_info *p;
 	int ret;
 
-	ret = -EPERM;
-	if (!capable(CAP_SYS_ADMIN))
-		goto out;
-
 	ret = -ENOENT;
 	task = get_proc_task(file_inode(file));
 	if (!task)
@@ -2040,7 +2047,6 @@ static const struct file_operations proc_timers_operations = {
 	.llseek		= seq_lseek,
 	.release	= seq_release_private,
 };
-#endif /* CONFIG_CHECKPOINT_RESTORE */
 
 static int proc_pident_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
@@ -2537,9 +2543,7 @@ static const struct inode_operations proc_task_inode_operations;
 static const struct pid_entry tgid_base_stuff[] = {
 	DIR("task",       S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
 	DIR("fd",         S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
-#ifdef CONFIG_CHECKPOINT_RESTORE
 	DIR("map_files",  S_IRUSR|S_IXUSR, proc_map_files_inode_operations, proc_map_files_operations),
-#endif
 	DIR("fdinfo",     S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	DIR("ns",	  S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
 #ifdef CONFIG_NET
-- 
2.1.4

