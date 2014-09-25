Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaIYMHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 08:07:15 -0400
Received: from relay.parallels.com ([195.214.232.42]:32958 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaIYMHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 08:07:11 -0400
Subject: [PATCH 5/5] fuse: enable close_wait synchronous release
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, avati@gluster.org,
        linux-kernel@vger.kernel.org
Date: Thu, 25 Sep 2014 16:07:08 +0400
Message-ID: <20140925120659.540.9507.stgit@dhcp-10-30-22-200.sw.ru>
In-Reply-To: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
References: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch enables the feature by passing 'true' to fuse_file_put in
fuse_release_common.

Previously, this was safe only in special cases when we sure that
multi-threaded userspace won't deadlock if we'll synchronously send
FUSE_RELEASE in the context of read-ahead or write-back callback. Now, it's
always safe because callbacks don't send requests to userspace anymore.

The feature can be made privileged by means of DISABLE_SYNC_RELEASE mount
option implemented by the previous patch.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index c4599c8..858280f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -334,7 +334,8 @@ void fuse_release_common(struct file *file, int opcode)
 	 * synchronous RELEASE is allowed (and desirable) in this case
 	 * because the server can be trusted not to screw up.
 	 */
-	fuse_file_put(ff, ff->fc->destroy_req != NULL);
+	fuse_file_put(ff, ff->fc->destroy_req != NULL ||
+			  must_release_synchronously(ff));
 }
 
 static int fuse_open(struct inode *inode, struct file *file)

