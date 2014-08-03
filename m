Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaHCVW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 17:22:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbaHCVW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 17:22:57 -0400
Date: Sun, 3 Aug 2014 23:20:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 5/5] fs/proc/task_mmu.c: change m_start() to rely on
	priv->mm and avoid mm_access()
Message-ID: <20140803212047.GF13330@redhat.com>
References: <1407010227-2269-1-git-send-email-kirill@shutemov.name> <20140803164452.GA14626@redhat.com> <20140803211843.GA13330@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140803211843.GA13330@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally we can change m_start() to avoid mm_access(), it can simply do
atomic_inc_not_zero(mm_users).

I'll try to verify, if this is the only change we need, then this one
line change doesn't deserve a separate patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/task_mmu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1cc623d..7ec8eb5 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -165,9 +165,9 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = mm_access(priv->task, PTRACE_MODE_READ);
-	if (!mm || IS_ERR(mm))
-		return mm;
+	mm = priv->mm;
+	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
+		return NULL;
 	down_read(&mm->mmap_sem);
 
 	tail_vma = get_gate_vma(mm);
-- 
1.5.5.1


