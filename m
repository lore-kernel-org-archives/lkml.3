Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbaDSLgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 07:36:49 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:55869 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752670AbaDSLfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 07:35:02 -0400
X-IronPort-AV: E=Sophos;i="4.97,888,1389715200"; 
   d="scan'208";a="29471756"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 6/9 V2] idr: avoid ping-pong
Date: Sat, 19 Apr 2014 19:38:13 +0800
Message-ID: <1397907496-5993-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397907496-5993-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
 <1397907496-5993-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ida callers always calls ida_pre_get() before ida_get_new*().
ida_pre_get() will always do layer allocation, which means the layer removal
in ida_get_new*() is helpless. ida_get_new*() frees and the ida_pre_get() for
the next ida_get_new*() allocates.

It causes an unneeded ping-pong. The aim "Throw away extra resources one by one"
can't be achieved. This speculative layer removal in ida_get_new*() can't
result expected optimization.

So we remove the unneeded layer removal in ida_get_new*().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 lib/idr.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 317fd35..25fe476 100644
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

