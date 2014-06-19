Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbaFSJI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 05:08:28 -0400
Received: from mx2.parallels.com ([199.115.105.18]:38472 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885AbaFSJIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 05:08:04 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <oleg@redhat.com>, <rientjes@google.com>, <cl@linux.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] fork: copy mm's vm usage counters under mmap_sem
Date: Thu, 19 Jun 2014 13:07:48 +0400
Message-ID: <8efb9247108e3b327a321853025a09774cdaf032.1403168346.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <fa98629155872c1b97ba4dcd00d509a1e467c1c3.1403168346.git.vdavydov@parallels.com>
References: <fa98629155872c1b97ba4dcd00d509a1e467c1c3.1403168346.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a forking process has a thread calling (un)mmap (silly but still),
the child process may have some of its mm's vm usage counters (total_vm
and friends) screwed up, because currently they are copied from oldmm
w/o holding any locks (memcpy in dup_mm).

This patch moves the counters initialization to dup_mmap() to be called
under oldmm->mmap_sem, which eliminates any possibility of race.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 kernel/fork.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 938707e108db..5002b1188554 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -365,6 +365,11 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	 */
 	down_write_nested(&mm->mmap_sem, SINGLE_DEPTH_NESTING);
 
+	mm->total_vm = oldmm->total_vm;
+	mm->shared_vm = oldmm->shared_vm;
+	mm->exec_vm = oldmm->exec_vm;
+	mm->stack_vm = oldmm->stack_vm;
+
 	rb_link = &mm->mm_rb.rb_node;
 	rb_parent = NULL;
 	pprev = &mm->mmap;
-- 
1.7.10.4

