Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab3LRV0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:26:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab3LRVN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        <stable@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 043/118] mm: memcg: do not allow task about to OOM kill to bypass the limit
Date: Wed, 18 Dec 2013 13:11:20 -0800
Message-Id: <20131218211220.694483457@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 1f14c1ac19aa45118054b6d5425873c5c7fc23a1 upstream.

Commit 4942642080ea ("mm: memcg: handle non-error OOM situations more
gracefully") allowed tasks that already entered a memcg OOM condition to
bypass the memcg limit on subsequent allocation attempts hoping this
would expedite finishing the page fault and executing the kill.

David Rientjes is worried that this breaks memcg isolation guarantees
and since there is no evidence that the bypass actually speeds up fault
processing just change it so that these subsequent charge attempts fail
outright.  The notable exception being __GFP_NOFAIL charges which are
required to bypass the limit regardless.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-bt: David Rientjes <rientjes@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2675,7 +2675,7 @@ static int __mem_cgroup_try_charge(struc
 		goto bypass;
 
 	if (unlikely(task_in_memcg_oom(current)))
-		goto bypass;
+		goto nomem;
 
 	if (gfp_mask & __GFP_NOFAIL)
 		oom = false;


