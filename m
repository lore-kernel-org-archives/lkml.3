Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab3KSWd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:33:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44106 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab3KSWdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:33:18 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: bcrl@kvack.org, viro@zeniv.linux.org.uk
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 2/2] aio: nullify aio->ring_pages after freeing it
Date: Tue, 19 Nov 2013 17:33:03 -0500
Message-Id: <1384900383-22009-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384900383-22009-1-git-send-email-sasha.levin@oracle.com>
References: <1384900383-22009-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After freeing ring_pages we leave it as is causing a dangling pointer. This
has already caused an issue so to help catching any issues in the future
NULL it out.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/aio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 8b387a1..d6e8467 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -251,8 +251,10 @@ static void aio_free_ring(struct kioctx *ctx)
 
 	put_aio_ring_file(ctx);
 
-	if (ctx->ring_pages && ctx->ring_pages != ctx->internal_pages)
+	if (ctx->ring_pages && ctx->ring_pages != ctx->internal_pages) {
 		kfree(ctx->ring_pages);
+		ctx->ring_pages = NULL;
+	}
 }
 
 static int aio_ring_mmap(struct file *file, struct vm_area_struct *vma)
-- 
1.7.10.4

