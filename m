Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3J1KDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:03:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab3J1KDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:03:39 -0400
Date: Mon, 28 Oct 2013 11:05:48 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] percpu_ida: Optimize freeing tags when maximum cache
 size is 1
Message-ID: <20131028100547.GD5744@dhcp-26-207.brq.redhat.com>
References: <cover.1382950629.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1382950629.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case percpu_max_size is 1 percpu_ida_free() sets bit in
the cpumask and immediately transfers the tag to the pool.
As result, the very next call to percpu_ida_alloc() on the
same CPU will have to pull a tag from the pool to the local
cache and so on. Hence, positive effects of local caching
become largely negated.

This update assumes stealing tags is faster than ping-ponging
between local caches and the pool and prevents returning tags
to the pool in case percpu_max_size is 1.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 lib/percpu_ida.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 9dd8741..4adc3e5 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -243,9 +243,8 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 		 */
 		smp_wmb();
 		wake_up = true;
-	} 
-
-	if (nr_free == pool->percpu_max_size) {
+	} else if ((nr_free == pool->percpu_max_size) &&
+		   (pool->percpu_max_size > 1)) {
 		spin_lock(&pool->lock);
 
 		/*
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
