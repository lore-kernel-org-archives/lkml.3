Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaFFNaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:30:04 -0400
Received: from relay.parallels.com ([195.214.232.42]:44285 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaFFNaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:30:01 -0400
Subject: [PATCH 4/5] fuse: enable close_wait feature
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Fri, 06 Jun 2014 17:30:00 +0400
Message-ID: <20140606132924.30321.54543.stgit@localhost.localdomain>
In-Reply-To: <20140606132541.30321.68679.stgit@localhost.localdomain>
References: <20140606132541.30321.68679.stgit@localhost.localdomain>
User-Agent: StGit/0.16
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

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index d50af99..783cb52 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -328,7 +328,8 @@ void fuse_release_common(struct file *file, int opcode)
 	 * synchronous RELEASE is allowed (and desirable) in this case
 	 * because the server can be trusted not to screw up.
 	 */
-	fuse_file_put(ff, ff->fc->destroy_req != NULL);
+	fuse_file_put(ff, ff->fc->destroy_req != NULL ||
+			  ff->fc->close_wait);
 }
 
 static int fuse_open(struct inode *inode, struct file *file)

