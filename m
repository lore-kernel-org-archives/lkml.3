Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbbAUEcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 23:32:03 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43747 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbAUEcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 23:32:01 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: iamjoonsoo.kim@lge.com, cl@linux.com, brouer@redhat.com,
        akpm@linux-foundation.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] mm/slub: use unchecked percpu access within preemptible sections
Date: Tue, 20 Jan 2015 23:31:43 -0500
Message-Id: <1421814703-1869-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "mm/slub: optimize alloc/free fastpath by removing preemption on/off"
has added access to percpu memory while the code is preemptible.

While those accesses are okay, this creates a huge amount of warnings from
the code that checks for that.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/slub.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 907fabe..9b72b9c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2431,8 +2431,8 @@ redo:
 	 * to check if it is matched or not.
 	 */
 	do {
-		tid = this_cpu_read(s->cpu_slab->tid);
-		c = this_cpu_ptr(s->cpu_slab);
+		tid = raw_cpu_read(s->cpu_slab->tid);
+		c = raw_cpu_ptr(s->cpu_slab);
 	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
 
 	/*
@@ -2700,8 +2700,8 @@ redo:
 	 * during the cmpxchg then the free will succedd.
 	 */
 	do {
-		tid = this_cpu_read(s->cpu_slab->tid);
-		c = this_cpu_ptr(s->cpu_slab);
+		tid = raw_cpu_read(s->cpu_slab->tid);
+		c = raw_cpu_ptr(s->cpu_slab);
 	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
 
 	/* Same with comment on barrier() in slab_alloc_node() */
-- 
1.7.10.4

