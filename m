Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3JDKbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:31:18 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:33103 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3JDKbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:31:13 -0400
Subject: [PATCH 03/19] Make fill_psinfo generic
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
Date: Fri, 04 Oct 2013 16:01:06 +0530
Message-ID: <20131004103106.1612.23691.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-8256-0000-0000-000009803EB0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

fill_psinfo() fills the NT_PRPSINFO note for the core. NT_PRPSINFO stores the
command line of the process, which is stored at from mm->arg_start. Make
fill_psinfo reusable by supporting other tasks. Use access_process_vm() to read
the command line args for non-current task.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/binfmt_elf.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 107bbd3..4eee017 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1222,9 +1222,21 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	len = mm->arg_end - mm->arg_start;
 	if (len >= ELF_PRARGSZ)
 		len = ELF_PRARGSZ-1;
-	if (copy_from_user(&psinfo->pr_psargs,
-		           (const char __user *)mm->arg_start, len))
-		return -EFAULT;
+	/*
+	* If we are dumping core for "another task"
+	* we can't use copy_from_user().
+	*/
+	if (p->mm == current->mm) {
+		if (copy_from_user(&psinfo->pr_psargs,
+				(const char __user *)mm->arg_start, len))
+			return -EFAULT;
+	} else {
+		int bytes = access_process_vm(p, mm->arg_start,
+						&psinfo->pr_psargs, len, 0);
+		if (bytes != len)
+			return -EFAULT;
+	}
+
 	for(i = 0; i < len; i++)
 		if (psinfo->pr_psargs[i] == 0)
 			psinfo->pr_psargs[i] = ' ';

