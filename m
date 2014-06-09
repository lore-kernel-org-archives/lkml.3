Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaFIJSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:18:06 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58385 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754811AbaFIIvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:23 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Leon Yu <chianglungyu@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 033/146] aio: fix potential leak in aio_run_iocb().
Date: Mon,  9 Jun 2014 10:49:28 +0200
Message-Id: <a2883106e6594d0b4dcb36066b6e82d85ecaa865.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leon Yu <chianglungyu@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 754320d6e166d3a12cb4810a452bde00afbd4e9a upstream.

iovec should be reclaimed whenever caller of rw_copy_check_uvector() returns,
but it doesn't hold when failure happens right after aio_setup_vectored_rw().

Fix that in a such way to avoid hairy goto.

Signed-off-by: Leon Yu <chianglungyu@gmail.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/aio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 12a3de0ee6da..04cd7686555d 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1299,10 +1299,8 @@ rw_common:
 						&iovec, compat)
 			: aio_setup_single_vector(req, rw, buf, &nr_segs,
 						  iovec);
-		if (ret)
-			return ret;
-
-		ret = rw_verify_area(rw, file, &req->ki_pos, req->ki_nbytes);
+		if (!ret)
+			ret = rw_verify_area(rw, file, &req->ki_pos, req->ki_nbytes);
 		if (ret < 0) {
 			if (iovec != &inline_vec)
 				kfree(iovec);
-- 
1.9.3

