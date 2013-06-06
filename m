Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3FFVkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:40:21 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50230 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab3FFVkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:40:17 -0400
Date: Thu, 6 Jun 2013 14:40:14 -0700
From: Tejun Heo <tj@kernel.org>
To: greearb@candelatech.com
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v3] Fix lockup related to stop_machine being stuck in
 __do_softirq.
Message-ID: <20130606214014.GK5045@htj.dyndns.org>
References: <1370554189-31432-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370554189-31432-1-git-send-email-greearb@candelatech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 02:29:49PM -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> The stop machine logic can lock up if all but one of
> the migration threads make it through the disable-irq
> step and the one remaining thread gets stuck in
> __do_softirq.  The reason __do_softirq can hang is
> that it has a bail-out based on jiffies timeout, but
> in the lockup case, jiffies itself is not incremented.
> 
> To work around this, re-add the max_restart counter in __do_irq
> and stop processing irqs after 10 restarts.
> 
> Thanks to Tejun Heo and Rusty Russell and others for
> helping me track this down.
> 
> This was introduced in 3.9 by commit:  c10d73671ad30f5469
> (softirq:  reduce latencies).
> 
> It may be worth looking into ath9k to see if it has issues with
> it's irq handler at a later date.
> 
> The hang stack traces look something like this:
...
> Signed-off-by: Ben Greear <greearb@candelatech.com>

 Acked-by: Tejun Heo <tj@kernel.org>

Linus, while this doesn't fix the root cause of the problem - softirq
runaway - I still think this is a worthwhile protection to have.  Ben
is in the process of finding out why the softirq runaway happens in
the first place.  We probably want to add Cc: stable@vger.kernel.org
tag.

Thanks.

-- 
tejun
