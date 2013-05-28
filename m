Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab3E1VYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:24:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59659 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969Ab3E1VYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:24:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Galbraith <bitbucket@online.de>, Thomas Gleixner <tglx@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 37/78] tick: Cleanup NOHZ per cpu data on cpu down
Date: Tue, 28 May 2013 14:19:46 -0700
Message-Id: <1369776027-17859-38-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/time/tick-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e78feff..8853dab 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -903,7 +903,7 @@ void tick_cancel_sched_timer(int cpu)
 		hrtimer_cancel(&ts->sched_timer);
 # endif
 
-	ts->nohz_mode = NOHZ_MODE_INACTIVE;
+	memset(ts, 0, sizeof(*ts));
 }
 #endif
 
-- 
1.8.1.2

