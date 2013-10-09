Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab3JIAPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:15:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60578 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab3JIAPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:15:48 -0400
Date: Wed, 09 Oct 2013 01:15:47 +0100
To: torvalds@linux-foundation.org
Subject: [RFC][PATCH 10/13] make dump_emit() use vfs_write() instead of
 banging at ->f_op->write directly
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VThRL-0002yt-ON@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... and deal with short writes properly - the output might be to pipe, after
all; as it is, e.g. no-MMU case of elf_fdpic coredump can write a whole lot
more than a page worth of data at one call.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/coredump.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 319f973..478ebad 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -696,13 +696,20 @@ EXPORT_SYMBOL(dump_write);
 int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
 {
 	struct file *file = cprm->file;
-	if (dump_interrupted() || !access_ok(VERIFY_READ, addr, nr))
-		return 0;
+	loff_t pos = file->f_pos;
+	ssize_t n;
 	if (cprm->written + nr > cprm->limit)
 		return 0;
-	if (file->f_op->write(file, addr, nr, &file->f_pos) != nr)
-		return 0;
-	cprm->written += nr;
+	while (nr) {
+		if (dump_interrupted())
+			return 0;
+		n = vfs_write(file, addr, nr, &pos);
+		if (n < 0)
+			return 0;
+		file->f_pos = pos;
+		cprm->written += n;
+		nr -= n;
+	}
 	return 1;
 }
 EXPORT_SYMBOL(dump_emit);
-- 
1.7.2.5


