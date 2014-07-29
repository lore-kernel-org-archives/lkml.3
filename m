Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaG2P0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:26:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59377 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbaG2P0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:26:38 -0400
Date: Tue, 29 Jul 2014 17:26:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, vincent.guittot@linaro.org,
        mikey@neuling.org, mingo@kernel.org, jhladky@redhat.com,
        ktkhai@parallels.com, tim.c.chen@linux.intel.com,
        nicolas.pitre@linaro.org
Subject: Re: [PATCH 1/2] sched: fix and clean up calculate_imbalance
Message-ID: <20140729152631.GW12054@laptop.lan>
References: <1406571388-3227-1-git-send-email-riel@redhat.com>
 <1406571388-3227-2-git-send-email-riel@redhat.com>
 <20140729144952.GG3935@laptop>
 <20140729145308.GV12054@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729145308.GV12054@laptop.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 04:53:08PM +0200, Peter Zijlstra wrote:
> Ah, wait, I think I see why you want that gone. I was only expecting a
> correction fix wrt changing pick_busiest(), not also behaviour changes.

---
Subject: sched,fair: Make calculate_imbalance() independent
From: Peter Zijlstra <peterz@infradead.org>
Date: Tue Jul 29 17:00:21 CEST 2014

Rik noticed that calculate_imbalance() relies on
update_sd_pick_busiest() to guarantee that busiest->sum_nr_running >
busiest->group_capacity_factor.

Break this implicit assumption (with the intent of not providing it
anymore) by having calculat_imbalance() verify it and not rely on
others.

Reported-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6248,7 +6248,7 @@ static inline void calculate_imbalance(s
 		return fix_small_imbalance(env, sds);
 	}
 
-	if (!busiest->group_imb) {
+	if (busiest->sum_nr_running > busiest->group_capacity_factor) {
 		/*
 		 * Don't want to pull so many tasks that a group would go idle.
 		 * Except of course for the group_imb case, since then we might
