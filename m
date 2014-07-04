Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaGDIZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:25:19 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60682 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaGDIZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:25:13 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53B664E5.5060102@lge.com>
Date: Fri, 04 Jul 2014 17:25:09 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonsoo Kim <js1304@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
CC: =?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>, Gi-Oh Kim <gurugio@gmail.com>
Subject: [PATCH] [RFC] CMA: clear buffer-head lru before page migration
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

For page migration of CMA, buffer-heads of lru should be dropped.
Please refer to https://lkml.org/lkml/2014/6/23/932 for the detail.

I'm attaching a patch to drop all buffer-head on lru with invalidate_bh_lrus.
Please look into this. Thanks

------------------------------ 8< ---------------------------------
>From d90cd3d13b73f7278c60d8fe625840664adcbb6a Mon Sep 17 00:00:00 2001
From: Gioh Kim <gioh.kim@lge.com>
Date: Fri, 4 Jul 2014 16:53:22 +0900
Subject: [PATCH] [RFC] CMA: clear buffer-head lru before page migration

When CMA try to migrate page, some buffer-heads can exist on lru.
The bh on lru has non-zero count value so that it cannot be dropped
even-if it is not used. We can drop only buffers related to the
migrated page, but it can take long time more than dropping all
because of searching list. There all buffers in lru are dropped.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 fs/buffer.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index eba6e4f..4f11b7a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3233,6 +3233,19 @@ int try_to_free_buffers(struct page *page)
        if (PageWriteback(page))
                return 0;

+#ifdef CONFIG_CMA
+       /*
+        * When CMA try to migrate page, some buffer-heads can exist on lru.
+        * The bh on lru has non-zero count value so that it cannot
+        * be dropped even-if it is not used.
+        * We can drop only buffers related to the migrated page,
+        * but it can take long time more than dropping all
+        * because of searching list.
+        * There all buffers in lru are dropped first.
+        */
+       invalidate_bh_lrus();
+#endif
+
        if (mapping == NULL) {          /* can this still happen? */
                ret = drop_buffers(page, &buffers_to_free);
                goto out;
--
1.7.9.5
