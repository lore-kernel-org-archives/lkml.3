Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab3FDX0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:26:40 -0400
Received: from 1wt.eu ([62.212.114.60]:35184 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab3FDWky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:40:54 -0400
Message-Id: <20130604172131.347714149@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:55 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Denys Vlasenko <vda.linux@googlemail.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 025/184] coredump: prevent double-free on an error path in
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 core dumper

From: Denys Vlasenko <vda.linux@googlemail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/binfmt_elf.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index a64fde6..c564293 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1699,30 +1699,19 @@ static int elf_note_info_init(struct elf_note_info *info)
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
1.7.12.2.21.g234cd45.dirty



