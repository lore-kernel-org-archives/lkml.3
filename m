Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967030AbaCUBcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:32:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760076AbaCUADO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 006/149] memcg: fix endless loop in __mem_cgroup_iter_next()
Date: Thu, 20 Mar 2014 17:02:49 -0700
Message-Id: <20140321000437.113505531@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit ce48225fe3b1b0d1fc9fceb96ac3d8a879e45114 upstream.

Commit 0eef615665ed ("memcg: fix css reference leak and endless loop in
mem_cgroup_iter") got the interaction with the commit a few before it
d8ad30559715 ("mm/memcg: iteration skip memcgs not yet fully
initialized") slightly wrong, and we didn't notice at the time.

It's elusive, and harder to get than the original, but for a couple of
days before rc1, I several times saw a endless loop similar to that
supposedly being fixed.

This time it was a tighter loop in __mem_cgroup_iter_next(): because we
can get here when our root has already been offlined, and the ordering
of conditions was such that we then just cycled around forever.

Fixes: 0eef615665ed ("memcg: fix css reference leak and endless loop in mem_cgroup_iter").
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1108,8 +1108,8 @@ skip_node:
 	 * skipping css reference should be safe.
 	 */
 	if (next_css) {
-		if ((next_css->flags & CSS_ONLINE) &&
-				(next_css == &root->css || css_tryget(next_css)))
+		if ((next_css == &root->css) ||
+		    ((next_css->flags & CSS_ONLINE) && css_tryget(next_css)))
 			return mem_cgroup_from_css(next_css);
 
 		prev_css = next_css;


