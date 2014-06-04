Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaFDXVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:21:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaFDXV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Leon Ma <xindong.ma@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.14 051/228] hrtimer: Prevent remote enqueue of leftmost timers
Date: Wed,  4 Jun 2014 16:21:20 -0700
Message-Id: <20140604232349.712903879@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/hrtimer.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -247,6 +247,11 @@ again:
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


