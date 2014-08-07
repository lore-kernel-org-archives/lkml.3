Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaHGTUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:20:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbaHGTUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:20:09 -0400
Date: Thu, 7 Aug 2014 21:17:46 +0200
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
Subject: [PATCH 1/5] fs/proc/task_mmu.c: kill the suboptimal and confusing
	m->version logic
Message-ID: <20140807191746.GA1733@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807191718.GA1315@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m_start() carefully documents, checks, and sets "m->version = -1" if
we are going to return NULL. The only problem is that we will be never
called again if m_start() returns NULL, so this is simply pointless
and misleading.

Otoh, ->show() methods m->version = 0 if vma == tail_vma and this is
just wrong, we want -1 in this case. And in fact we also want -1 if
->vm_next == NULL and ->tail_vma == NULL.

And it is not used consistently, the "scan vmas" loop in m_start()
should update last_addr too.

Finally, imo the whole "last_addr" logic in m_start() looks horrible.
find_vma(last_addr) is called unconditionally even if we are not going
to use the result. But the main problem is that this code participates
in tail_vma-or-NULL mess, and this looks simply unfixable.

Remove this optimization. We will add it back after some cleanups.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/task_mmu.c |   35 +----------------------------------
 1 files changed, 1 insertions(+), 34 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 5f7fb45..d69f31c 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -140,20 +140,10 @@ static void vma_stop(struct proc_maps_private *priv)
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
-	unsigned long last_addr = m->version;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma, *tail_vma = NULL;
 	loff_t l = *pos;
 
-	/*
-	 * We remember last_addr rather than next_addr to hit with
-	 * vmacache most of the time. We have zero last_addr at
-	 * the beginning and also after lseek. We will have -1 last_addr
-	 * after the end of the vmas.
-	 */
-	if (last_addr == -1UL)
-		return NULL;
-
 	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
@@ -166,12 +156,6 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	tail_vma = get_gate_vma(mm);
 	priv->tail_vma = tail_vma;
 	hold_task_mempolicy(priv);
-	/* Start with last addr hint */
-	vma = find_vma(mm, last_addr);
-	if (last_addr && vma) {
-		vma = vma->vm_next;
-		goto out;
-	}
 
 	/*
 	 * Check the vma index is within the range and do
@@ -192,8 +176,6 @@ out:
 	if (vma)
 		return vma;
 
-	/* End of vmas has been reached */
-	m->version = (tail_vma != NULL)? 0: -1UL;
 	if (tail_vma)
 		return tail_vma;
 
@@ -365,14 +347,7 @@ done:
 
 static int show_map(struct seq_file *m, void *v, int is_pid)
 {
-	struct vm_area_struct *vma = v;
-	struct proc_maps_private *priv = m->private;
-
-	show_map_vma(m, vma, is_pid);
-
-	if (m->count < m->size)  /* vma is copied successfully */
-		m->version = (vma != priv->tail_vma)
-			? vma->vm_start : 0;
+	show_map_vma(m, v, is_pid);
 	return 0;
 }
 
@@ -598,7 +573,6 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
-	struct proc_maps_private *priv = m->private;
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
 	struct mm_walk smaps_walk = {
@@ -651,10 +625,6 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 				mss.nonlinear >> 10);
 
 	show_smap_vma_flags(m, vma);
-
-	if (m->count < m->size)  /* vma is copied successfully */
-		m->version = (vma != priv->tail_vma)
-			? vma->vm_start : 0;
 	return 0;
 }
 
@@ -1485,9 +1455,6 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 			seq_printf(m, " N%d=%lu", nid, md->node[nid]);
 out:
 	seq_putc(m, '\n');
-
-	if (m->count < m->size)
-		m->version = (vma != proc_priv->tail_vma) ? vma->vm_start : 0;
 	return 0;
 }
 
-- 
1.5.5.1

