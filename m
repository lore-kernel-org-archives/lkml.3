Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab3E1Dzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52600 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758865Ab3E1DyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:15 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mike Galbraith" <bitbucket@online.de>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Prarit Bhargava" <prarit@redhat.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.591253924@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [26/94] tick: Cleanup NOHZ per cpu data on cpu down
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/time/tick-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -833,7 +833,7 @@ void tick_cancel_sched_timer(int cpu)
 		hrtimer_cancel(&ts->sched_timer);
 # endif
 
-	ts->nohz_mode = NOHZ_MODE_INACTIVE;
+	memset(ts, 0, sizeof(*ts));
 }
 #endif
 

