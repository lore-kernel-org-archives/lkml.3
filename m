Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaHETtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:49:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090AbaHETto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:49:44 -0400
Date: Tue, 5 Aug 2014 21:47:07 +0200
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
Subject: [PATCH v2 7/7] fs/proc/task_mmu.c: shift "priv->task = NULL" from
	m_start() to m_stop()
Message-ID: <20140805194707.GA30746@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194627.GA30693@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. There is no reason to reset ->tail_vma in m_start(), if we return
   IS_ERR_OR_NULL() it won't be used.

2. m_start() also clears priv->task to ensure that m_stop() won't use
   the stale pointer if we fail before get_task_struct(). But this is
   ugly and confusing, move this initialization in m_stop().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/task_mmu.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index c4c8825..5f7fb45 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -145,17 +145,12 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	struct vm_area_struct *vma, *tail_vma = NULL;
 	loff_t l = *pos;
 
-	/* Clear the per syscall fields in priv */
-	priv->task = NULL;
-	priv->tail_vma = NULL;
-
 	/*
 	 * We remember last_addr rather than next_addr to hit with
 	 * vmacache most of the time. We have zero last_addr at
 	 * the beginning and also after lseek. We will have -1 last_addr
 	 * after the end of the vmas.
 	 */
-
 	if (last_addr == -1UL)
 		return NULL;
 
@@ -227,8 +222,10 @@ static void m_stop(struct seq_file *m, void *v)
 
 	if (!IS_ERR_OR_NULL(v))
 		vma_stop(priv);
-	if (priv->task)
+	if (priv->task) {
 		put_task_struct(priv->task);
+		priv->task = NULL;
+	}
 }
 
 static int proc_maps_open(struct inode *inode, struct file *file,
-- 
1.5.5.1

