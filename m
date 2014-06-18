Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964990AbaFRBJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 21:09:49 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:55446 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbaFRBIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 21:08:11 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org, kmo@daterainc.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 1/6] percpu-refcount, aio: use percpu_ref_cancel_init() in ioctx_alloc()
Date: Tue, 17 Jun 2014 21:08:00 -0400
Message-Id: <1403053685-28240-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403053685-28240-1-git-send-email-tj@kernel.org>
References: <1403053685-28240-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioctx_alloc() reaches inside percpu_ref and directly frees
->pcpu_count in its failure path, which is quite gross.  percpu_ref
has been providing a proper interface to do this,
percpu_ref_cancel_init(), for quite some time now.  Let's use that
instead.

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <kmo@daterainc.com>
---
 fs/aio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 4f078c0..5e0d7f9 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -715,8 +715,8 @@ err_ctx:
 err:
 	mutex_unlock(&ctx->ring_lock);
 	free_percpu(ctx->cpu);
-	free_percpu(ctx->reqs.pcpu_count);
-	free_percpu(ctx->users.pcpu_count);
+	percpu_ref_cancel_init(&ctx->reqs);
+	percpu_ref_cancel_init(&ctx->users);
 	kmem_cache_free(kioctx_cachep, ctx);
 	pr_debug("error allocating ioctx %d\n", err);
 	return ERR_PTR(err);
-- 
1.9.3

