Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab3LDKZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:25:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:7174 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab3LDKZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:25:56 -0500
X-IronPort-AV: E=Sophos;i="4.93,823,1378828800"; 
   d="scan'208";a="9189412"
Message-ID: <529F019A.2040401@cn.fujitsu.com>
Date: Wed, 04 Dec 2013 18:19:06 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin <bcrl@kvack.org>
CC: linux-aio@kvack.org, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Kent <kmo@daterainc.com>, Kristian Nielsen <knielsen@knielsen-hq.org>
Subject: [PATCH] aio: clean up aio ring in the fail path
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/04 18:25:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/04 18:25:47,
	Serialize complete at 2013/12/04 18:25:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the aio ring file in the fail path of aio_setup_ring
and ioctx_alloc. And maybe it can fix the GPF issue reported by
Dave Jones:
https://lkml.org/lkml/2013/11/25/898


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/aio.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 08159ed..6efb7f6 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -367,8 +367,10 @@ static int aio_setup_ring(struct kioctx *ctx)
 	if (nr_pages > AIO_RING_PAGES) {
 		ctx->ring_pages = kcalloc(nr_pages, sizeof(struct page *),
 					  GFP_KERNEL);
-		if (!ctx->ring_pages)
+		if (!ctx->ring_pages) {
+			put_aio_ring_file(ctx);
 			return -ENOMEM;
+		}
 	}
 
 	ctx->mmap_size = nr_pages * PAGE_SIZE;
@@ -645,7 +647,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	    aio_nr + nr_events < aio_nr) {
 		spin_unlock(&aio_nr_lock);
 		err = -EAGAIN;
-		goto err;
+		goto err_ctx;
 	}
 	aio_nr += ctx->max_reqs;
 	spin_unlock(&aio_nr_lock);
@@ -662,6 +664,8 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
 err_cleanup:
 	aio_nr_sub(ctx->max_reqs);
+err_ctx:
+	aio_free_ring(ctx);
 err:
 	free_percpu(ctx->cpu);
 	free_percpu(ctx->reqs.pcpu_count);
-- 
1.7.7


