Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab3AXVoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:44:18 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:61721 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3AXVoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:44:05 -0500
From: Kent Overstreet <koverstreet@google.com>
To: akpm@linux-foundation.org
Cc: Kent Overstreet <koverstreet@google.com>, Valdis.Kletnieks@vt.edu,
        dhillf@gmail.com, bcrl@kvack.org, zab@zabbo.net,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/3] aio-kill-ki_retry-fix-fix
Date: Thu, 24 Jan 2013 13:43:52 -0800
Message-Id: <1359063833-17174-2-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1359063833-17174-1-git-send-email-koverstreet@google.com>
References: <1359063833-17174-1-git-send-email-koverstreet@google.com>
In-Reply-To: <20130124211850.GH26407@google.com>
References: <20130124211850.GH26407@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "aio: kill ki-retry" patch was assuming that we didn't touch struct
kiocb after passing it off to something that would call aio_complete() -
which was wrong. So, revert the refcounting changes.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 0d2f39d..85d1b38 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -592,7 +592,7 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 
 	memset(req, 0, offsetof(struct kiocb, ki_ctx));
 	req->ki_ctx = ctx;
-	atomic_set(&req->ki_users, 1);
+	atomic_set(&req->ki_users, 2);
 	return req;
 out_put:
 	put_reqs_available(ctx, 1);
@@ -1291,10 +1291,12 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	if (ret)
 		goto out_put_req;
 
+	aio_put_req(req);	/* drop extra ref to req */
 	return 0;
 out_put_req:
 	put_reqs_available(ctx, 1);
-	aio_put_req(req);
+	aio_put_req(req);	/* drop extra ref to req */
+	aio_put_req(req);	/* drop i/o ref to req */
 	return ret;
 }
 
-- 
1.7.12

