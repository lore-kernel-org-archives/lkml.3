Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab3AOPHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:07:06 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:29949 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114Ab3AOPHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:07:04 -0500
Subject: [PATCH] fuse: enable close_wait feature (v2)
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org,
        anand.avati@gmail.com
Date: Tue, 15 Jan 2013 19:07:01 +0400
Message-ID: <20130115150355.18759.92630.stgit@maximpc.sw.ru>
In-Reply-To: <20121220123204.4101.14064.stgit@maximpc.sw.ru>
References: <20121220123204.4101.14064.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch enables feature by passing 'true' to fuse_file_put in
fuse_release_common.

Previously, this was safe only in special cases when we sure that
multi-threaded userspace won't deadlock if we'll synchronously send
FUSE_RELEASE in the context of read-ahead or write-back callback. Now, it's
always safe because callbacks don't send requests to userspace anymore.

Changed in v2: update the patch to be applied cleanly on the top of
previous modified (v2) patch of the patch-set.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 150033a..83c8904 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -279,7 +279,8 @@ void fuse_release_common(struct file *file, int opcode)
 	 * synchronous RELEASE is allowed (and desirable) in this case
 	 * because the server can be trusted not to screw up.
 	 */
-	fuse_file_put(ff, ff->fc->destroy_req != NULL);
+	fuse_file_put(ff, ff->fc->destroy_req != NULL ||
+			  ff->fc->close_wait);
 }
 
 static int fuse_open(struct inode *inode, struct file *file)

