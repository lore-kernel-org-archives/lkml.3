Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbaFSJIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 05:08:09 -0400
Received: from mx2.parallels.com ([199.115.105.18]:38455 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878AbaFSJID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 05:08:03 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <oleg@redhat.com>, <rientjes@google.com>, <cl@linux.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] fork: reset mm->pinned_vm
Date: Thu, 19 Jun 2014 13:07:47 +0400
Message-ID: <63d594c88850aa64729fceec769681f9d1d6fa68.1403168346.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <fa98629155872c1b97ba4dcd00d509a1e467c1c3.1403168346.git.vdavydov@parallels.com>
References: <fa98629155872c1b97ba4dcd00d509a1e467c1c3.1403168346.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm->pinned_vm counts pages of mm's address space that were permanently
pinned in memory by increasing their reference counter. The counter was
introduced by commit bc3e53f682d9 ("mm: distinguish between mlocked and
pinned pages"), while before it locked_vm had been used for such pages.

Obviously, we should reset the counter on fork if !CLONE_VM, just like
we do with locked_vm, but currently we don't. Let's fix it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 01f0d0c56cb9..938707e108db 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -534,6 +534,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 	atomic_long_set(&mm->nr_ptes, 0);
 	mm->map_count = 0;
 	mm->locked_vm = 0;
+	mm->pinned_vm = 0;
 	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
 	spin_lock_init(&mm->page_table_lock);
 	mm_init_cpumask(mm);
-- 
1.7.10.4

