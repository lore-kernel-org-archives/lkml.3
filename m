Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3KSWdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:33:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44099 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3KSWdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:33:17 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: bcrl@kvack.org, viro@zeniv.linux.org.uk
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 1/2] aio: prevent double free in ioctx_alloc
Date: Tue, 19 Nov 2013 17:33:02 -0500
Message-Id: <1384900383-22009-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioctx_alloc() calls aio_setup_ring() to allocate a ring. If aio_setup_ring()
fails to do so it would call aio_free_ring() before returning, but
ioctx_alloc() would call aio_free_ring() again causing a double free of
the ring.

This is easily reproducible from userspace.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/aio.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 699f53e..8b387a1 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -661,7 +661,6 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 err_cleanup:
 	aio_nr_sub(ctx->max_reqs);
 err:
-	aio_free_ring(ctx);
 	free_percpu(ctx->cpu);
 	free_percpu(ctx->reqs.pcpu_count);
 	free_percpu(ctx->users.pcpu_count);
-- 
1.7.10.4

