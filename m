Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab3AXVoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:44:10 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39346 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab3AXVoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:44:04 -0500
From: Kent Overstreet <koverstreet@google.com>
To: akpm@linux-foundation.org
Cc: Kent Overstreet <koverstreet@google.com>, Valdis.Kletnieks@vt.edu,
        dhillf@gmail.com, bcrl@kvack.org, zab@zabbo.net,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/3] aio: Fix a null pointer deref in batch_complete_aio
Date: Thu, 24 Jan 2013 13:43:51 -0800
Message-Id: <1359063833-17174-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <20130124211850.GH26407@google.com>
References: <20130124211850.GH26407@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The batch completion code was trying to be a bit too clever, and skip
checking ctx where it couldn't be NULL - but that broke if a kiocb had
been cancelled. Move the check to kioctx_ring_unlock().

Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 62573d3..0d2f39d 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -683,6 +683,9 @@ static inline void kioctx_ring_unlock(struct kioctx *ctx, unsigned tail)
 {
 	struct aio_ring *ring;
 
+	if (!ctx)
+		return;
+
 	smp_wmb();
 	/* make event visible before updating tail */
 
@@ -760,8 +763,7 @@ void batch_complete_aio(struct batch_complete *batch)
 		}
 
 		if (unlikely(req->ki_ctx != ctx)) {
-			if (ctx)
-				kioctx_ring_unlock(ctx, tail);
+			kioctx_ring_unlock(ctx, tail);
 
 			ctx = req->ki_ctx;
 			tail = kioctx_ring_lock(ctx);
-- 
1.7.12

