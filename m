Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaHETtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:49:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbaHETtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:49:18 -0400
Date: Tue, 5 Aug 2014 21:46:59 +0200
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
Subject: [PATCH v2 5/7] fs/proc/task_mmu.c: simplify the vma_stop() logic
Message-ID: <20140805194659.GA30736@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194627.GA30693@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m_start() drops ->mmap_sem and does mmput() if it retuns vsyscall
vma. This is because in this case m_stop()->vma_stop() obviously
can't use gate_vma->vm_mm.

Now that we have proc_maps_private->mm we can simplify this logic:

  - Change m_start() to return with ->mmap_sem held unless it returns
    IS_ERR_OR_NULL().

  - Change vma_stop() to use priv->mm and avoid the ugly vma checks,
    this makes "vm_area_struct *vma" unnecessary.

  - This also allows m_start() to use vm_stop().

  - Cleanup m_next() to follow the new locking rule.

    Note: m_stop() looks very ugly, and this temporary uglifies it
    even more. Fixed by the next change.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/task_mmu.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 7ec8eb5..f1254b4 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -129,14 +129,12 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
 }
 #endif
 
-static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
+static void vma_stop(struct proc_maps_private *priv)
 {
-	if (vma && vma != priv->tail_vma) {
-		struct mm_struct *mm = vma->vm_mm;
-		release_task_mempolicy(priv);
-		up_read(&mm->mmap_sem);
-		mmput(mm);
-	}
+	struct mm_struct *mm = priv->mm;
+	release_task_mempolicy(priv);
+	up_read(&mm->mmap_sem);
+	mmput(mm);
 }
 
 static void *m_start(struct seq_file *m, loff_t *pos)
@@ -199,12 +197,13 @@ out:
 	if (vma)
 		return vma;
 
-	release_task_mempolicy(priv);
 	/* End of vmas has been reached */
 	m->version = (tail_vma != NULL)? 0: -1UL;
-	up_read(&mm->mmap_sem);
-	mmput(mm);
-	return tail_vma;
+	if (tail_vma)
+		return tail_vma;
+
+	vma_stop(priv);
+	return NULL;
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
@@ -212,21 +211,24 @@ static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 	struct proc_maps_private *priv = m->private;
 	struct vm_area_struct *vma = v;
 	struct vm_area_struct *tail_vma = priv->tail_vma;
+	struct vm_area_struct *next;
 
 	(*pos)++;
 	if (vma && (vma != tail_vma) && vma->vm_next)
 		return vma->vm_next;
-	vma_stop(priv, vma);
-	return (vma != tail_vma)? tail_vma: NULL;
+
+	next = (vma != tail_vma)? tail_vma: NULL;
+	if (!next)
+		vma_stop(priv);
+	return next;
 }
 
 static void m_stop(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
-	struct vm_area_struct *vma = v;
 
-	if (!IS_ERR(vma))
-		vma_stop(priv, vma);
+	if (!IS_ERR_OR_NULL(v))
+		vma_stop(priv);
 	if (priv->task)
 		put_task_struct(priv->task);
 }
-- 
1.5.5.1

