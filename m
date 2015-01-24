Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbbAXDQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 22:16:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56134 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827AbbAXDQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 22:16:09 -0500
Date: Fri, 23 Jan 2015 19:15:44 -0800
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
Subject: [RFC][PATCH v2] procfs: Always expose /proc/<pid>/map_files/ and
 make it readable
Message-ID: <20150124031544.GA1992748@mail.thefacebook.com>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
 <20150114152501.GB9820@node.dhcp.inet.fi>
 <20150114153323.GF2253@moon>
 <20150114204653.GA26698@mail.thefacebook.com>
 <20150114211613.GH2253@moon>
 <20150122024554.GB23762@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20150122024554.GB23762@mail.thefacebook.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-24_01:2015-01-24,2015-01-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.165369342820785 urlsuspect_oldscore=0.165369342820785
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.165369342820785 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501240030
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, /proc/<pid>/map_files/ is restricted to CAP_SYS_ADMIN, and
is only exposed if CONFIG_CHECKPOINT_RESTORE is set. This interface
is very useful for enumerating the files mapped into a process when
the more verbose information in /proc/<pid>/maps is not needed.

This patch moves the folder out from behind CHECKPOINT_RESTORE, and
removes the CAP_SYS_ADMIN restrictions. Following the links requires
the ability to ptrace the process in question, so this doesn't allow
an attacker to do anything they couldn't already do before.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
Changes in v2: 	Removed the follow_link() stub that returned -EPERM if
		the caller didn't have CAP_SYS_ADMIN, since the caller
		in my chroot() scenario gets -EACCES anyway.

 fs/proc/base.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3f3d7ae..67b15ac 100644
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
@@ -1792,10 +1785,6 @@ static struct dentry *proc_map_files_lookup(struct inode *dir,
 	int result;
 	struct mm_struct *mm;
 
-	result = -EPERM;
-	if (!capable(CAP_SYS_ADMIN))
-		goto out;
-
 	result = -ENOENT;
 	task = get_proc_task(dir);
 	if (!task)
@@ -1849,10 +1838,6 @@ proc_map_files_readdir(struct file *file, struct dir_context *ctx)
 	struct map_files_info *p;
 	int ret;
 
-	ret = -EPERM;
-	if (!capable(CAP_SYS_ADMIN))
-		goto out;
-
 	ret = -ENOENT;
 	task = get_proc_task(file_inode(file));
 	if (!task)
@@ -2040,7 +2025,6 @@ static const struct file_operations proc_timers_operations = {
 	.llseek		= seq_lseek,
 	.release	= seq_release_private,
 };
-#endif /* CONFIG_CHECKPOINT_RESTORE */
 
 static int proc_pident_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
@@ -2537,9 +2521,7 @@ static const struct inode_operations proc_task_inode_operations;
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
1.8.1

