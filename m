Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab3BROTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 09:19:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32905 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3BROTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 09:19:02 -0500
Date: Mon, 18 Feb 2013 06:17:25 -0800
From: "tip-bot for Bu, Yitian" <tipbot@zytor.com>
Message-ID: <tip-dbda92d16f8655044e082930e4e9d244b87fde77@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, ybu@qti.qualcomm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ybu@qti.qualcomm.com, tglx@linutronix.de
In-Reply-To: <E807E903FE6CBE4D95E420FBFCC273B827413C@nasanexd01h.na.qualcomm.com>
References: <E807E903FE6CBE4D95E420FBFCC273B827413C@nasanexd01h.na.qualcomm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/printk] printk: Fix rq->
 lock vs logbuf_lock unlock lock inversion
Git-Commit-ID: dbda92d16f8655044e082930e4e9d244b87fde77
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Feb 2013 06:17:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dbda92d16f8655044e082930e4e9d244b87fde77
Gitweb:     http://git.kernel.org/tip/dbda92d16f8655044e082930e4e9d244b87fde77
Author:     Bu, Yitian <ybu@qti.qualcomm.com>
AuthorDate: Mon, 18 Feb 2013 12:53:37 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 18 Feb 2013 15:05:57 +0100

printk: Fix rq->lock vs logbuf_lock unlock lock inversion

commit 07354eb1a74d1 ("locking printk: Annotate logbuf_lock as raw")
reintroduced a lock inversion problem which was fixed in commit
0b5e1c5255 ("printk: Release console_sem after logbuf_lock"). This
happened probably when fixing up patch rejects.

Restore the ordering and unlock logbuf_lock before releasing
console_sem.

Signed-off-by: ybu <ybu@qti.qualcomm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/E807E903FE6CBE4D95E420FBFCC273B827413C@nasanexd01h.na.qualcomm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/printk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 267ce78..e698e80 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1358,9 +1358,9 @@ static int console_trylock_for_printk(unsigned int cpu)
 		}
 	}
 	logbuf_cpu = UINT_MAX;
+	raw_spin_unlock(&logbuf_lock);
 	if (wake)
 		up(&console_sem);
-	raw_spin_unlock(&logbuf_lock);
 	return retval;
 }
 
