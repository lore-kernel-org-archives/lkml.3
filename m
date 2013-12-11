Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab3LKATZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 19:19:25 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:49292 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab3LKATY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:19:24 -0500
Date: Tue, 10 Dec 2013 16:19:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch alternative] mm, page_alloc: warn for non-blockable __GFP_NOFAIL
 allocation failure
In-Reply-To: <alpine.DEB.2.02.1312101504120.22701@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1312101618530.22701@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312091355360.11026@chino.kir.corp.google.com> <20131209152202.df3d4051d7dc61ada7c420a9@linux-foundation.org> <alpine.DEB.2.02.1312101504120.22701@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__GFP_NOFAIL may return NULL when coupled with GFP_NOWAIT or GFP_ATOMIC.

Luckily, nothing currently does such craziness.  So instead of causing
such allocations to loop (potentially forever), we maintain the current
behavior and also warn about the new users of the deprecated flag.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2536,8 +2536,15 @@ rebalance:
 	}
 
 	/* Atomic allocations - we can't balance anything */
-	if (!wait)
+	if (!wait) {
+		/*
+		 * All existing users of the deprecated __GFP_NOFAIL are
+		 * blockable, so warn of any new users that actually allow this
+		 * type of allocation to fail.
+		 */
+		WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL);
 		goto nopage;
+	}
 
 	/* Avoid recursion of direct reclaim */
 	if (current->flags & PF_MEMALLOC)
