Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaEIF2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 01:28:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaEIF2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 01:28:15 -0400
Date: Fri, 9 May 2014 01:27:43 -0400
From: Rik van Riel <riel@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com, mingo@kernel.org,
        george.mccollister@gmail.com, ktkhai@parallels.com
Subject: [PATCH] sched: wake up task on prev_cpu if not in SD_WAKE_AFFINE
 domain with cpu
Message-ID: <20140509012743.67d4006d@annuminas.surriel.com>
In-Reply-To: <536C3B69.1000208@redhat.com>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
	<1399011219.5233.55.camel@marge.simpson.net>
	<53633B81.1080403@redhat.com>
	<1399016273.5233.94.camel@marge.simpson.net>
	<536379D0.8070306@redhat.com>
	<1399030032.5233.142.camel@marge.simpson.net>
	<5363B793.9010208@redhat.com>
	<20140506115448.GH11096@twins.programming.kicks-ass.net>
	<536943C9.4030502@redhat.com>
	<20140506203916.GQ17778@laptop.programming.kicks-ass.net>
	<536C3B69.1000208@redhat.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2014 22:20:25 -0400
Rik van Riel <riel@redhat.com> wrote:

> Looks like SD_BALANCE_WAKE is not gotten from the sd flags at
> all, but passed into select_task_rq by try_to_wake_up, as a
> hard coded sd_flags argument.

> Should we do that, if SD_WAKE_BALANCE is not set for any sched domain?

I answered my own question. The sd_flag SD_WAKE_BALANCE simply means
"this is a wakeup of a previously existing task, please place it
properly".

However, it appears that the current code will fall back to the large
loop with select_idlest_group and friends, if prev_cpu and cpu are not
part of the same SD_WAKE_AFFINE sched domain. That is a bug...

---8<---

Subject: sched: wake up task on prev_cpu if not in SD_WAKE_AFFINE domain with cpu

If prev_cpu and cpu are not part of the same SD_WAKE_AFFINE domain,
the current code will fall back to the select_idlest_group CPU selection
mechanism, instead of trying to wake up the task on a CPU near its
previous CPU.

Fix that by always calling select_idle_sibling when doing an SD_BALANCE_WAKE
wakeup.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7570dd9..5d33fb1b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4452,7 +4452,9 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 	if (affine_sd) {
 		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
 			prev_cpu = cpu;
+	}
 
+	if (sd_flag & SD_BALANCE_WAKE) {
 		new_cpu = select_idle_sibling(p, prev_cpu);
 		goto unlock;
 	}

