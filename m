Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaHGTU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:20:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312AbaHGTUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:20:17 -0400
Date: Thu, 7 Aug 2014 21:18:02 +0200
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
Subject: [PATCH 5/5] fs/proc/task_mmu.c: update m->version in the main loop
	in m_start()
Message-ID: <20140807191802.GA1757@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807191718.GA1315@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the main loop in m_start() to update m->version. Mostly for
consistency, but this can help to avoid the same loop if the very
1st ->show() fails due to seq_overflow().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/task_mmu.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1b897dc..4ec6b72 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -183,11 +183,14 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 
 	m->version = 0;
 	if (pos < mm->map_count) {
-		for (vma = mm->mmap; pos; pos--)
+		for (vma = mm->mmap; pos; pos--) {
+			m->version = vma->vm_start;
 			vma = vma->vm_next;
+		}
 		return vma;
 	}
 
+	/* we do not bother to update m->version in this case */
 	if (pos == mm->map_count && priv->tail_vma)
 		return priv->tail_vma;
 
-- 
1.5.5.1

