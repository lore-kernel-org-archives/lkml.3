Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbaFJTtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:49:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35112 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaFJTt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:49:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Leon Ma <xindong.ma@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 119/160] hrtimer: Prevent remote enqueue of leftmost timers
Date: Tue, 10 Jun 2014 12:45:59 -0700
Message-Id: <1402429600-20477-120-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Ma <xindong.ma@intel.com>

commit 012a45e3f4af68e86d85cce060c6c2fed56498b2 upstream.

If a cpu is idle and starts an hrtimer which is not pinned on that
same cpu, the nohz code might target the timer to a different cpu.

In the case that we switch the cpu base of the timer we already have a
sanity check in place, which determines whether the timer is earlier
than the current leftmost timer on the target cpu. In that case we
enqueue the timer on the current cpu because we cannot reprogram the
clock event device on the target.

If the timers base is already the target CPU we do not have this
sanity check in place so we enqueue the timer as the leftmost timer in
the target cpus rb tree, but we cannot reprogram the clock event
device on the target cpu. So the timer expires late and subsequently
prevents the reprogramming of the target cpu clock event device until
the previously programmed event fires or a timer with an earlier
expiry time gets enqueued on the target cpu itself.

Add the same target check as we have for the switch base case and
start the timer on the current cpu if it would become the leftmost
timer on the target.

[ tglx: Rewrote subject and changelog ]

Signed-off-by: Leon Ma <xindong.ma@intel.com>
Link: http://lkml.kernel.org/r/1398847391-5994-1-git-send-email-xindong.ma@intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/hrtimer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0d6df7b..6de65d8 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -246,6 +246,11 @@ again:
 			goto again;
 		}
 		timer->base = new_base;
+	} else {
+		if (cpu != this_cpu && hrtimer_check_target(timer, new_base)) {
+			cpu = this_cpu;
+			goto again;
+		}
 	}
 	return new_base;
 }
-- 
1.9.1

