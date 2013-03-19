Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3CSCim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:38:42 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:43767 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab3CSCik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:38:40 -0400
Message-ID: <1363660703.4993.3.camel@nexus>
Subject: [RFC] iowait/idle time accounting hiccups in NOHZ kernels
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 19 Mar 2013 11:38:23 +0900
References: <201301152014.AAD52192.FOOHQVtSFMFOJL@I-love.SAKURA.ne.jp>
	 <alpine.LFD.2.02.1301151313170.7475@ionos>
	 <201301180857.r0I8vK7c052791@www262.sakura.ne.jp>
In-Reply-To: <201301180857.r0I8vK7c052791@www262.sakura.ne.jp>
Organization: NTT Open Source Software Center
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Moving discussion to LKML)

Hi Thomas, Frederic,

Tetsuo Handa reported that the iowait time obtained through /proc/stat
is not monotonic.

The reason is that get_cpu_iowait_time_us() is inherently racy;
->idle_entrytime and ->iowait_sleeptime can be updated from another
CPU (via update_ts_time_stats()) during the delta and iowait time
calculations and the "now" values used by the racing CPUs are not
necessarily ordered.

The patch below fixes the problem that the delta becomes negative, but
this is not enough. Fixing the whole problem properly may require some
major plumbing so I would like to know your take on this before going
ahead.

Thanks,
Fernando

---

diff -urNp linux-3.9-rc3-orig/kernel/time/tick-sched.c linux-3.9-rc3/kernel/time/tick-sched.c
--- linux-3.9-rc3-orig/kernel/time/tick-sched.c	2013-03-18 16:58:36.076335000 +0900
+++ linux-3.9-rc3/kernel/time/tick-sched.c	2013-03-19 10:57:32.729247000 +0900
@@ -292,18 +292,20 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	ktime_t now, iowait;
+	ktime_t now, iowait, idle_entrytime;
 
 	if (!tick_nohz_enabled)
 		return -1;
 
+	idle_entrytime = ts->idle_entrytime;
+	smp_mb();
 	now = ktime_get();
 	if (last_update_time) {
 		update_ts_time_stats(cpu, ts, now, last_update_time);
 		iowait = ts->iowait_sleeptime;
 	} else {
 		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
-			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+			ktime_t delta = ktime_sub(now, idle_entrytime);
 
 			iowait = ktime_add(ts->iowait_sleeptime, delta);
 		} else {


On Fri, 2013-01-18 at 17:57 +0900, Tetsuo Handa wrote:
> I forwarded this problem to Fernando.
> I think he will start discussion on how to fix this problem at the LKML.
>
> On Tue, 15 Jan 2013 13:14:38 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
>
> > On Tue, 15 Jan 2013, Tetsuo Handa wrote:
> >
> > > Hello.
> > >
> > > I can observe that get_cpu_iowait_time_us(cpu, NULL) sometime decreases,
> > > resulting in iowait field of cpu lines in /proc/stat decreasing.
> > > Is this a feature of tick_nohz_enabled == 1 ?
> >
> > It definitely not a feature. Is that simple to observe or does it
> > require any special setup/workload ?
> >
> > Thanks,
> >
> > 	Thomas


