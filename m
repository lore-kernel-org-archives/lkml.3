Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaHUTEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:04:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbaHUTEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:04:34 -0400
Date: Thu, 21 Aug 2014 21:01:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] mempolicy: kill
	do_set_mempolicy()->down_write(&mm->mmap_sem)
Message-ID: <20140821190138.GD8703@redhat.com>
References: <20140805194627.GA30693@redhat.com> <20140820192207.GA8524@redhat.com> <20140821190020.GA8703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821190020.GA8703@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove down_write(&mm->mmap_sem) in do_set_mempolicy(). This logic
was never correct and it is no longer needed, see the previous patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/mempolicy.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4378c33..9695a9a 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -802,7 +802,6 @@ static long do_set_mempolicy(unsigned short mode, unsigned short flags,
 			     nodemask_t *nodes)
 {
 	struct mempolicy *new, *old;
-	struct mm_struct *mm = current->mm;
 	NODEMASK_SCRATCH(scratch);
 	int ret;
 
@@ -814,20 +813,11 @@ static long do_set_mempolicy(unsigned short mode, unsigned short flags,
 		ret = PTR_ERR(new);
 		goto out;
 	}
-	/*
-	 * prevent changing our mempolicy while show_numa_maps()
-	 * is using it.
-	 * Note:  do_set_mempolicy() can be called at init time
-	 * with no 'mm'.
-	 */
-	if (mm)
-		down_write(&mm->mmap_sem);
+
 	task_lock(current);
 	ret = mpol_set_nodemask(new, nodes, scratch);
 	if (ret) {
 		task_unlock(current);
-		if (mm)
-			up_write(&mm->mmap_sem);
 		mpol_put(new);
 		goto out;
 	}
@@ -837,9 +827,6 @@ static long do_set_mempolicy(unsigned short mode, unsigned short flags,
 	    nodes_weight(new->v.nodes))
 		current->il_next = first_node(new->v.nodes);
 	task_unlock(current);
-	if (mm)
-		up_write(&mm->mmap_sem);
-
 	mpol_put(old);
 	ret = 0;
 out:
-- 
1.5.5.1


