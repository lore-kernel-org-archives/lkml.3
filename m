Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab3HMQed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:34:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804Ab3HMQ0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:50 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=NOm-TwHeO3EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=r_yOwJgCNT0A:10 a=20KFwNOVAAAA:8 a=D19gQVrFAAAA:8 a=SEF7xSSsAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=zguwOKbY8RKokylTkfgA:9 a=wgL_T6Fd4DgA:10 a=jEp0ucaQiEUA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155835.297228482@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:58:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Laszlo Ersek <lersek@redhat.com>, John Haxby <john.haxby@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [74/88] xen/time: remove blocked time accounting from xen "clockchip"
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0074-xen-time-remove-blocked-time-accounting-from-xen-clo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Laszlo Ersek <lersek@redhat.com>

[ Upstream commit 0b0c002c340e78173789f8afaa508070d838cf3d ]

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

CC: stable@vger.kernel.org
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
Signed-off-by: John Haxby <john.haxby@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/xen/time.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 054cc01..d50a821 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -36,9 +36,8 @@ static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate);
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
-- 
1.7.10.4


