Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047Ab3GVQQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:16:41 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:36548 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962Ab3GVQMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:12:44 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Leibovici <thomas.leibovici@cea.fr>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 35/48] staging/lustre/lmv: support DNE with HSM.
Date: Tue, 23 Jul 2013 00:06:56 +0800
Message-Id: <1374509230-3324-36-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Leibovici <thomas.leibovici@cea.fr>

Send HSM requests to the appropriate MDT. Split lists of fids of HSM
actions into one list per MDT.
Move kuc registration/unregistration from MDC to LMV as this is not
MDT related.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3365
Lustre-change: http://review.whamcloud.com/6714
Signed-off-by: Thomas Leibovici <thomas.leibovici@cea.fr>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: jacques-Charles Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/llite_mmap.c |   36 +++++++++++++---------
 1 file changed, 21 insertions(+), 15 deletions(-)

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
1.7.9.5

