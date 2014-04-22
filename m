Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaDVKPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:15:13 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:37597 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754432AbaDVKPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:15:02 -0400
X-IronPort-AV: E=Sophos;i="4.97,900,1389715200"; 
   d="scan'208";a="29566559"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 2/4] idr: reduce the number of MAX_IDR_FREE
Date: Tue, 22 Apr 2014 18:16:19 +0800
Message-ID: <1398161781-12105-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398161781-12105-1-git-send-email-laijs@cn.fujitsu.com>
References: <1398161781-12105-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whe need to prepare MAX_IDR_FREE idr_layers for allocation.

But when idr is not empty, we need atmost (MAX_IDR_LEVEL - 1) idr_layers
to build up and atmost (MAX_IDR_LEVEL - 1) idr_layers to allocate down.
When idr is empty need atmost MAX_IDR_LEVEL layers.

So max((MAX_IDR_LEVEL * 2 - 2), MAX_IDR_LEVEL) idr_layers is enough.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 lib/idr.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 87c98fc..871991b 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -36,8 +36,13 @@
 /* Leave the possibility of an incomplete final layer */
 #define MAX_IDR_LEVEL ((MAX_IDR_SHIFT + IDR_BITS - 1) / IDR_BITS)
 
-/* Number of id_layer structs to leave in free list */
-#define MAX_IDR_FREE (MAX_IDR_LEVEL * 2)
+/*
+ * Number of idr_layer structs to leave in free list.
+ * When idr is not empty, we need atmost (MAX_IDR_LEVEL - 1) idr_layers
+ * to build up and atmost (MAX_IDR_LEVEL - 1) idr_layers to allocate down.
+ * When idr is empty need atmost MAX_IDR_LEVEL layers.
+ */
+#define MAX_IDR_FREE max((MAX_IDR_LEVEL * 2 - 2), MAX_IDR_LEVEL)
 
 static struct kmem_cache *idr_layer_cache;
 static DEFINE_PER_CPU(struct idr_layer *, idr_preload_head);
-- 
1.7.4.4

