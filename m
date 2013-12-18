Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3LRV0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:26:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab3LRVNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        William Dauchy <wdauchy@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 042/118] mm: memcg: do not declare OOM from __GFP_NOFAIL allocations
Date: Wed, 18 Dec 2013 13:11:19 -0800
Message-Id: <20131218211220.666305852@linuxfoundation.org>
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

commit a0d8b00a3381f9d75764b3377590451cb0b4fe41 upstream.

Commit 84235de394d9 ("fs: buffer: move allocation failure loop into the
allocator") started recognizing __GFP_NOFAIL in memory cgroups but
forgot to disable the OOM killer.

Any task that does not fail allocation will also not enter the OOM
completion path.  So don't declare an OOM state in this case or it'll be
leaked and the task be able to bypass the limit until the next
userspace-triggered page fault cleans up the OOM state.

Reported-by: William Dauchy <wdauchy@gmail.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2677,6 +2677,9 @@ static int __mem_cgroup_try_charge(struc
 	if (unlikely(task_in_memcg_oom(current)))
 		goto bypass;
 
+	if (gfp_mask & __GFP_NOFAIL)
+		oom = false;
+
 	/*
 	 * We always charge the cgroup the mm_struct belongs to.
 	 * The mm_struct's mem_cgroup changes on task migration if the


