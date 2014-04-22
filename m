Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbaDVKPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:15:47 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:37597 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755491AbaDVKPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:15:04 -0400
X-IronPort-AV: E=Sophos;i="4.97,900,1389715200"; 
   d="scan'208";a="29566573"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Jiri Kosina <jkosina@suse.cz>, Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 4/4] idr: reorder the fields
Date: Tue, 22 Apr 2014 18:16:21 +0800
Message-ID: <1398161781-12105-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398161781-12105-1-git-send-email-laijs@cn.fujitsu.com>
References: <1398161781-12105-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_layer->layer is always accessed in read path,
move it in the front.

idr_layer->bitmap is moved on the bottom. And
rcu_head shares with bitmap due to they do not
be accessed at the same time.

idr->id_free/id_free_cnt/lock are free list fields,
and moved to the bottom. They will be removed
in near future.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/idr.h |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 3a77b33..c537c55 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -29,21 +29,24 @@
 
 struct idr_layer {
 	int			prefix;	/* the ID prefix of this idr_layer */
-	DECLARE_BITMAP(bitmap, IDR_SIZE); /* A zero bit means "space here" */
+	int			layer;	/* distance from leaf */
 	struct idr_layer __rcu	*ary[1<<IDR_BITS];
 	int			count;	/* When zero, we can release it */
-	int			layer;	/* distance from leaf */
-	struct rcu_head		rcu_head;
+	union {
+		/* A zero bit means "space here" */
+		DECLARE_BITMAP(bitmap, IDR_SIZE);
+		struct rcu_head		rcu_head;
+	};
 };
 
 struct idr {
 	struct idr_layer __rcu	*hint;	/* the last layer allocated from */
 	struct idr_layer __rcu	*top;
-	struct idr_layer	*id_free;
 	int			layers;	/* only valid w/o concurrent changes */
-	int			id_free_cnt;
 	int			cur;	/* current pos for cyclic allocation */
 	spinlock_t		lock;
+	int			id_free_cnt;
+	struct idr_layer	*id_free;
 };
 
 #define IDR_INIT(name)							\
-- 
1.7.4.4

