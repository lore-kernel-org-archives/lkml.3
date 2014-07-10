Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaGJLcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:32:47 -0400
Received: from relay.parallels.com ([195.214.232.42]:48841 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaGJLcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:32:45 -0400
Subject: [PATCH] fuse: release temporary page if fuse_writepage_locked()
 failed
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Thu, 10 Jul 2014 15:32:43 +0400
Message-ID: <20140710113233.26689.98237.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tmp_page to be freed if fuse_write_file_get() returns NULL.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 3a47aa2..a18baa4 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1679,7 +1679,7 @@ static int fuse_writepage_locked(struct page *page)
 	error = -EIO;
 	req->ff = fuse_write_file_get(fc, fi);
 	if (!req->ff)
-		goto err_free;
+		goto err_nofile;
 
 	fuse_write_fill(req, req->ff, page_offset(page), 0);
 
@@ -1707,6 +1707,8 @@ static int fuse_writepage_locked(struct page *page)
 
 	return 0;
 
+err_nofile:
+	__free_page(tmp_page);
 err_free:
 	fuse_request_free(req);
 err:

