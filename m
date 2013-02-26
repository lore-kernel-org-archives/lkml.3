Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551Ab3BZPJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 10:09:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab3BZPJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 10:09:36 -0500
From: Mark Salter <msalter@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH 1/2] Fix AT_EXECFN auxv for no-MMU fdpic
Date: Tue, 26 Feb 2013 10:09:06 -0500
Message-Id: <1361891347-20806-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the no-MMU case, the FDPIC loader was passing an offset as the value for
the AT_EXECFN auxv. This patch translates that offset into an actual user
address.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 fs/binfmt_elf_fdpic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index cb240dd..af4c9a4 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -496,6 +496,7 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	sp = arch_align_stack(bprm->p);
 #else
 	sp = mm->start_stack;
+	bprm->exec = sp - (MAX_ARG_PAGES * PAGE_SIZE - bprm->exec);
 
 	/* stack the program arguments and environment */
 	if (elf_fdpic_transfer_args_to_stack(bprm, &sp) < 0)
-- 
1.8.1.2

