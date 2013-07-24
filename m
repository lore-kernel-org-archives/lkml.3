Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3GXOT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:19:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45865 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355Ab3GXOGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Laszlo Ersek" <lersek@redhat.com>,
        "John Haxby" <john.haxby@oracle.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.78180375@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [52/85] xen/time: remove blocked time accounting from xen "clockchip"
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Laszlo Ersek <lersek@redhat.com>

commit 0b0c002c340e78173789f8afaa508070d838cf3d upstream.

... because the "clock_event_device framework" already accounts for idle
time through the "event_handler" function pointer in
xen_timer_interrupt().

The patch is intended as the completion of [1]. It should fix the double
idle times seen in PV guests' /proc/stat [2]. It should be orthogonal to
stolen time accounting (the removed code seems to be isolated).

The approach may be completely misguided.

[1] https://lkml.org/lkml/2011/10/6/10
[2] http://lists.xensource.com/archives/html/xen-devel/2010-08/msg01068.html

John took the time to retest this patch on top of v3.10 and reported:
"idle time is correctly incremented for pv and hvm for the normal
case, nohz=off and nohz=idle." so lets put this patch in.

Signed-off-by: Laszlo Ersek <lersek@redhat.com>
Signed-off-by: John Haxby <john.haxby@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/xen/time.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -36,9 +36,8 @@ static DEFINE_PER_CPU(struct vcpu_runsta
 /* snapshots of runstate info */
 static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate_snapshot);
 
-/* unused ns of stolen and blocked time */
+/* unused ns of stolen time */
 static DEFINE_PER_CPU(u64, xen_residual_stolen);
-static DEFINE_PER_CPU(u64, xen_residual_blocked);
 
 /* return an consistent snapshot of 64-bit time/counter value */
 static u64 get64(const u64 *p)
@@ -115,7 +114,7 @@ static void do_stolen_accounting(void)
 {
 	struct vcpu_runstate_info state;
 	struct vcpu_runstate_info *snap;
-	s64 blocked, runnable, offline, stolen;
+	s64 runnable, offline, stolen;
 	cputime_t ticks;
 
 	get_runstate_snapshot(&state);
@@ -125,7 +124,6 @@ static void do_stolen_accounting(void)
 	snap = &__get_cpu_var(xen_runstate_snapshot);
 
 	/* work out how much time the VCPU has not been runn*ing*  */
-	blocked = state.time[RUNSTATE_blocked] - snap->time[RUNSTATE_blocked];
 	runnable = state.time[RUNSTATE_runnable] - snap->time[RUNSTATE_runnable];
 	offline = state.time[RUNSTATE_offline] - snap->time[RUNSTATE_offline];
 
@@ -141,17 +139,6 @@ static void do_stolen_accounting(void)
 	ticks = iter_div_u64_rem(stolen, NS_PER_TICK, &stolen);
 	__this_cpu_write(xen_residual_stolen, stolen);
 	account_steal_ticks(ticks);
-
-	/* Add the appropriate number of ticks of blocked time,
-	   including any left-overs from last time. */
-	blocked += __this_cpu_read(xen_residual_blocked);
-
-	if (blocked < 0)
-		blocked = 0;
-
-	ticks = iter_div_u64_rem(blocked, NS_PER_TICK, &blocked);
-	__this_cpu_write(xen_residual_blocked, blocked);
-	account_idle_ticks(ticks);
 }
 
 /* Get the TSC speed from Xen */

