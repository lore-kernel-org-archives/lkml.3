Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760361Ab3BMUC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:02:29 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([178.132.17.103]:18653 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755936Ab3BMUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:02:28 -0500
X-Greylist: delayed 21223 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2013 15:02:28 EST
Date: Wed, 13 Feb 2013 21:02:26 +0100
From: Damien Wyart <damien.wyart@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] sched: fix env->src_cpu for active migration
Message-ID: <20130213200226.GA14465@brouette>
References: <1360675195-4017-1-git-send-email-vincent.guittot@linaro.org>
 <20130213061853.GA4043@brouette>
 <CAKfTPtDCPKeQpcS4mQc7Jp7+wK2EuvnCUqAzL7SOELVVL3jztw@mail.gmail.com>
 <20130213092154.GA4481@brouette>
 <CAKfTPtDprVAA0o6sTugYk8RiaUkGXUmSvd4RJbTEhNkKj7B-5A@mail.gmail.com>
 <20130213140843.GA21308@brouette>
 <CAKfTPtCuj4xZi2mBZP_Vz-zzySwBLKPn2aNkdqf6g8sVJoyS+A@mail.gmail.com>
 <CAKfTPtDrTyof40Lk7MzdqEon2dkN=RZNEvP5BQSJVKP-EYsCXw@mail.gmail.com>
 <20130213184706.GA23803@brouette>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <20130213184706.GA23803@brouette>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Bingo, that was the problem in my setup: as the patch was applied
> through a script with others, I had missed the error message about the
> conflict (I have also another conflict which can be safely ignored so
> the new one did not catch my eye)... So the patch was only
> half-applied, and the final code is broken.

> How did you solve the conflict (I am not a scheduler expert)? I can
> retry running the patched kernel with your resolution, to check if
> everything is ok.

After looking a bit more, the conflict resolution seemed straighforward,
so I gave it a go. The attached version booted fine, so the initial
problem was purely PEBCAK... Sorry for the noise!

-- 
Damien

--h31gzZEtNLTqOjlF
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="patch-sched.patch"

--- a/kernel/sched/fair.c	2013-02-06 20:49:17.447613049 +0100
+++ b/kernel/sched/fair.c	2013-02-13 20:52:37.409507417 +0100
@@ -5060,6 +5060,10 @@
 	ld_moved = 0;
 	lb_iterations = 1;
 	clock_updated = 0;
+
+	env.src_cpu   = busiest->cpu;
+	env.src_rq    = busiest;
+	
 	if (busiest->nr_running > 1) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
@@ -5068,8 +5072,6 @@
 		 * correctly treated as an imbalance.
 		 */
 		env.flags |= LBF_ALL_PINNED;
-		env.src_cpu   = busiest->cpu;
-		env.src_rq    = busiest;
 		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
 
 		update_h_load(env.src_cpu);

--h31gzZEtNLTqOjlF--
