Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaFGBcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:32:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36120 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Leon Ma" <xindong.ma@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.108159880@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 40/92] hrtimer: Prevent remote enqueue of leftmost timers
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/hrtimer.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -232,6 +232,11 @@ again:
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

