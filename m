Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaDRMsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:48:31 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:61818 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754224AbaDRMrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:47:15 -0400
X-IronPort-AV: E=Sophos;i="4.97,883,1389715200"; 
   d="scan'208";a="29445304"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 6/8] idr: avoid ping-pong
Date: Fri, 18 Apr 2014 20:49:53 +0800
Message-ID: <1397825404-12039-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ida callers always calls ida_pre_get() before ida_get_new*().
ida_pre_get() will do layer allocation, and ida_get_new*() will do layer removal.

It causes an unneeded ping-pong. The speculative layer removal in
ida_get_new*() can't result expected optimization.

So we remove the unneeded layer removal in ida_get_new*().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 lib/idr.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index e4f9965..be0b6ff 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -1001,17 +1001,6 @@ int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
 
 	*p_id = id;
 
-	/* Each leaf node can handle nearly a thousand slots and the
-	 * whole idea of ida is to have small memory foot print.
-	 * Throw away extra resources one by one after each successful
-	 * allocation.
-	 */
-	if (ida->idr.id_free_cnt || ida->free_bitmap) {
-		struct idr_layer *p = get_from_free_list(&ida->idr);
-		if (p)
-			kmem_cache_free(idr_layer_cache, p);
-	}
-
 	return 0;
 }
 EXPORT_SYMBOL(ida_get_new_above);
-- 
1.7.4.4

