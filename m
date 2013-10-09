Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab3JIAQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:16:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60582 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab3JIAQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:16:08 -0400
Date: Wed, 09 Oct 2013 01:16:07 +0100
To: torvalds@linux-foundation.org
Subject: [RFC][PATCH 12/13] spufs: get rid of dump_emit() wrappers
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VThRf-000302-Ot@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/platforms/cell/spufs/coredump.c |   69 +++++++------------------
 1 files changed, 20 insertions(+), 49 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index 5d9b0a2..1aaaa58 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -50,33 +50,6 @@ static ssize_t do_coredump_read(int num, struct spu_context *ctx, void *buffer,
 	return ++ret; /* count trailing NULL */
 }
 
-/*
- * These are the only things you should do on a core-file: use only these
- * functions to write out all the necessary info.
- */
-static int spufs_dump_write(struct coredump_params *cprm, const void *addr, int nr)
-{
-	if (!dump_emit(cprm, addr, nr))
-		return -EIO;
-	return 0;
-}
-
-static int spufs_dump_align(struct coredump_params *cprm, char *buf, loff_t new_off)
-{
-	int rc, size;
-
-	size = min((loff_t)PAGE_SIZE, new_off - cprm->written);
-	memset(buf, 0, size);
-
-	rc = 0;
-	while (rc == 0 && new_off > cprm->written) {
-		size = min((loff_t)PAGE_SIZE, new_off - cprm->written);
-		rc = spufs_dump_write(cprm, buf, size);
-	}
-
-	return rc;
-}
-
 static int spufs_ctx_note_size(struct spu_context *ctx, int dfd)
 {
 	int i, sz, total = 0;
@@ -159,7 +132,7 @@ static int spufs_arch_write_note(struct spu_context *ctx, int i,
 				  struct coredump_params *cprm, int dfd)
 {
 	loff_t pos = 0;
-	int sz, rc, nread, total = 0;
+	int sz, rc, total = 0;
 	const int bufsz = PAGE_SIZE;
 	char *name;
 	char fullname[80], *buf;
@@ -177,38 +150,36 @@ static int spufs_arch_write_note(struct spu_context *ctx, int i,
 	en.n_descsz = sz;
 	en.n_type = NT_SPU;
 
-	rc = spufs_dump_write(cprm, &en, sizeof(en));
-	if (rc)
-		goto out;
+	if (!dump_emit(cprm, &en, sizeof(en)))
+		goto Eio;
 
-	rc = spufs_dump_write(cprm, fullname, en.n_namesz);
-	if (rc)
-		goto out;
+	if (!dump_emit(cprm, fullname, en.n_namesz))
+		goto Eio;
 
-	rc = spufs_dump_align(cprm, buf, roundup(cprm->written, 4));
-	if (rc)
-		goto out;
+	if (!dump_skip(cprm, roundup(cprm->written, 4) - cprm->written))
+		goto Eio;
 
 	do {
-		nread = do_coredump_read(i, ctx, buf, bufsz, &pos);
-		if (nread > 0) {
-			rc = spufs_dump_write(cprm, buf, nread);
-			if (rc)
-				goto out;
-			total += nread;
+		rc = do_coredump_read(i, ctx, buf, bufsz, &pos);
+		if (rc > 0) {
+			if (!dump_emit(cprm, buf, rc))
+				goto Eio;
+			total += rc;
 		}
-	} while (nread == bufsz && total < sz);
+	} while (rc == bufsz && total < sz);
 
-	if (nread < 0) {
-		rc = nread;
+	if (rc < 0)
 		goto out;
-	}
-
-	rc = spufs_dump_align(cprm, buf, roundup(cprm->written - total + sz, 4));
 
+	if (!dump_skip(cprm,
+		       roundup(cprm->written - total + sz, 4) - cprm->written))
+		goto Eio;
 out:
 	free_page((unsigned long)buf);
 	return rc;
+Eio:
+	free_page((unsigned long)buf);
+	return -EIO;
 }
 
 int spufs_coredump_extra_notes_write(struct coredump_params *cprm)
-- 
1.7.2.5


