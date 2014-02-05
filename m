Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaBEUyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:54:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:54886 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaBEUFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:48 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 083/213] tick: Cleanup NOHZ per cpu data on cpu down
Date: Wed, 5 Feb 2014 15:00:38 -0500
Message-ID: <1391630568-49251-84-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4b0c0f294f60abcdd20994a8341a95c8ac5eeb96 upstream.

Prarit reported a crash on CPU offline/online. The reason is that on
CPU down the NOHZ related per cpu data of the dead cpu is not cleaned
up. If at cpu online an interrupt happens before the per cpu tick
device is registered the irq_enter() check potentially sees stale data
and dereferences a NULL pointer.

Cleanup the data after the cpu is dead.

Reported-by: Prarit Bhargava <prarit@redhat.com>
Cc: Mike Galbraith <bitbucket@online.de>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1305031451561.2886@ionos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/time/tick-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f992762d7f51..25d34e1a7911 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -769,7 +769,7 @@ void tick_cancel_sched_timer(int cpu)
 		hrtimer_cancel(&ts->sched_timer);
 # endif
 
-	ts->nohz_mode = NOHZ_MODE_INACTIVE;
+	memset(ts, 0, sizeof(*ts));
 }
 #endif
 
-- 
1.8.5.2

