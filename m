Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaHCVVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 17:21:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbaHCVVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 17:21:34 -0400
Date: Sun, 3 Aug 2014 23:19:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 1/5] fs/proc/task_mmu.c: don't use task->mm in m_start()
	and show_*map()
Message-ID: <20140803211912.GB13330@redhat.com>
References: <1407010227-2269-1-git-send-email-kirill@shutemov.name> <20140803164452.GA14626@redhat.com> <20140803211843.GA13330@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140803211843.GA13330@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_gate_vma(priv->task->mm) looks ugly and wrong, task->mm can be
already NULL.

I think that priv->task should simply die and hold_task_mempolicy()
logic can be simplified.

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


