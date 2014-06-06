Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaFFNbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:31:34 -0400
Received: from relay.parallels.com ([195.214.232.42]:44554 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaFFNbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:31:34 -0400
Subject: [PATCH 5/5] fuse: fix synchronous case of fuse_file_put()
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Fri, 06 Jun 2014 17:31:32 +0400
Message-ID: <20140606133005.30321.2888.stgit@localhost.localdomain>
In-Reply-To: <20140606132541.30321.68679.stgit@localhost.localdomain>
References: <20140606132541.30321.68679.stgit@localhost.localdomain>
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
index 783cb52..9f38568 100644
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

