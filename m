Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750889Ab3GBEDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 00:03:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52784 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3GBEDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 00:03:52 -0400
Message-ID: <1372737803.7363.101.camel@marge.simpson.net>
Subject: Re: sched: context tracking demolishes pipe-test
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 02 Jul 2013 06:03:23 +0200
In-Reply-To: <1372670432.7678.114.camel@marge.simpson.net>
References: <1372579056.6607.16.camel@marge.simpson.net>
	 <20130630212940.GK6626@twins.programming.kicks-ass.net>
	 <1372658875.7678.17.camel@marge.simpson.net>
	 <20130701080638.GM6626@twins.programming.kicks-ass.net>
	 <1372669941.7678.113.camel@marge.simpson.net>
	 <1372670432.7678.114.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:G75ujiJRdDm1xOPUQMXc3NqmgeU8Cya2EIJauH4wsXW
 3th46RS9PknuRuu5onRmJTZkhoTSVQrJF13dF4/StwCqt+7pY9
 GJ1HybvaZkP2mdufOyFhAMnQk3hTSJk0ujdGfmZFnMHtUKL0ry
 3MUhSxCwkcS+NawunnblTd51/FWU8/0osgZ3hXzXZdnb4qZljs
 6oP4N3wtFlJDMTbRwAjt3xm6Q59dLcs60xK9bSeTdjj03LzwnK
 evOfCRh5UXNosoCKG1cnWucUFyC4BgTJVrzhwpW00MJuOLGuzW
 hrk3phDyBuGvPfj13ur1g02cHqKrGCUVZaZOO04cHlBW0cWcyM
 nBw6aYjfyX7YCuvzR7wSVXhQlEe5FMrS6p9gkjjIu+Lczq/w3V
 BWmkZV0QXYgTg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-01 at 11:20 +0200, Mike Galbraith wrote: 
> On Mon, 2013-07-01 at 11:12 +0200, Mike Galbraith wrote: 
> > On Mon, 2013-07-01 at 10:06 +0200, Peter Zijlstra wrote:
> > 
> > > So aside from the context tracking stuff, there's still a regression
> > > we might want to look at. That's still a ~10% drop against 2.6.32 for
> > > TCP_RR and few percents for tbench.
> > 
> > Yeah, known, and some of it's ours.
> 
> (btw tbench has a ~5% phase-of-moon jitter, you can pretty much
> disregard that one)

Hm.  Seems we don't own much of TCP_RR regression after all, somewhere
along the line while my silly-tester hat was moldering, we got some
cycles back.. in the light config case anyway.

With wakeup granularity set to zero, per pipe-test, scheduler is within
variance of .32, sometimes appearing a tad lighter, though usually a wee
bit heavier.  TCP_RR throughput delta does not correlate.

echo 0 > sched_wakeup_granularity_ns

pipe-test
2.6.32-regress    689.8 Khz            1.000
3.10.0-regress    682.5 Khz             .989

netperf TCP_RR
2.6.32-regress   117910.11 Trans/sec   1.000
3.10.0-regress    96955.12 Trans/sec    .822

It should be closer than this. 

     3.10.0-regress                                              2.6.32-regress
     3.85%  [kernel]        [k] tcp_ack                          4.04%  [kernel]        [k] tcp_sendmsg
     3.34%  [kernel]        [k] __schedule                       3.63%  [kernel]        [k] schedule
     2.93%  [kernel]        [k] tcp_sendmsg                      2.86%  [kernel]        [k] tcp_recvmsg
     2.54%  [kernel]        [k] tcp_rcv_established              2.83%  [kernel]        [k] tcp_ack
     2.26%  [kernel]        [k] tcp_transmit_skb                 2.19%  [kernel]        [k] system_call
     1.90%  [kernel]        [k] __netif_receive_skb_core         2.16%  [kernel]        [k] tcp_transmit_skb
     1.87%  [kernel]        [k] tcp_v4_rcv                       2.07%  libc-2.14.1.so  [.] __libc_recv
     1.84%  [kernel]        [k] tcp_write_xmit                   1.95%  [kernel]        [k] _spin_lock_bh
     1.70%  [kernel]        [k] __switch_to                      1.89%  libc-2.14.1.so  [.] __libc_send
     1.57%  [kernel]        [k] tcp_recvmsg                      1.77%  [kernel]        [k] tcp_rcv_established
     1.54%  [kernel]        [k] _raw_spin_lock_bh                1.70%  [kernel]        [k] netif_receive_skb
     1.52%  libc-2.14.1.so  [.] __libc_recv                      1.61%  [kernel]        [k] tcp_v4_rcv
     1.43%  [kernel]        [k] ip_rcv                           1.49%  [kernel]        [k] native_sched_clock
     1.35%  [kernel]        [k] local_bh_enable                  1.49%  [kernel]        [k] tcp_write_xmit
     1.33%  [kernel]        [k] _raw_spin_lock_irqsave           1.46%  [kernel]        [k] __switch_to
     1.26%  [kernel]        [k] ip_queue_xmit                    1.35%  [kernel]        [k] dev_queue_xmit
     1.16%  [kernel]        [k] __inet_lookup_established        1.29%  [kernel]        [k] __alloc_skb
     1.14%  [kernel]        [k] mod_timer                        1.27%  [kernel]        [k] skb_release_data
     1.13%  [kernel]        [k] process_backlog                  1.26%  netserver       [.] recv_tcp_rr
     1.13%  [kernel]        [k] read_tsc                         1.22%  [kernel]        [k] local_bh_enable
     1.13%  libc-2.14.1.so  [.] __libc_send                      1.18%  netperf         [.] send_tcp_rr
     1.12%  [kernel]        [k] system_call                      1.18%  [kernel]        [k] sched_clock_local
     1.07%  [kernel]        [k] tcp_event_data_recv              1.11%  [kernel]        [k] copy_user_generic_string
     1.04%  [kernel]        [k] ip_finish_output                 1.07%  [kernel]        [k] _spin_lock_irqsave

	-Mike

