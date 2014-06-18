Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbaFRBIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 21:08:15 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:57156 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704AbaFRBIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 21:08:13 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org, kmo@daterainc.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] percpu-refcount: one bit is enough for REF_STATUS
Date: Tue, 17 Jun 2014 21:08:01 -0400
Message-Id: <1403053685-28240-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403053685-28240-1-git-send-email-tj@kernel.org>
References: <1403053685-28240-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu-refcount currently reserves two lowest bits of its percpu
pointer to indicate its state; however, only one bit is used for
PCPU_REF_DEAD.

Simplify it by removing PCPU_STATUS_BITS/MASK and testing
PCPU_REF_DEAD directly.  This also allows the compiler to choose a
more efficient instruction depending on the architecture.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/linux/percpu-refcount.h | 4 +---
 lib/percpu-refcount.c           | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 5d8920e..bfdeb0d4 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -88,12 +88,10 @@ static inline void percpu_ref_kill(struct percpu_ref *ref)
 	return percpu_ref_kill_and_confirm(ref, NULL);
 }
 
-#define PCPU_STATUS_BITS	2
-#define PCPU_STATUS_MASK	((1 << PCPU_STATUS_BITS) - 1)
 #define PCPU_REF_PTR		0
 #define PCPU_REF_DEAD		1
 
-#define REF_STATUS(count)	(((unsigned long) count) & PCPU_STATUS_MASK)
+#define REF_STATUS(count)	(((unsigned long) count) & PCPU_REF_DEAD)
 
 /**
  * percpu_ref_get - increment a percpu refcount
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 963b703..17bce2b 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -96,7 +96,7 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 
 	/* Mask out PCPU_REF_DEAD */
 	pcpu_count = (unsigned __percpu *)
-		(((unsigned long) pcpu_count) & ~PCPU_STATUS_MASK);
+		(((unsigned long) pcpu_count) & ~PCPU_REF_DEAD);
 
 	for_each_possible_cpu(cpu)
 		count += *per_cpu_ptr(pcpu_count, cpu);
-- 
1.9.3

