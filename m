Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab3LFVxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:53:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758910Ab3LFVxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 3.12 79/83] aio: prevent double free in ioctx_alloc
Date: Fri,  6 Dec 2013 13:52:09 -0800
Message-Id: <20131206214647.391779303@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit d558023207e008a4476a3b7bb8706b2a2bf5d84f upstream.

ioctx_alloc() calls aio_setup_ring() to allocate a ring. If aio_setup_ring()
fails to do so it would call aio_free_ring() before returning, but
ioctx_alloc() would call aio_free_ring() again causing a double free of
the ring.

This is easily reproducible from userspace.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -661,7 +661,6 @@ static struct kioctx *ioctx_alloc(unsign
 err_cleanup:
 	aio_nr_sub(ctx->max_reqs);
 err:
-	aio_free_ring(ctx);
 	free_percpu(ctx->cpu);
 	free_percpu(ctx->reqs.pcpu_count);
 	free_percpu(ctx->users.pcpu_count);


