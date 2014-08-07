Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaHGTUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:20:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253AbaHGTUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:20:13 -0400
Date: Thu, 7 Aug 2014 21:17:54 +0200
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
Subject: [PATCH 3/5] fs/proc/task_mmu.c: introduce m_next_vma() helper
Message-ID: <20140807191754.GA1747@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807191718.GA1315@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the tail_vma/vm_next calculation from m_next() into the new
trivial helper, m_next_vma().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/task_mmu.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1349d3d..2ba3b16 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -137,6 +137,14 @@ static void vma_stop(struct proc_maps_private *priv)
 	mmput(mm);
 }
 
+static struct vm_area_struct *
+m_next_vma(struct proc_maps_private *priv, struct vm_area_struct *vma)
+{
+	if (vma == priv->tail_vma)
+		return NULL;
+	return vma->vm_next ?: priv->tail_vma;
+}
+
 static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
@@ -172,13 +180,10 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
-	struct vm_area_struct *tail_vma = priv->tail_vma;
-	struct vm_area_struct *vma = v, *next = NULL;
+	struct vm_area_struct *next;
 
 	(*pos)++;
-	if (vma != tail_vma)
-		next = vma->vm_next ?: tail_vma;
-
+	next = m_next_vma(priv, v);
 	if (!next)
 		vma_stop(priv);
 	return next;
-- 
1.5.5.1

