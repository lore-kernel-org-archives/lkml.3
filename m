Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaIYMG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 08:06:58 -0400
Received: from relay.parallels.com ([195.214.232.42]:60821 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaIYMG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 08:06:57 -0400
Subject: [PATCH 4/5] fuse: add mount option to disable synchronous release
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, avati@gluster.org,
        linux-kernel@vger.kernel.org
Date: Thu, 25 Sep 2014 16:06:54 +0400
Message-ID: <20140925120639.540.78889.stgit@dhcp-10-30-22-200.sw.ru>
In-Reply-To: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
References: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Synchronous release ensures that kernel fuse reports to userspace exactly
last fput(). However, nothing guarantees that last fput() will happen in the
context of close(2). So userspace applications must be prepared to the
situation when close(2) returned, but processing of FUSE_RELEASE is not
completed by fuse daemon yet. To make testing such use cases easier, the
patch introduces DISABLE_SYNC_RELEASE mount option which effectively mask out
FOPEN_SYNC_RELEASE flag.

Also, the mount option can be used to protect from DoS scenarios with a sync
release: fusermount can be instrumented to use the option by default for
unprivileged mounts (allowing system administrator to configure it like
"user_allow_other").

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c   |    3 ++-
 fs/fuse/fuse_i.h |    3 +++
 fs/fuse/inode.c  |    8 ++++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 8713e62..c4599c8 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -292,7 +292,8 @@ static void fuse_prepare_release(struct fuse_file *ff, int flags, int opcode)
 
 static bool must_release_synchronously(struct fuse_file *ff)
 {
-	return ff->open_flags & FOPEN_SYNC_RELEASE;
+	return ff->open_flags & FOPEN_SYNC_RELEASE &&
+		!(ff->fc->flags & FUSE_DISABLE_SYNC_RELEASE);
 }
 
 void fuse_release_common(struct file *file, int opcode)
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e8e47a6..c5e2fca 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -44,6 +44,9 @@
     doing the mount will be allowed to access the filesystem */
 #define FUSE_ALLOW_OTHER         (1 << 1)
 
+/** Disable synchronous release */
+#define FUSE_DISABLE_SYNC_RELEASE (1 << 2)
+
 /** Number of page pointers embedded in fuse_req */
 #define FUSE_REQ_INLINE_PAGES 1
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 03246cd..86d47d0 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -463,6 +463,7 @@ enum {
 	OPT_ALLOW_OTHER,
 	OPT_MAX_READ,
 	OPT_BLKSIZE,
+	OPT_DISABLE_SYNC_RELEASE,
 	OPT_ERR
 };
 
@@ -475,6 +476,7 @@ static const match_table_t tokens = {
 	{OPT_ALLOW_OTHER,		"allow_other"},
 	{OPT_MAX_READ,			"max_read=%u"},
 	{OPT_BLKSIZE,			"blksize=%u"},
+	{OPT_DISABLE_SYNC_RELEASE,	"disable_sync_release"},
 	{OPT_ERR,			NULL}
 };
 
@@ -560,6 +562,10 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 			d->blksize = value;
 			break;
 
+		case OPT_DISABLE_SYNC_RELEASE:
+			d->flags |= FUSE_DISABLE_SYNC_RELEASE;
+			break;
+
 		default:
 			return 0;
 		}
@@ -583,6 +589,8 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",default_permissions");
 	if (fc->flags & FUSE_ALLOW_OTHER)
 		seq_puts(m, ",allow_other");
+	if (fc->flags & FUSE_DISABLE_SYNC_RELEASE)
+		seq_puts(m, ",disable_sync_release");
 	if (fc->max_read != ~0)
 		seq_printf(m, ",max_read=%u", fc->max_read);
 	if (sb->s_bdev && sb->s_blocksize != FUSE_DEFAULT_BLKSIZE)

