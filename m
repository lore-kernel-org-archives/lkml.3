Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab3GXIgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:36:10 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:31931 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750855Ab3GXIgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:36:02 -0400
From: mail-agent-noreply@emc.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 2/8] staging/lustre/llite: handle io init failure in ll_fault_io_init()
Date: Wed, 24 Jul 2013 16:31:26 +0800
Message-Id: <1374654692-13237-3-git-send-email-mail-agent-noreply@emc.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374654692-13237-2-git-send-email-mail-agent-noreply@emc.com>
References: <1374654692-13237-1-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-2-git-send-email-mail-agent-noreply@emc.com>
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John L. Hammond <john.hammond@intel.com>

In ll_fault_io_init(), if cl_io_init() has failed then cleanup and
return an ERR_PTR(). This fixes an oops in the page fault handling
code when a partially initialized io is used. In ll_page_mkwrite0() do
not call cl_io_fini() on an ERR_PTR().

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3487
Lustre-change: http://review.whamcloud.com/6735
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/llite_mmap.c |   36 +++++++++++++---------
 1 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_mmap.c b/drivers/staging/lustre/lustre/llite/llite_mmap.c
index d9590d8..8aa1dae 100644
--- a/drivers/staging/lustre/lustre/llite/llite_mmap.c
+++ b/drivers/staging/lustre/lustre/llite/llite_mmap.c
@@ -107,11 +107,12 @@ struct cl_io *ll_fault_io_init(struct vm_area_struct *vma,
 			       struct cl_env_nest *nest,
 			       pgoff_t index, unsigned long *ra_flags)
 {
-	struct file       *file  = vma->vm_file;
-	struct inode      *inode = file->f_dentry->d_inode;
-	struct cl_io      *io;
-	struct cl_fault_io *fio;
-	struct lu_env     *env;
+	struct file	       *file = vma->vm_file;
+	struct inode	       *inode = file->f_dentry->d_inode;
+	struct cl_io	       *io;
+	struct cl_fault_io     *fio;
+	struct lu_env	       *env;
+	int			rc;
 	ENTRY;
 
 	*env_ret = NULL;
@@ -152,17 +153,22 @@ struct cl_io *ll_fault_io_init(struct vm_area_struct *vma,
 	CDEBUG(D_MMAP, "vm_flags: %lx (%lu %d)\n", vma->vm_flags,
 	       fio->ft_index, fio->ft_executable);
 
-	if (cl_io_init(env, io, CIT_FAULT, io->ci_obj) == 0) {
+	rc = cl_io_init(env, io, CIT_FAULT, io->ci_obj);
+	if (rc == 0) {
 		struct ccc_io *cio = ccc_env_io(env);
 		struct ll_file_data *fd = LUSTRE_FPRIVATE(file);
 
 		LASSERT(cio->cui_cl.cis_io == io);
 
-		/* mmap lock must be MANDATORY
-		 * it has to cache pages. */
+		/* mmap lock must be MANDATORY it has to cache
+		 * pages. */
 		io->ci_lockreq = CILR_MANDATORY;
-
-		cio->cui_fd  = fd;
+		cio->cui_fd = fd;
+	} else {
+		LASSERT(rc < 0);
+		cl_io_fini(env, io);
+		cl_env_nested_put(nest, env);
+		io = ERR_PTR(rc);
 	}
 
 	return io;
@@ -190,7 +196,7 @@ static int ll_page_mkwrite0(struct vm_area_struct *vma, struct page *vmpage,
 
 	result = io->ci_result;
 	if (result < 0)
-		GOTO(out, result);
+		GOTO(out_io, result);
 
 	io->u.ci_fault.ft_mkwrite = 1;
 	io->u.ci_fault.ft_writable = 1;
@@ -252,14 +258,14 @@ static int ll_page_mkwrite0(struct vm_area_struct *vma, struct page *vmpage,
 	}
 	EXIT;
 
-out:
+out_io:
 	cl_io_fini(env, io);
 	cl_env_nested_put(&nest, env);
-
+out:
 	CDEBUG(D_MMAP, "%s mkwrite with %d\n", current->comm, result);
-
 	LASSERT(ergo(result == 0, PageLocked(vmpage)));
-	return(result);
+
+	return result;
 }
 
 
-- 
1.7.1

