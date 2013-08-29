Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab3H2UpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:45:12 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:53569 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab3H2UpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:45:10 -0400
Date: Thu, 29 Aug 2013 22:45:09 +0200
From: Andreas Mohr <andi@lisas.de>
To: Tejun Heo <tj@kernel.org>
Cc: Jamie Liu <jamieliu@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: defer to waiting stop_machine
Message-ID: <20130829204509.GA7995@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20130828211312.GB18971@mtj.dyndns.org>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Isn't the problem that the kworker wouldn't yield to the higher
> priority stopper task while a work item keeps requeueing itself if
> preemption is not enabled?  If so, isn't the correct solution just
> adding cond_resched() in the work item processing loop?  The analysis
> and solution seem to have gone a bit stray....

While I did not quite follow the very fine and detailed analysis,
I had the same feeling about it.

The previous solution seemed less preferable e.g. for two reasons,
from a modularity/dependency POV:
- required a very specific (code smell?) stop_machine handling dependency
  in work queue code (machine stop handling arguably definitely
  is a corner case, and thereby supposed to remain just that!)
- new stop_machine_pending() helper is pretty bloated,
  and called in a semi-hotpath to boot (since it's using && operators
  rather than ||, seems like it would be called pretty much every time)

Preemption checks being expected to be much more general and widespread
thus seems like a much better fit.


Or, to put it another way, could it be that that extra very specific
stop_machine check was simply added since due to missing preemption checks
we were busy-handling there and thus not getting back to standard handling areas
where some *usual*, *hotpath/mainstream* stop_machine checks would have been made?
If so, perhaps there actually are some other cases of wasteful stop_machine check
code sites in the kernel where instead we could simply have a much cheaper
reschedule done, thereby go back to hitting one central (and thus cache-hot)
code site with stop_machine check etc.?


Afraid of having stated the glaringly obvious ;),

Andreas Mohr
