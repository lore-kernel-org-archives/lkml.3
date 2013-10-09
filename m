Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab3JIAQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:16:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60584 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab3JIAQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:16:18 -0400
Date: Wed, 09 Oct 2013 01:16:17 +0100
To: torvalds@linux-foundation.org
Subject: [RFC][PATCH 13/13] new helper: dump_align()
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VThRp-00030b-P9@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


dump_skip to given alignment...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/platforms/cell/spufs/coredump.c |    2 +-
 fs/binfmt_elf.c                              |   10 ++--------
 fs/binfmt_elf_fdpic.c                        |   10 ++--------
 fs/coredump.c                                |    6 ++++++
 include/linux/coredump.h                     |    1 +
 5 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index 1aaaa58..be6212d 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -156,7 +156,7 @@ static int spufs_arch_write_note(struct spu_context *ctx, int i,
 	if (!dump_emit(cprm, fullname, en.n_namesz))
 		goto Eio;
 
-	if (!dump_skip(cprm, roundup(cprm->written, 4) - cprm->written))
+	if (!dump_align(cprm, 4))
 		goto Eio;
 
 	do {
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index da33c1d..b28d141 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1225,12 +1225,6 @@ static int notesize(struct memelfnote *en)
 	return sz;
 }
 
-static int alignfile(struct coredump_params *cprm)
-{
-	static const char buf[4] = { 0, };
-	return dump_emit(cprm, buf, roundup(cprm->written, 4) - cprm->written);
-}
-
 static int writenote(struct memelfnote *men, struct coredump_params *cprm)
 {
 	struct elf_note en;
@@ -1239,8 +1233,8 @@ static int writenote(struct memelfnote *men, struct coredump_params *cprm)
 	en.n_type = men->type;
 
 	return dump_emit(cprm, &en, sizeof(en)) &&
-	    dump_emit(cprm, men->name, en.n_namesz) && alignfile(cprm) &&
-	    dump_emit(cprm, men->data, men->datasz) && alignfile(cprm);
+	    dump_emit(cprm, men->name, en.n_namesz) && dump_align(cprm, 4) &&
+	    dump_emit(cprm, men->data, men->datasz) && dump_align(cprm, 4);
 }
 
 static void fill_elf_header(struct elfhdr *elf, int segs,
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 723fa02..8847a91 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1267,12 +1267,6 @@ static int notesize(struct memelfnote *en)
 
 /* #define DEBUG */
 
-static int alignfile(struct coredump_params *cprm)
-{
-	static const char buf[4] = { 0, };
-	return dump_emit(cprm, buf, roundup(cprm->written, 4) - cprm->written);
-}
-
 static int writenote(struct memelfnote *men, struct coredump_params *cprm)
 {
 	struct elf_note en;
@@ -1281,8 +1275,8 @@ static int writenote(struct memelfnote *men, struct coredump_params *cprm)
 	en.n_type = men->type;
 
 	return dump_emit(cprm, &en, sizeof(en)) &&
-		dump_emit(cprm, men->name, en.n_namesz) && alignfile(cprm) &&
-		dump_emit(cprm, men->data, men->datasz) && alignfile(cprm);
+		dump_emit(cprm, men->name, en.n_namesz) && dump_align(cprm, 4) &&
+		dump_emit(cprm, men->data, men->datasz) && dump_align(cprm, 4);
 }
 
 static inline void fill_elf_fdpic_header(struct elfhdr *elf, int segs)
diff --git a/fs/coredump.c b/fs/coredump.c
index 489372e..ed68432 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -728,3 +728,9 @@ int dump_skip(struct coredump_params *cprm, size_t nr)
 	}
 }
 EXPORT_SYMBOL(dump_skip);
+
+int dump_align(struct coredump_params *cprm, int align)
+{
+	return dump_skip(cprm, roundup(cprm->written, align) - cprm->written);
+}
+EXPORT_SYMBOL(dump_align);
diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 07a0af9..d8eb880be 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -13,6 +13,7 @@
 struct coredump_params;
 extern int dump_skip(struct coredump_params *cprm, size_t nr);
 extern int dump_emit(struct coredump_params *cprm, const void *addr, int nr);
+extern int dump_align(struct coredump_params *cprm, int align);
 #ifdef CONFIG_COREDUMP
 extern void do_coredump(siginfo_t *siginfo);
 #else
-- 
1.7.2.5

