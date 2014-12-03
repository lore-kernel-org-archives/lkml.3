Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaLCL1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:27:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbaLCL1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:41 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sergei Antonov <saproj@gmail.com>,
        Anton Altaparmakov <aia21@cam.ac.uk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 087/101] hfsplus: emit proper file type from readdir
Date: Wed,  3 Dec 2014 12:26:49 +0100
Message-Id: <f96abf0060149fbc2093c2de7f4dae9fbff20694.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Antonov <saproj@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 97a62eaefdc196969e9d3857f65fc8a90ee1fe3c upstream.

hfsplus_readdir() incorrectly returned DT_REG for symbolic links and
special files.  Return DT_REG, DT_LNK, DT_FIFO, DT_CHR, DT_BLK, DT_SOCK,
or DT_UNKNOWN according to mode field in catalog record.  Programs
relying on information from readdir will now work correctly with HFS+.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/hfsplus/dir.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 4a4fea002673..64112185f47c 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -212,13 +212,31 @@ static int hfsplus_readdir(struct file *file, struct dir_context *ctx)
 				    be32_to_cpu(entry.folder.id), DT_DIR))
 				break;
 		} else if (type == HFSPLUS_FILE) {
+			u16 mode;
+			unsigned type = DT_UNKNOWN;
+
 			if (fd.entrylength < sizeof(struct hfsplus_cat_file)) {
 				pr_err("small file entry\n");
 				err = -EIO;
 				goto out;
 			}
+
+			mode = be16_to_cpu(entry.file.permissions.mode);
+			if (S_ISREG(mode))
+				type = DT_REG;
+			else if (S_ISLNK(mode))
+				type = DT_LNK;
+			else if (S_ISFIFO(mode))
+				type = DT_FIFO;
+			else if (S_ISCHR(mode))
+				type = DT_CHR;
+			else if (S_ISBLK(mode))
+				type = DT_BLK;
+			else if (S_ISSOCK(mode))
+				type = DT_SOCK;
+
 			if (!dir_emit(ctx, strbuf, len,
-				    be32_to_cpu(entry.file.id), DT_REG))
+				      be32_to_cpu(entry.file.id), type))
 				break;
 		} else {
 			pr_err("bad catalog entry type\n");
-- 
2.1.3

