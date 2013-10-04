Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3JDKdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:33:14 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:52076 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3JDKdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:33:10 -0400
Subject: [PATCH 17/19] Identify the ELF class of the process
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@in.ibm.com>
Cc: amwang@redhat.com, rdunlap@xenotime.net, andi@firstfloor.org,
        aravinda@linux.vnet.ibm.com, hch@lst.de, mhiramat@redhat.com,
        jeremy.fitzhardinge@citrix.com, xemul@parallels.com,
        suzuki@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com,
        adobriyan@gmail.com, tarundsk@linux.vnet.ibm.com, vapier@gentoo.org,
        roland@hack.frob.com, tj@kernel.org, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, d.hatayama@jp.fujitsu.com, james.hogan@imgtec.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Date: Fri, 04 Oct 2013 16:02:57 +0530
Message-ID: <20131004103257.1612.91461.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-1618-0000-0000-000004BC68AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

Identify the ELF class of the process to native or compat.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/proc/gencore.c |   17 ++++++++++++++---
 fs/proc/gencore.h |    3 +++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/proc/gencore.c b/fs/proc/gencore.c
index 463bedd..3e0db30 100644
--- a/fs/proc/gencore.c
+++ b/fs/proc/gencore.c
@@ -64,6 +64,9 @@ static ssize_t read_gencore(struct file *file, char __user *buffer,
 	}
 	mutex_unlock(&core_mutex);
 
+	if (cp->elf_class == ELF_CLASS_NATIVE)
+		ret = elf_read_gencore(cp, buffer, buflen, fpos);
+
 out:
 	put_task_struct(task);
 	return ret;
@@ -147,8 +150,8 @@ static int release_gencore(struct inode *inode, struct file *file)
  /*
  * Determine whether the task is an ELF executable.
  * Returns
- *     < 0     - Non-ELF
- *     0       - Native ELF Executable
+ *     -EINVAL - On non ELF execs
+ *     Returns the ELF_CLASS_NATIVE or ELF_CLASS_COMPAT
  */
 static int get_elf_class(struct task_struct *task)
 {
@@ -162,7 +165,14 @@ static int get_elf_class(struct task_struct *task)
 	if (memcmp(hdr.e_ident, ELFMAG, SELFMAG))
 		return -EINVAL;
 	if (elf_check_arch(&hdr))
-		return 0;
+		return ELF_CLASS_NATIVE;
+#ifdef CONFIG_COMPAT_BINFMT_ELF
+	{ 
+		struct elf32_hdr *chdr = (struct elf32_hdr *)&hdr;
+		if (compat_elf_check_arch(chdr))
+			return ELF_CLASS_COMPAT;
+	}
+#endif
 	
 	return -EINVAL;
 }
@@ -206,6 +216,7 @@ static int open_gencore(struct inode *inode, struct file *filp)
 	list_add(&cp->list, &core_list);
 	mutex_unlock(&core_mutex);
 	max_regset = get_max_regsets(task);
+	cp->elf_class = elf_class;
 
 	for (i = 0; i < get_nr_threads(task); i++) {
 		tinfo = kzalloc(offsetof(struct elf_thread_core_info,
diff --git a/fs/proc/gencore.h b/fs/proc/gencore.h
index f6822f2..d7a5fb3 100644
--- a/fs/proc/gencore.h
+++ b/fs/proc/gencore.h
@@ -8,6 +8,8 @@
 #include <linux/elfcore.h>
 #include <linux/elfcore-internal.h>
 
+enum { ELF_CLASS_NATIVE, ELF_CLASS_COMPAT };
+
 struct elf_thread_core_info {
 	unsigned short num_notes;       /* Number of notes for this thread */
 	struct elf_thread_core_info *next;
@@ -31,6 +33,7 @@ struct core_proc {
 	size_t nphdrs;          /* number of phdrs */
 	size_t notes_size;
 	size_t size;
+	unsigned char elf_class;
 };
 
 #ifdef CORE_DUMP_USE_REGSET

