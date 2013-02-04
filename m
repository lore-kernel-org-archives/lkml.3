Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3BDKFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:05:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63158 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab3BDKFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:05:35 -0500
X-IronPort-AV: E=Sophos;i="4.84,599,1355068800"; 
   d="scan'208";a="6687006"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org, mgorman@suse.de, bcrl@kvack.org,
        viro@zeniv.linux.org.uk
Cc: khlebnikov@openvz.org, walken@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        minchan@kernel.org, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, linux-mm@kvack.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH 2/2] fs/aio.c: use get_user_pages_non_movable() to pin ring pages when support memory hotremove
Date: Mon, 4 Feb 2013 18:04:08 +0800
Message-Id: <1359972248-8722-3-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1359972248-8722-1-git-send-email-linfeng@cn.fujitsu.com>
References: <1359972248-8722-1-git-send-email-linfeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/04 18:04:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/04 18:04:17,
	Serialize complete at 2013/02/04 18:04:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch gets around the aio ring pages can't be migrated bug caused by
get_user_pages() via using the new function. It only works as configed with
CONFIG_MEMORY_HOTREMOVE, otherwise it uses the old version of get_user_pages().

Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 fs/aio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 71f613c..0e9b30a 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -138,9 +138,15 @@ static int aio_setup_ring(struct kioctx *ctx)
 	}
 
 	dprintk("mmap address: 0x%08lx\n", info->mmap_base);
+#ifdef CONFIG_MEMORY_HOTREMOVE
+	info->nr_pages = get_user_pages_non_movable(current, ctx->mm,
+					info->mmap_base, nr_pages,
+					1, 0, info->ring_pages, NULL);
+#else
 	info->nr_pages = get_user_pages(current, ctx->mm,
 					info->mmap_base, nr_pages, 
 					1, 0, info->ring_pages, NULL);
+#endif
 	up_write(&ctx->mm->mmap_sem);
 
 	if (unlikely(info->nr_pages != nr_pages)) {
-- 
1.7.11.7

