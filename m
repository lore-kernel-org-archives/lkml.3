Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3BEJXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:23:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40638 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab3BEJX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:23:28 -0500
X-IronPort-AV: E=Sophos;i="4.84,603,1355068800"; 
   d="scan'208";a="6691734"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org, mgorman@suse.de, bcrl@kvack.org,
        viro@zeniv.linux.org.uk
Cc: khlebnikov@openvz.org, walken@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        minchan@kernel.org, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, zab@redhat.com,
        jmoyer@redhat.com, linux-mm@kvack.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH V2 2/2] fs/aio.c: use get_user_pages_non_movable() to pin ring pages when support memory hotremove
Date: Tue, 5 Feb 2013 17:21:53 +0800
Message-Id: <1360056113-14294-3-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1360056113-14294-1-git-send-email-linfeng@cn.fujitsu.com>
References: <1360056113-14294-1-git-send-email-linfeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 17:22:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 17:22:01,
	Serialize complete at 2013/02/05 17:22:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch gets around the aio ring pages can't be migrated bug caused by
get_user_pages() via using the new function. It only works as configed with
CONFIG_MEMORY_HOTREMOVE, otherwise it falls back to use the old version
 of get_user_pages().

Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Zach Brown <zab@redhat.com>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 fs/aio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 71f613c..f7a0d5c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -138,8 +138,8 @@ static int aio_setup_ring(struct kioctx *ctx)
 	}
 
 	dprintk("mmap address: 0x%08lx\n", info->mmap_base);
-	info->nr_pages = get_user_pages(current, ctx->mm,
-					info->mmap_base, nr_pages, 
+	info->nr_pages = get_user_pages_non_movable(current, ctx->mm,
+					info->mmap_base, nr_pages,
 					1, 0, info->ring_pages, NULL);
 	up_write(&ctx->mm->mmap_sem);
 
-- 
1.7.1

