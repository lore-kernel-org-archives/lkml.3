Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3JDKcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:32:08 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:37754 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3JDKcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:32:04 -0400
Subject: [PATCH 11/19] Check if the process is an ELF executable
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
Date: Fri, 04 Oct 2013 16:01:58 +0530
Message-ID: <20131004103157.1612.78311.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-5816-0000-0000-00000A3577A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

Validate if the process is an ELF exec. This will be later extended to identify
if the task is a native ELF or a compat ELF.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/proc/gencore.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/proc/gencore.c b/fs/proc/gencore.c
index 580a8b5..5f56910 100644
--- a/fs/proc/gencore.c
+++ b/fs/proc/gencore.c
@@ -22,6 +22,7 @@
  *      Suzuki K. Poulose <suzuki@in.ibm.com>
  */
 
+#include <linux/elf.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include "internal.h"
@@ -85,6 +86,29 @@ static int release_gencore(struct inode *inode, struct file *file)
 	return 0;
 }
 
+ /*
+ * Determine whether the task is an ELF executable.
+ * Returns
+ *     < 0     - Non-ELF
+ *     0       - Native ELF Executable
+ */
+static int get_elf_class(struct task_struct *task)
+{
+	struct elfhdr hdr;
+	int ret = 0;
+	ret = kernel_read(task->mm->exe_file, 0, (char*)&hdr, sizeof(hdr));
+	if (ret < 0)
+		return ret;
+	
+	/* Verify the ELF magic on the exe_file */
+	if (memcmp(hdr.e_ident, ELFMAG, SELFMAG))
+		return -EINVAL;
+	if (elf_check_arch(&hdr))
+		return 0;
+	
+	return -EINVAL;
+}
+
 /*
  * Validate if the call is valid. We also need to prevent >1 open
  * of the same file.
@@ -93,10 +117,15 @@ static int open_gencore(struct inode *inode, struct file *filp)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct core_proc *cp;
+	int elf_class;
 	int ret = 0;
 	if (!task)
 		return -ENOENT;
 
+	elf_class = get_elf_class(task);
+	if (elf_class < 0)
+		return elf_class;
+
 	mutex_lock(&core_mutex);
 	cp = get_core_proc(task);
 	mutex_unlock(&core_mutex);	

