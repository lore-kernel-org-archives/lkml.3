Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaBXIG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:06:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62777 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaBXIGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:06:55 -0500
Message-ID: <1393229211.5599.72.camel@marge.simpson.net>
Subject: [patch] sched: don't use nutty scale_rt_power() output
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 24 Feb 2014 09:06:51 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:yziio212MirSwyV+FCkyRIac7ayCL3w0jMWdqQvZq95
 Wicq+ivVICI2lucGWC+2WYTYHI7wP+TQkctYzrq+jfT7wrbqrB
 XT7rBHuYbpLQVyXGSVJlUaczXJyERpOrHMRzHTdPKX+wVZBzdG
 Tbdv44DtsU9dFY3ZOVX7jKL6W11pwwv9zQ4HMuElvrqKatDNAj
 J2Bj4ZWYN8AmiXLCYST4MsNMWonOL7e7k49Hmjbvi60J/eoLiD
 V6oqslcNpZxyzfA9HwnZP14Xz+THzTZ7KRP6RsZVq8ilvAHmzO
 MIwI61udMH/Qi/DtE/+JY6KJrDe4B6oaxzk+peqgoH9DPTrn/+
 ZZCg4OHI/PMReYq+PMk2ZcQ8w3f398gXhVsx9rMdQEfvghE0PM
 lL1jxySGOqjmg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I wonder if the below makes sense for mainline.

Background: I received some rather surprising news recently, a user of
old 2.6.32 kernels regularly receive log spam stemming from old 208 day
era warnings/protections inserted to prevent explosions from what was at
the time unknown bad juju happening (but don't report logs that look
like graffiti artist with an unlimited supply of spray paint gone mad).

The kernel that emitted the below does NOT contain..
9993bc63 sched/x86: Fix overflow in cyc2ns_offset
..though these folks use kexec fwtw.  They're one of those "You update
your kernel IFF world stops spinning" users, so will likely not be
terribly interested in me making their boxen say BUG(), and may even be
doing something naughty that induces it for all I know.

In any case, NOT using nutty output from the intentionally racy function
seems like a good plan no matter who or what makes weird unreproducible
(elsewhere) sh*t happen.  Wedging a bent 64 bit peg into 32 bit hole
could make boom, on top of doing funny things to balancing. 

sched: don't use nutty scale_rt_power() output

Boxen instructed to gripe if they see nutty cpu_power catch us
trashing it while seriously dazed and confused for an unknown reason.

Dec 18 05:50:56 kernel: [40091179.401405] update_group_power: cpu_power = 3148183471
Dec 18 05:51:01 /usr/sbin/cron[2279]: (root) CMD (/opt/blah/fix_cdr_bin.job >> /opt/blah/fix_cdr_bin.out 2>&1)
Dec 18 05:51:06 kernel: [40091189.455713] update_cpu_power: cpu_power = 19495027282; scale_rt = 19495027282
Dec 18 05:51:16 kernel: [22076800.665578] update_cpu_power: cpu_power = 2671067611; scale_rt = 18428729677871137243
Dec 18 05:51:16 kernel: [40091199.188773] update_cpu_power: cpu_power = 2675064501; scale_rt = 18428729677875134133

Don't do that, make a scary warning instead.

Signed-off-by: Mike Galbraith <bitbucket@online.de>
---
 kernel/sched/fair.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5305,7 +5305,7 @@ static unsigned long scale_rt_power(int
 static void update_cpu_power(struct sched_domain *sd, int cpu)
 {
 	unsigned long weight = sd->span_weight;
-	unsigned long power = SCHED_POWER_SCALE;
+	unsigned long power = SCHED_POWER_SCALE, rt_power;
 	struct sched_group *sdg = sd->groups;
 
 	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
@@ -5326,8 +5326,14 @@ static void update_cpu_power(struct sche
 
 	power >>= SCHED_POWER_SHIFT;
 
-	power *= scale_rt_power(cpu);
-	power >>= SCHED_POWER_SHIFT;
+	rt_power = scale_rt_power(cpu);
+	if (unlikely(rt_power > SCHED_POWER_SCALE)) {
+		 printk_once(KERN_WARNING "CPU%d Timewarp? rt_power: %lx clock: %Lx rt_avg: %Lx\n",
+			     cpu, rt_power, cpu_rq(cpu)->clock, cpu_rq(cpu)->rt_avg);
+	} else {
+		power *= rt_power;
+		power >>= SCHED_POWER_SHIFT;
+	}
 
 	if (!power)
 		power = 1;


