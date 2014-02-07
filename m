Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaBGSrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:47:32 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45971 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaBGSrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:47:31 -0500
Date: Sat, 8 Feb 2014 00:16:53 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, penberg@kernel.org
Subject: [PATCH] slub: Hold list_lock unconditionally before the call to
 add_full.
Message-ID: <20140207184653.GA5799@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020718-6688-0000-0000-000006330A27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>From the lockdep annotation and the comment that existed before the
lockdep annotations were introduced, 
mm/slub.c:add_full(s, n, page) expects to be called with n->list_lock
held.

However, there's a call path in deactivate_slab() when

	 (new.inuse || n->nr_partial <= s->min_partial) &&
	 !(new.freelist) &&
         !(kmem_cache_debug(s))

which ends up calling add_full() without holding
n->list_lock.

This was discovered while onlining/offlining cpus in 3.14-rc1 due to
the lockdep annotations added by commit
c65c1877bd6826ce0d9713d76e30a7bed8e49f38.

Fix this by unconditionally taking the lock
irrespective of the state of kmem_cache_debug(s).

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
---
 mm/slub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7e3e045..1f723f7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1882,7 +1882,7 @@ redo:
 		}
 	} else {
 		m = M_FULL;
-		if (kmem_cache_debug(s) && !lock) {
+		if (!lock) {
 			lock = 1;
 			/*
 			 * This also ensures that the scanning of full
-- 
1.8.3.1

