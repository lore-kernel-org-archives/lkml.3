Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab3KAWNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:13:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab3KAWIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Weijie Yang <weijie.yang@samsung.com>, Bob Liu <bob.liu@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.11 55/66] mm/zswap: bugfix: memory leak when re-swapon
Date: Fri,  1 Nov 2013 15:07:31 -0700
Message-Id: <20131101220650.034216236@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weijie Yang <weijie.yang@samsung.com>

commit aa9bca05a467c61dcea4142b2877d5392de5bdce upstream.

zswap_tree is not freed when swapoff, and it got re-kmalloced in swapon,
so a memory leak occurs.

Free the memory of zswap_tree in zswap_frontswap_invalidate_area().

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Reviewed-by: Minchan Kim <minchan@kernel.org>
From: Weijie Yang <weijie.yang@samsung.com>
Subject: [PATCH 3.11 55/66] mm/zswap: bugfix: memory leak when invalidate and reclaim occur concurrently
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Consider the following scenario:
thread 0: reclaim entry x (get refcount, but not call zswap_get_swap_cache_page)
thread 1: call zswap_frontswap_invalidate_page to invalidate entry x.
	finished, entry x and its zbud is not freed as its refcount != 0
	now, the swap_map[x] = 0
thread 0: now call zswap_get_swap_cache_page
	swapcache_prepare return -ENOENT because entry x is not used any more
	zswap_get_swap_cache_page return ZSWAP_SWAPCACHE_NOMEM
	zswap_writeback_entry do nothing except put refcount
Now, the memory of zswap_entry x and its zpage leak.

Modify:
 - check the refcount in fail path, free memory if it is not referenced.

 - use ZSWAP_SWAPCACHE_FAIL instead of ZSWAP_SWAPCACHE_NOMEM as the fail path
   can be not only caused by nomem but also by invalidate.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

---
 mm/zswap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -816,6 +816,10 @@ static void zswap_frontswap_invalidate_a
 	}
 	tree->rbroot = RB_ROOT;
 	spin_unlock(&tree->lock);
+
+	zbud_destroy_pool(tree->pool);
+	kfree(tree);
+	zswap_trees[type] = NULL;
 }
 
 static struct zbud_ops zswap_zbud_ops = {


