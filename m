Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab3J1KC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:02:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab3J1KC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:02:58 -0400
Date: Mon, 28 Oct 2013 11:05:06 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] percpu_ida: Fix data race on cpus_have_tags cpumask
Message-ID: <20131028100505.GB5744@dhcp-26-207.brq.redhat.com>
References: <cover.1382950629.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1382950629.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function steal_tags() might miss a bit in cpus_have_tags due to
unsynchronized access from percpu_ida_free(). As result, function
percpu_ida_alloc() might enter unwakable sleep. This update adds
memory barriers to prevent the described scenario.

In fact, accesses to cpus_have_tags are fenced by prepare_to_wait()
and wake_up() calls at the moment and the aforementioned sequence
does not appear could hit. Nevertheless, explicit memory barriers
still seem justifiable.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 lib/percpu_ida.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index b0698ea..96cfacf 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -68,6 +68,11 @@ static inline void steal_tags(struct percpu_ida *pool,
 	unsigned cpus_have_tags, cpu = pool->cpu_last_stolen;
 	struct percpu_ida_cpu *remote;
 
+	/*
+	 * Pairs with smp_wmb() in percpu_ida_free()
+	 */
+	smp_rmb();
+
 	for (cpus_have_tags = cpumask_weight(&pool->cpus_have_tags);
 	     cpus_have_tags * pool->percpu_max_size > pool->nr_tags / 2;
 	     cpus_have_tags--) {
@@ -231,8 +236,11 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 	spin_unlock(&tags->lock);
 
 	if (nr_free == 1) {
-		cpumask_set_cpu(smp_processor_id(),
-				&pool->cpus_have_tags);
+		cpumask_set_cpu(smp_processor_id(), &pool->cpus_have_tags);
+		/*
+		 * Pairs with smp_rmb() in steal_tags()
+		 */
+		smp_wmb();
 		wake_up(&pool->wait);
 	}
 
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
