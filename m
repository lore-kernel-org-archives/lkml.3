Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbaITTcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 15:32:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:47075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455AbaITTcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 15:32:20 -0400
Date: Sat, 20 Sep 2014 21:32:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Subject: Re: [PATCH 3/7] sched: Use dl_bw_of() under RCU read lock
Message-ID: <20140920193212.GY2832@worktop.localdomain>
References: <20140920165116.16299.1381.stgit@localhost>
 <20140920165128.16299.20888.stgit@localhost>
 <20140920185705.GU2832@worktop.localdomain>
 <541DD4B3.7080400@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541DD4B3.7080400@yandex.ru>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 11:25:39PM +0400, Kirill Tkhai wrote:
> On 20.09.2014 22:57, Peter Zijlstra wrote:
> > On Sat, Sep 20, 2014 at 08:51:28PM +0400, Kirill Tkhai wrote:
> >> From: Kirill Tkhai <ktkhai@parallels.com>
> >>
> >> dl_bw_of() dereferences rq->rd which has to have RCU read lock held.
> >> Probability of use-after-free and memory corruption aren't zero here.
> >>
> > 
> > Additionally we might want to add something like:
> > lockdep_assert_held_rcu() and put that in dl_bw_of() and other such
> > places.
> 
> Should we change (not now, in general) RCU-related pointers to use
> rcu_dereference() to have unlocked RCU warnings in dmesg? To catch
> a problems like that.
> 
> This may make code worse readable though.

Possibly, we should probably use rcu_assign_pointer() and
rcu_dereference() on rq->rd. Sometimes you can avoid that if you're
playing games with static objects, but I don't think that is true here.
