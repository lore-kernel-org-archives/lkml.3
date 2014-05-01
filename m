Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaEADco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 23:32:44 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:38845 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaEADcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 23:32:43 -0400
From: Leon Yu <chianglungyu@gmail.com>
To: Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Leon Yu <chianglungyu@gmail.com>
Subject: [PATCH] aio: fix potential leak in aio_run_iocb().
Date: Thu,  1 May 2014 03:31:28 +0000
Message-Id: <1398915088-8472-1-git-send-email-chianglungyu@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iovec should be reclaimed whenever caller of rw_copy_check_uvector() returns,
but it doesn't hold when failure happens right after aio_setup_vectored_rw().

Fix that in a such way to avoid hairy goto.

Signed-off-by: Leon Yu <chianglungyu@gmail.com>
---
 fs/aio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 12a3de0e..04cd768 100644
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
1.9.2

