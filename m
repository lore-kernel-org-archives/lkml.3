Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab3BZPJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 10:09:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab3BZPJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 10:09:52 -0500
From: Mark Salter <msalter@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH 2/2] Fix /proc/<pid>/auxv for FDPIC binaries
Date: Tue, 26 Feb 2013 10:09:07 -0500
Message-Id: <1361891347-20806-2-git-send-email-msalter@redhat.com>
In-Reply-To: <1361891347-20806-1-git-send-email-msalter@redhat.com>
References: <1361891347-20806-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FDPIC loader is not storing aux vector info in mm->saved_aux so the aux vectors were
not being exposed through /proc/<pid>/auxv. This patch copies the aux vectors stored on
the user stack into mm->saved_aux so that they may be available through procfs.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 fs/binfmt_elf_fdpic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index af4c9a4..9651918 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -478,7 +478,7 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 				   struct elf_fdpic_params *interp_params)
 {
 	const struct cred *cred = current_cred();
-	unsigned long sp, csp, nitems;
+	unsigned long sp, csp, nitems, auxv_end;
 	elf_caddr_t __user *argv, *envp;
 	size_t platform_len = 0, len;
 	char *k_platform, *k_base_platform;
@@ -594,6 +594,7 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	} while (0)
 
 	nr = 0;
+	auxv_end = csp;
 	csp -= 2 * sizeof(unsigned long);
 	NEW_AUX_ENT(AT_NULL, 0);
 	if (k_platform) {
@@ -645,6 +646,10 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 #endif
 #undef NEW_AUX_ENT
 
+	if (copy_from_user(current->mm->saved_auxv,
+			   (const char __user *) csp, auxv_end - csp))
+		return -EFAULT;
+
 	/* allocate room for argv[] and envv[] */
 	csp -= (bprm->envc + 1) * sizeof(elf_caddr_t);
 	envp = (elf_caddr_t __user *) csp;
-- 
1.8.1.2

