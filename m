Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbaD3Khv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:37:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48261 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213AbaD3Khs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:37:48 -0400
Date: Wed, 30 Apr 2014 03:37:31 -0700
From: tip-bot for Leon Ma <tipbot@zytor.com>
Message-ID: <tip-012a45e3f4af68e86d85cce060c6c2fed56498b2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, xindong.ma@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, xindong.ma@intel.com
In-Reply-To: <1398847391-5994-1-git-send-email-xindong.ma@intel.com>
References: <1398847391-5994-1-git-send-email-xindong.ma@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] hrtimer:
  Prevent remote enqueue of leftmost timers
Git-Commit-ID: 012a45e3f4af68e86d85cce060c6c2fed56498b2
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

Commit-ID:  012a45e3f4af68e86d85cce060c6c2fed56498b2
Gitweb:     http://git.kernel.org/tip/012a45e3f4af68e86d85cce060c6c2fed56498b2
Author:     Leon Ma <xindong.ma@intel.com>
AuthorDate: Wed, 30 Apr 2014 16:43:10 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 30 Apr 2014 12:34:51 +0200

hrtimer: Prevent remote enqueue of leftmost timers

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
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/hrtimer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e3724fd..6b715c0 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -234,6 +234,11 @@ again:
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
