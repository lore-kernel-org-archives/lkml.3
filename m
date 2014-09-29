Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaI2QyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:54:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:39028 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaI2QyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:54:24 -0400
Date: Mon, 29 Sep 2014 18:54:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, mingo@kernel.org,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Use RCU read lock on all calls to dl_bw_of()
Message-ID: <20140929165418.GQ5430@worktop>
References: <1412003970-25277-1-git-send-email-sasha.levin@oracle.com>
 <1412009027.20287.17.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412009027.20287.17.camel@tkhai>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 08:43:47PM +0400, Kirill Tkhai wrote:
> Thanks for your report. It looks like your fix is not enough, because
> we check for rcu_read_lock_sched_held() in dl_bw_of(). It still warns
> even if rcu_read_lock() is held.
> 
> I used rcu_read_lock_sched_held() because we free root_domain using
> call_rcu_sched(). So, it's necessary to held rcu_read_lock_sched(),
> and my initial commit has this problem too.
> 
> It looks like we should fix it in a way like this:
> 
> [PATCH]sched: Use dl_bw_of() under rcu_read_lock_sched()
> 
> rq->rd is freed using call_rcu_sched(), and it's accessed with preemption
> disabled in the most cases.
> 
> So in other places we should use rcu_read_lock_sched() to access it to fit
> the scheme:
> 
> rcu_read_lock_sched() or preempt_disable() <==> call_rcu_sched().

Hmm, sad that. I cannot remember why that is rcu_sched, I suspect
because we rely on it someplace but I cannot remember where.

We could of course do a double take on that and use call_rcu after
call_rcu_sched(), such that either or both are sufficient.

I would very much prefer not to add extra preempt_disable()s if
possible.
