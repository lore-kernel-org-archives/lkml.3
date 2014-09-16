Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaIPTOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:14:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:46897 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754468AbaIPTOR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:14:17 -0400
Date: Tue, 16 Sep 2014 15:14:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jan Kara <jack@suse.cz>, Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140916151415.4c646cbc@gandalf.local.home>
In-Reply-To: <20140916152046.GC32118@x4>
References: <20140914050905.GA296@x4>
	<20140914055450.GB296@x4>
	<CAMuHMdUmqvN3GZzfjjHc5W2Dxgx2b0gzVHFUR8P8yUs5iFt_tA@mail.gmail.com>
	<20140915163740.GA12408@x4>
	<20140916105547.GA1205@quack.suse.cz>
	<20140916144252.GB32118@x4>
	<20140916111331.14303381@gandalf.local.home>
	<20140916152046.GC32118@x4>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014 17:20:46 +0200
Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> On 2014.09.16 at 11:13 -0400, Steven Rostedt wrote
> I'll leave it to you. This is just a cosmetic issue, so there's no need
> to fix this immediately.
> 

Actually the fix is much simpler (I had to wait for the drugs to wear
off before I noticed this ;-):


>From 2a88421634bf7a5238b18d829c64f8fd59f12aab Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Tue, 16 Sep 2014 15:08:24 -0400
Subject: [PATCH] timer: Remove redundant log level from printk_deferred() call

printk_deferred() is only used in critical sections that is unsafe to
call printk() directly, and these prints are for warnings only. They
do not take a printk loglevel (KERN_*) in their formats. A KERN_WARNING
is assumed and applied by the call itself.

Cc: Jan Kara <jack@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org # 3.16+
Fixes: 504d58745c9c "timer: Fix lock inversion between hrtimer_bases.lock and scheduler locks"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/time/clockevents.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 9c94c19f1305..0a7516e59610 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -146,8 +146,7 @@ static int clockevents_increase_min_delta(struct clock_event_device *dev)
 {
 	/* Nothing to do if we already reached the limit */
 	if (dev->min_delta_ns >= MIN_DELTA_LIMIT) {
-		printk_deferred(KERN_WARNING
-				"CE: Reprogramming failure. Giving up\n");
+		printk_deferred("CE: Reprogramming failure. Giving up\n");
 		dev->next_event.tv64 = KTIME_MAX;
 		return -ETIME;
 	}
@@ -160,8 +159,7 @@ static int clockevents_increase_min_delta(struct clock_event_device *dev)
 	if (dev->min_delta_ns > MIN_DELTA_LIMIT)
 		dev->min_delta_ns = MIN_DELTA_LIMIT;
 
-	printk_deferred(KERN_WARNING
-			"CE: %s increased min_delta_ns to %llu nsec\n",
+	printk_deferred("CE: %s increased min_delta_ns to %llu nsec\n",
 			dev->name ? dev->name : "?",
 			(unsigned long long) dev->min_delta_ns);
 	return 0;
-- 
1.8.1.4

