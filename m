Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaHETtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:49:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbaHETtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:49:04 -0400
Date: Tue, 5 Aug 2014 21:46:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/7] fs/proc/task_mmu.c: don't use task->mm in m_start()
	and show_*map()
Message-ID: <20140805194644.GA30711@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194627.GA30693@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_gate_vma(priv->task->mm) looks ugly and wrong, task->mm can be
NULL or it can changed by exec right after mm_access().

And in theory this race is not harmless, the task can exec and then
later exit and free the new mm_struct. In this case get_task_mm(oldmm)
can't help, get_gate_vma(task->mm) can read the freed/unmapped memory.

I think that priv->task should simply die and hold_task_mempolicy()
logic can be simplified. tail_vma logic asks for cleanups too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/task_mmu.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index cfa63ee..8a5271e 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -170,7 +170,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 		return mm;
 	down_read(&mm->mmap_sem);
 
-	tail_vma = get_gate_vma(priv->task->mm);
+	tail_vma = get_gate_vma(mm);
 	priv->tail_vma = tail_vma;
 	hold_task_mempolicy(priv);
 	/* Start with last addr hint */
@@ -351,12 +351,11 @@ static int show_map(struct seq_file *m, void *v, int is_pid)
 {
 	struct vm_area_struct *vma = v;
 	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
 
 	show_map_vma(m, vma, is_pid);
 
 	if (m->count < m->size)  /* vma is copied successfully */
-		m->version = (vma != get_gate_vma(task->mm))
+		m->version = (vma != priv->tail_vma)
 			? vma->vm_start : 0;
 	return 0;
 }
@@ -584,7 +583,6 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
 	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
 	struct mm_walk smaps_walk = {
@@ -639,7 +637,7 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 	show_smap_vma_flags(m, vma);
 
 	if (m->count < m->size)  /* vma is copied successfully */
-		m->version = (vma != get_gate_vma(task->mm))
+		m->version = (vma != priv->tail_vma)
 			? vma->vm_start : 0;
 	return 0;
 }
-- 
1.5.5.1

