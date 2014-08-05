Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaHETt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:49:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbaHETtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:49:24 -0400
Date: Tue, 5 Aug 2014 21:47:03 +0200
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
Subject: [PATCH v2 6/7] fs/proc/task_mmu.c: cleanup the "tail_vma" horror
	in m_next()
Message-ID: <20140805194703.GA30739@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194627.GA30693@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Kill the first "vma != NULL" check. Firstly this is not possible,
   m_next() won't be called if ->start() or the previous ->next()
   returns NULL.

   And if it was possible the 2nd "vma != tail_vma" check is buggy,
   we should not wrongly return ->tail_vma.

2. Make this function readable. The logic is very simple, we should
   return check "vma != tail" once and return "vm_next || tail_vma".

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/task_mmu.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index f1254b4..c4c8825 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -209,15 +209,13 @@ out:
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
-	struct vm_area_struct *vma = v;
 	struct vm_area_struct *tail_vma = priv->tail_vma;
-	struct vm_area_struct *next;
+	struct vm_area_struct *vma = v, *next = NULL;
 
 	(*pos)++;
-	if (vma && (vma != tail_vma) && vma->vm_next)
-		return vma->vm_next;
+	if (vma != tail_vma)
+		next = vma->vm_next ?: tail_vma;
 
-	next = (vma != tail_vma)? tail_vma: NULL;
 	if (!next)
 		vma_stop(priv);
 	return next;
-- 
1.5.5.1

