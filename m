Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaFJTuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:50:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35146 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbaFJTuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:50:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Leon Yu <chianglungyu@gmail.com>, Benjamin LaHaise <bcrl@kvack.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 122/160] aio: fix potential leak in aio_run_iocb().
Date: Tue, 10 Jun 2014 12:46:02 -0700
Message-Id: <1402429600-20477-123-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Yu <chianglungyu@gmail.com>

commit 754320d6e166d3a12cb4810a452bde00afbd4e9a upstream.

iovec should be reclaimed whenever caller of rw_copy_check_uvector() returns,
but it doesn't hold when failure happens right after aio_setup_vectored_rw().

Fix that in a such way to avoid hairy goto.

Signed-off-by: Leon Yu <chianglungyu@gmail.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.9.1

