Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbaAaSYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:24:39 -0500
Received: from relay3.sgi.com ([192.48.152.1]:38904 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933017AbaAaSYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:24:03 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 3/3] exec: kill the unnecessary mm->def_flags setting in load_elf_binary()
Date: Fri, 31 Jan 2014 12:23:48 -0600
Message-Id: <1391192628-113858-8-git-send-email-athorlton@sgi.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1391192628-113858-1-git-send-email-athorlton@sgi.com>
References: <1391192628-113858-1-git-send-email-athorlton@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

load_elf_binary() sets current->mm->def_flags = def_flags and
def_flags is always zero. Not only this looks strange, this is
unnecessary because mm_init() has already set ->def_flags = 0.

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org

---
 fs/binfmt_elf.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 67be295..d09bd9c 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -579,7 +579,6 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long reloc_func_desc __maybe_unused = 0;
 	int executable_stack = EXSTACK_DEFAULT;
-	unsigned long def_flags = 0;
 	struct pt_regs *regs = current_pt_regs();
 	struct {
 		struct elfhdr elf_ex;
@@ -719,9 +718,6 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	if (retval)
 		goto out_free_dentry;
 
-	/* OK, This is the point of no return */
-	current->mm->def_flags = def_flags;
-
 	/* Do this immediately, since STACK_TOP as used in setup_arg_pages
 	   may depend on the personality.  */
 	SET_PERSONALITY(loc->elf_ex);
-- 
1.7.12.4

