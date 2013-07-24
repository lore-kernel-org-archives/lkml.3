Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3GXOa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:30:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45697 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153Ab3GXOGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:33 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Bu, Yitian" <ybu@qti.qualcomm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.515556061@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [02/85] printk: Fix rq->lock vs logbuf_lock unlock lock inversion
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/printk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -813,9 +813,9 @@ static int console_trylock_for_printk(un
 		}
 	}
 	printk_cpu = UINT_MAX;
+	raw_spin_unlock(&logbuf_lock);
 	if (wake)
 		up(&console_sem);
-	raw_spin_unlock(&logbuf_lock);
 	return retval;
 }
 static const char recursion_bug_msg [] =

