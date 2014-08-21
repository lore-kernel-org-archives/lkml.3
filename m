Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaHUQJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:09:30 -0400
Received: from relay.parallels.com ([195.214.232.42]:58842 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaHUQJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:09:28 -0400
Subject: [PATCH 5/6] fuse: fix synchronous case of fuse_file_put()
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, avati@gluster.org,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Aug 2014 20:09:25 +0400
Message-ID: <20140821160916.11005.37344.stgit@localhost.localdomain>
In-Reply-To: <20140821160304.11005.15166.stgit@localhost.localdomain>
References: <20140821160304.11005.15166.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If fuse_file_put() is called with sync==true, the user may be blocked for
a while, until userspace ACKs our FUSE_RELEASE request. This blocking must be
uninterruptible. Otherwise request could be interrupted, but file association
in user space remains.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index cd55488..b92143a 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -136,6 +136,10 @@ static void fuse_file_put(struct fuse_file *ff, bool sync)
 			path_put(&req->misc.release.path);
 			fuse_put_request(ff->fc, req);
 		} else if (sync) {
+			/* Must force. Otherwise request could be interrupted,
+			 * but file association in user space remains.
+			 */
+			req->force = 1;
 			req->background = 0;
 			fuse_request_send(ff->fc, req);
 			path_put(&req->misc.release.path);

