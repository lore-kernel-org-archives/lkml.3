Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaFRNdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:33:35 -0400
Received: from mx2.parallels.com ([199.115.105.18]:42597 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaFRNde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:33:34 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <oleg@redhat.com>, <rientjes@google.com>, <cl@linux.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] fork: dup_mm: init vm stat counters under mmap_sem
Date: Wed, 18 Jun 2014 17:33:11 +0400
Message-ID: <1403098391-24546-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a forking process has a thread calling (un)mmap (silly but still),
the child process may have some of its mm's vm stats (total_vm and
friends) screwed up, because currently they are copied from oldmm w/o
holding any locks (see dup_mm).

This patch moves the stats initialization to dup_mmap to be called under
oldmm->mmap_sem, which eliminates any possibility of race.

Also, mm->pinned_vm is not reset on fork. Let's fix it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 kernel/fork.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index d2799d1fc952..eaacc75da4f7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -365,7 +365,12 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	 */
 	down_write_nested(&mm->mmap_sem, SINGLE_DEPTH_NESTING);
 
+	mm->total_vm = oldmm->total_vm;
 	mm->locked_vm = 0;
+	mm->pinned_vm = 0;
+	mm->shared_vm = oldmm->shared_vm;
+	mm->exec_vm = oldmm->exec_vm;
+	mm->stack_vm = oldmm->stack_vm;
 	mm->mmap = NULL;
 	mm->vmacache_seqnum = 0;
 	mm->map_count = 0;
-- 
1.7.10.4

