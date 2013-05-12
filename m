Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3ELK2W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 06:28:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53915 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab3ELK2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 06:28:20 -0400
Date: Sun, 12 May 2013 03:27:53 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-4b0c0f294f60abcdd20994a8341a95c8ac5eeb96@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bitbucket@online.de, tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bitbucket@online.de, tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <alpine.LFD.2.02.1305031451561.2886@ionos>
References: <alpine.LFD.2.02.1305031451561.2886@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] tick: Cleanup NOHZ per cpu data on cpu down
Git-Commit-ID: 4b0c0f294f60abcdd20994a8341a95c8ac5eeb96
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b0c0f294f60abcdd20994a8341a95c8ac5eeb96
Gitweb:     http://git.kernel.org/tip/4b0c0f294f60abcdd20994a8341a95c8ac5eeb96
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 3 May 2013 15:02:50 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 12 May 2013 12:20:09 +0200

tick: Cleanup NOHZ per cpu data on cpu down

Prarit reported a crash on CPU offline/online. The reason is that on
CPU down the NOHZ related per cpu data of the dead cpu is not cleaned
up. If at cpu online an interrupt happens before the per cpu tick
device is registered the irq_enter() check potentially sees stale data
and dereferences a NULL pointer.

Cleanup the data after the cpu is dead.

Reported-by: Prarit Bhargava <prarit@redhat.com>
Cc: stable@vger.kernel.org
Cc: Mike Galbraith <bitbucket@online.de>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1305031451561.2886@ionos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 225f8bf..0eed1db 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -904,7 +904,7 @@ void tick_cancel_sched_timer(int cpu)
 		hrtimer_cancel(&ts->sched_timer);
 # endif
 
-	ts->nohz_mode = NOHZ_MODE_INACTIVE;
+	memset(ts, 0, sizeof(*ts));
 }
 #endif
 
