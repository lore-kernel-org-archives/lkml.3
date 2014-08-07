Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbaHGTUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:20:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325AbaHGTUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:20:18 -0400
Date: Thu, 7 Aug 2014 21:17:58 +0200
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
Subject: [PATCH 4/5] fs/proc/task_mmu.c: reintroduce m->version logic
Message-ID: <20140807191758.GA1750@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807191718.GA1315@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the "last_addr" optimization back. Like before, every ->show()
method checks !seq_overflow() and sets m->version = vma->vm_start.

However, it also checks that m_next_vma(vma) != NULL, otherwise it
sets m->version = -1 for the lockless "EOF" fast-path in m_start().

m_start() can simply do find_vma() + m_next_vma() if last_addr is
not zero, the code looks clear and simple and this case is clearly
separated from "scan vmas" path.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/task_mmu.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2ba3b16..1b897dc 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -145,13 +145,24 @@ m_next_vma(struct proc_maps_private *priv, struct vm_area_struct *vma)
 	return vma->vm_next ?: priv->tail_vma;
 }
 
+static void m_cache_vma(struct seq_file *m, struct vm_area_struct *vma)
+{
+	if (m->count < m->size)	/* vma is copied successfully */
+		m->version = m_next_vma(m->private, vma) ? vma->vm_start : -1UL;
+}
+
 static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
+	unsigned long last_addr = m->version;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	unsigned int pos = *ppos;
 
+	/* See m_cache_vma(). Zero at the start or after lseek. */
+	if (last_addr == -1UL)
+		return NULL;
+
 	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
@@ -164,6 +175,13 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 	hold_task_mempolicy(priv);
 	priv->tail_vma = get_gate_vma(mm);
 
+	if (last_addr) {
+		vma = find_vma(mm, last_addr);
+		if (vma && (vma = m_next_vma(priv, vma)))
+			return vma;
+	}
+
+	m->version = 0;
 	if (pos < mm->map_count) {
 		for (vma = mm->mmap; pos; pos--)
 			vma = vma->vm_next;
@@ -339,6 +357,7 @@ done:
 static int show_map(struct seq_file *m, void *v, int is_pid)
 {
 	show_map_vma(m, v, is_pid);
+	m_cache_vma(m, v);
 	return 0;
 }
 
@@ -616,6 +635,7 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 				mss.nonlinear >> 10);
 
 	show_smap_vma_flags(m, vma);
+	m_cache_vma(m, vma);
 	return 0;
 }
 
@@ -1446,6 +1466,7 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 			seq_printf(m, " N%d=%lu", nid, md->node[nid]);
 out:
 	seq_putc(m, '\n');
+	m_cache_vma(m, vma);
 	return 0;
 }
 
-- 
1.5.5.1

