Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbaBEUxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:53:04 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48228 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaBEUFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:55 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 090/213] coredump: prevent double-free on an error path in core dumper
Date: Wed, 5 Feb 2014 15:00:45 -0500
Message-ID: <1391630568-49251-91-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f34f9d186df35e5c39163444c43b4fc6255e39c5 upstream.

In !CORE_DUMP_USE_REGSET case, if elf_note_info_init fails to allocate
memory for info->fields, it frees already allocated stuff and returns
error to its caller, fill_note_info.  Which in turn returns error to its
caller, elf_core_dump.  Which jumps to cleanup label and calls
free_note_info, which will happily try to free all info->fields again.
BOOM.

This is the fix.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/binfmt_elf.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index c21da8aebe46..eee4dd5a13cc 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1661,30 +1661,19 @@ static int elf_note_info_init(struct elf_note_info *info)
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
 	if (!info->psinfo)
-		goto notes_free;
+		return 0;
 	info->prstatus = kmalloc(sizeof(*info->prstatus), GFP_KERNEL);
 	if (!info->prstatus)
-		goto psinfo_free;
+		return 0;
 	info->fpu = kmalloc(sizeof(*info->fpu), GFP_KERNEL);
 	if (!info->fpu)
-		goto prstatus_free;
+		return 0;
 #ifdef ELF_CORE_COPY_XFPREGS
 	info->xfpu = kmalloc(sizeof(*info->xfpu), GFP_KERNEL);
 	if (!info->xfpu)
-		goto fpu_free;
+		return 0;
 #endif
 	return 1;
-#ifdef ELF_CORE_COPY_XFPREGS
- fpu_free:
-	kfree(info->fpu);
-#endif
- prstatus_free:
-	kfree(info->prstatus);
- psinfo_free:
-	kfree(info->psinfo);
- notes_free:
-	kfree(info->notes);
-	return 0;
 }
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,
-- 
1.8.5.2

