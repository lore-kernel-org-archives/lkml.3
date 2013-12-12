Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3LLSBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:01:30 -0500
Received: from relay3.sgi.com ([192.48.152.1]:42861 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752031Ab3LLSAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:00:46 -0500
Date: Thu, 12 Dec 2013 12:00:44 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Michel Lespinasse <walken@google.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Jiang Liu <jiang.liu@huawei.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC PATCH 1/3] Add flags for temporary compound pages
Message-ID: <20131212180044.GB134240@sgi.com>
References: <cover.1386790423.git.athorlton@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1386790423.git.athorlton@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This chunk of the patch just adds the necessary page flags to support
what I call a temporary compound page.  Temporary compound pages provide
us with the ability to turn a chunk of pages into a proper THP at some
point after pulling them off the free list, but also allow us to fault
in single 4K pages from the chunk.

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nate Zimmer <nzimmer@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Rientjes <rientjes@google.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org

---
 include/linux/gfp.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 9b4dd49..6ec63dd 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -35,6 +35,7 @@ struct vm_area_struct;
 #define ___GFP_NO_KSWAPD	0x400000u
 #define ___GFP_OTHER_NODE	0x800000u
 #define ___GFP_WRITE		0x1000000u
+#define ___GFP_COMP_TEMP	0x2000000u
 /* If the above are modified, __GFP_BITS_SHIFT may need updating */
 
 /*
@@ -77,6 +78,7 @@ struct vm_area_struct;
 #define __GFP_NORETRY	((__force gfp_t)___GFP_NORETRY) /* See above */
 #define __GFP_MEMALLOC	((__force gfp_t)___GFP_MEMALLOC)/* Allow access to emergency reserves */
 #define __GFP_COMP	((__force gfp_t)___GFP_COMP)	/* Add compound page metadata */
+#define __GFP_COMP_TEMP	((__force gfp_t)___GFP_COMP_TEMP)	/* Treat as temp compound page */
 #define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)	/* Return zeroed page on success */
 #define __GFP_NOMEMALLOC ((__force gfp_t)___GFP_NOMEMALLOC) /* Don't use emergency reserves.
 							 * This takes precedence over the
@@ -121,6 +123,9 @@ struct vm_area_struct;
 #define GFP_TRANSHUGE	(GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
 			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | \
 			 __GFP_NO_KSWAPD)
+#define GFP_TEMP_TRANSHUGE	(GFP_HIGHUSER_MOVABLE | __GFP_COMP_TEMP | \
+				 __GFP_NOMEMALLOC | __GFP_NORETRY | \
+				 __GFP_NOWARN | __GFP_NO_KSWAPD)
 
 #ifdef CONFIG_NUMA
 #define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
-- 
1.7.12.4


