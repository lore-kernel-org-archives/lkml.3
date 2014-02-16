Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaBPLX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 06:23:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaBPLX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 06:23:56 -0500
Date: Sun, 16 Feb 2014 12:25:29 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/4] percpu_ida: Do not steal all remote CPU tags at once
Message-ID: <20140216112528.GA13853@dhcp-26-207.brq.redhat.com>
References: <cover.1391688720.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1391688720.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When stealing from a remote CPU all available tags are moved
from the remote CPU's cache to the stealing CPU's one. Since
the best CPU to steal from is not selected the victim might
actively performing IO and (as result of losing all local
tags) a further cycle of cache rebouncing and/or stealing
could be provoked.

This update is an attempt to soften the described scenario
and limit the number of tags to be stolen at once to the
value of percpu_batch_size.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
---
 lib/percpu_ida.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index fad029c..b4c4cc7 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -84,20 +84,22 @@ static inline void steal_tags(struct percpu_ida *pool,
 		pool->cpu_last_stolen = cpu;
 		remote = per_cpu_ptr(pool->tag_cpu, cpu);
 
-		cpumask_clear_cpu(cpu, &pool->cpus_have_tags);
-
-		if (remote == tags)
+		if (remote == tags) {
+			cpumask_clear_cpu(cpu, &pool->cpus_have_tags);
 			continue;
+		}
 
 		spin_lock(&remote->lock);
 
 		if (remote->nr_free) {
-			memcpy(tags->freelist,
-			       remote->freelist,
-			       sizeof(unsigned) * remote->nr_free);
+			const struct percpu_ida *p = pool;
+
+			move_tags(tags->freelist, &tags->nr_free,
+				  remote->freelist, &remote->nr_free,
+				  min(remote->nr_free, p->percpu_batch_size));
 
-			tags->nr_free = remote->nr_free;
-			remote->nr_free = 0;
+			if (!remote->nr_free)
+				cpumask_clear_cpu(cpu, &pool->cpus_have_tags);
 		}
 
 		spin_unlock(&remote->lock);
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
