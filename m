Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965015Ab3GQXLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:11:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56672 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964982Ab3GQWzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: ybu <ybu@qti.qualcomm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 092/145] printk: Fix rq->lock vs logbuf_lock unlock lock inversion
Date: Wed, 17 Jul 2013 15:47:04 -0700
Message-Id: <1374101277-7915-93-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Bu, Yitian" <ybu@qti.qualcomm.com>

commit dbda92d16f8655044e082930e4e9d244b87fde77 upstream.

commit 07354eb1a74d1 ("locking printk: Annotate logbuf_lock as raw")
reintroduced a lock inversion problem which was fixed in commit
0b5e1c5255 ("printk: Release console_sem after logbuf_lock"). This
happened probably when fixing up patch rejects.

Restore the ordering and unlock logbuf_lock before releasing
console_sem.

Signed-off-by: ybu <ybu@qti.qualcomm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/E807E903FE6CBE4D95E420FBFCC273B827413C@nasanexd01h.na.qualcomm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/printk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 0f0ac58..37425c3 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1367,9 +1367,9 @@ static int console_trylock_for_printk(unsigned int cpu)
 		}
 	}
 	logbuf_cpu = UINT_MAX;
+	raw_spin_unlock(&logbuf_lock);
 	if (wake)
 		up(&console_sem);
-	raw_spin_unlock(&logbuf_lock);
 	return retval;
 }
 
-- 
1.8.1.2

