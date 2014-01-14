Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaANByc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:54:32 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:42541 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaANBya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 20:54:30 -0500
Date: Mon, 13 Jan 2014 17:54:04 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Michal Hocko <mhocko@suse.cz>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] mm/memcg: iteration skip memcgs not yet fully
 initialized
In-Reply-To: <alpine.LSU.2.11.1401131742370.2229@eggly.anvils>
Message-ID: <alpine.LSU.2.11.1401131752360.2229@eggly.anvils>
References: <alpine.LSU.2.11.1401131742370.2229@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is surprising that the mem_cgroup iterator can return memcgs which
have not yet been fully initialized.  By accident (or trial and error?)
this appears not to present an actual problem; but it may be better to
prevent such surprises, by skipping memcgs not yet online.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
Decide for yourself whether to take this or not.  I spent quite a while
digging into a mysterious "trying to register non-static key" issue from
lockdep, which originated from the iterator returning a vmalloc'ed memcg
a moment before the res_counter_init()s had done their spin_lock_init()s.
But the backtrace was an odd one of our own mis-devising, not a charge or
reclaim or stats trace, so probably it's never been a problem for vanilla.

 mm/memcontrol.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- mmotm/mm/memcontrol.c	2014-01-10 18:25:02.236448954 -0800
+++ linux/mm/memcontrol.c	2014-01-12 22:21:10.700570471 -0800
@@ -1119,10 +1119,8 @@ skip_node:
 	 * protected by css_get and the tree walk is rcu safe.
 	 */
 	if (next_css) {
-		struct mem_cgroup *mem = mem_cgroup_from_css(next_css);
-
-		if (css_tryget(&mem->css))
-			return mem;
+		if ((next_css->flags & CSS_ONLINE) && css_tryget(next_css))
+			return mem_cgroup_from_css(next_css);
 		else {
 			prev_css = next_css;
 			goto skip_node;
