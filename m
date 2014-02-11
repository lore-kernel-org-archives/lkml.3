Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaBKTEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:04:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbaBKTEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:04:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 013/120] mm/memcg: iteration skip memcgs not yet fully initialized
Date: Tue, 11 Feb 2014 11:04:14 -0800
Message-Id: <20140211184823.906131987@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit d8ad30559715ce97afb7d1a93a12fd90e8fff312 upstream.

It is surprising that the mem_cgroup iterator can return memcgs which
have not yet been fully initialized.  By accident (or trial and error?)
this appears not to present an actual problem; but it may be better to
prevent such surprises, by skipping memcgs not yet online.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1100,10 +1100,8 @@ skip_node:
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


