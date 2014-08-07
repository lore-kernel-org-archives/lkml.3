Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbaHGTUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:20:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbaHGTUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:20:08 -0400
Date: Thu, 7 Aug 2014 21:17:50 +0200
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
Subject: [PATCH 2/5] fs/proc/task_mmu.c: simplify m_start() to make it
	readable
Message-ID: <20140807191750.GA1740@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807191718.GA1315@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that m->version is gone we can cleanup m_start(). In particular,

  - Remove the "unsigned long" typecast, m->index can't be negative
    or exceed ->map_count. But lets use "unsigned int pos" to make
    it clear that "pos < map_count" is safe.

  - Remove the unnecessary "vma != NULL" check in the main loop. It
    can't be NULL unless we have a vm bug.

  - This also means that "pos < map_count" case can simply return the
    valid vma and avoid "goto" and subsequent checks.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/task_mmu.c |   34 ++++++++++------------------------
 1 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d69f31c..1349d3d 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -137,12 +137,12 @@ static void vma_stop(struct proc_maps_private *priv)
 	mmput(mm);
 }
 
-static void *m_start(struct seq_file *m, loff_t *pos)
+static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
 	struct mm_struct *mm;
-	struct vm_area_struct *vma, *tail_vma = NULL;
-	loff_t l = *pos;
+	struct vm_area_struct *vma;
+	unsigned int pos = *ppos;
 
 	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
 	if (!priv->task)
@@ -151,33 +151,19 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	mm = priv->mm;
 	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
 		return NULL;
-	down_read(&mm->mmap_sem);
 
-	tail_vma = get_gate_vma(mm);
-	priv->tail_vma = tail_vma;
+	down_read(&mm->mmap_sem);
 	hold_task_mempolicy(priv);
+	priv->tail_vma = get_gate_vma(mm);
 
-	/*
-	 * Check the vma index is within the range and do
-	 * sequential scan until m_index.
-	 */
-	vma = NULL;
-	if ((unsigned long)l < mm->map_count) {
-		vma = mm->mmap;
-		while (l-- && vma)
+	if (pos < mm->map_count) {
+		for (vma = mm->mmap; pos; pos--)
 			vma = vma->vm_next;
-		goto out;
-	}
-
-	if (l != mm->map_count)
-		tail_vma = NULL; /* After gate vma */
-
-out:
-	if (vma)
 		return vma;
+	}
 
-	if (tail_vma)
-		return tail_vma;
+	if (pos == mm->map_count && priv->tail_vma)
+		return priv->tail_vma;
 
 	vma_stop(priv);
 	return NULL;
-- 
1.5.5.1

