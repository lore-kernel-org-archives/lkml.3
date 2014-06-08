Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557AbaFHU4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 16:56:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbaFHU4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 16:56:35 -0400
Date: Sun, 8 Jun 2014 16:55:57 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mgorman@suse.de, mingo@kernel.org,
        torvalds@linux-foundation.org
Subject: [PATCH] numa,sched: fix load_to_imbalanced logic inversion
Message-ID: <20140608165557.4d97eea4@annuminas.surriel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is supposed to return true if the new load imbalance
is worse than the old one. It didn't. I can only hope brown paper
bags are in style.

Now things converge much better on both the 4 node and 8 node systems.

I am not sure why this did not seem to impact specjbb performance on
the 4 node system, which is the system I have full-time access to.

This bug was introduced recently, with commit e63da036

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6a90f67..7fb3e47 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1112,7 +1112,7 @@ static bool load_too_imbalanced(long orig_src_load, long orig_dst_load,
 	old_imb = orig_dst_load * 100 - orig_src_load * env->imbalance_pct;
 
 	/* Would this change make things worse? */
-	return (old_imb > imb);
+	return (imb > old_imb);
 }
 
 /*

