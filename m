Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbbANAU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 19:20:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8671 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751845AbbANAU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 19:20:28 -0500
From: Calvin Owens <calvinowens@fb.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        <calvinowens@fb.com>
Subject: [RFC][PATCH] procfs: Add /proc/<pid>/mapped_files
Date: Tue, 13 Jan 2015 16:20:29 -0800
Message-ID: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-13_08:2015-01-13,2015-01-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=51.5900229690472
 compositescore=0.165369342820785 urlsuspect_oldscore=0.165369342820785
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.165369342820785 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501140002
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b76437579d1344b6 ("procfs: mark thread stack correctly in
proc/<pid>/maps") introduced logic to mark thread stacks with the
"[stack:%d]" marker in /proc/<pid>/maps.

This causes reading /proc/<pid>/maps to take O(N^2) time, where N is
the number of threads sharing an address space, since each line of
output requires iterating over the VMA list looking for ranges that
correspond to the stack pointer in any task's register set. When
dealing with highly-threaded Java applications, reading this file can
take hours and trigger softlockup dumps.

Eliminating the "[stack:%d]" marker is not a viable option since it's
been there for some time, and I don't see a way to do the stack check
more efficiently that wouldn't end up making the whole thing really
ugly.

The use case I'm specifically concerned with is the lsof command, so
this patch adds an additional file, "mapped_files", that simply
iterates over the VMAs associated with the task and outputs a
newline-delimited list of the pathnames of the files associated with
the VMAs, if any.

This gives lsof and suchlike a way to determine the pathnames of files
mapped into a process without incurring the O(N^2) behavior of the
maps file.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
I'm also sending a simple repro program as a reply to this E-Mail.

 fs/proc/base.c     |  1 +
 fs/proc/internal.h |  1 +
 fs/proc/task_mmu.c | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3f3d7ae..15f8bd0 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2564,6 +2564,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
 	REG("maps",       S_IRUGO, proc_pid_maps_operations),
+	REG("mapped_files", S_IRUGO, proc_mapped_files_operations),
 #ifdef CONFIG_NUMA
 	REG("numa_maps",  S_IRUGO, proc_pid_numa_maps_operations),
 #endif
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 6fcdba5..a09bbdd 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -284,6 +284,7 @@ struct mm_struct *proc_mem_open(struct inode *inode, unsigned int mode);
 
 extern const struct file_operations proc_pid_maps_operations;
 extern const struct file_operations proc_tid_maps_operations;
+extern const struct file_operations proc_mapped_files_operations;
 extern const struct file_operations proc_pid_numa_maps_operations;
 extern const struct file_operations proc_tid_numa_maps_operations;
 extern const struct file_operations proc_pid_smaps_operations;
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 246eae8..bc101e0 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -412,6 +412,38 @@ const struct file_operations proc_tid_maps_operations = {
 	.release	= proc_map_release,
 };
 
+static int show_next_mapped_file(struct seq_file *m, void *v)
+{
+	struct vm_area_struct *vma = v;
+	struct file *file = vma->vm_file;
+
+	if (file) {
+		seq_path(m, &file->f_path, "\n");
+		seq_putc(m, '\n');
+	}
+
+	return 0;
+}
+
+static const struct seq_operations mapped_files_seq_op = {
+	.start	= m_start,
+	.next	= m_next,
+	.stop	= m_stop,
+	.show	= show_next_mapped_file,
+};
+
+static int mapped_files_open(struct inode *inode, struct file *file)
+{
+	return do_maps_open(inode, file, &mapped_files_seq_op);
+}
+
+const struct file_operations proc_mapped_files_operations = {
+	.open		= mapped_files_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_private,
+};
+
 /*
  * Proportional Set Size(PSS): my share of RSS.
  *
-- 
2.1.4

