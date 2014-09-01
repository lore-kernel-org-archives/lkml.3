Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaIAJcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:32:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:56056 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaIAJcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:32:02 -0400
Date: Mon, 1 Sep 2014 11:31:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process is
 runnable
Message-ID: <20140901093159.GB27892@worktop.ger.corp.intel.com>
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com>
 <1408608310-13579-2-git-send-email-jasowang@redhat.com>
 <1408683665.5648.69.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408683665.5648.69.camel@marge.simpson.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 07:01:05AM +0200, Mike Galbraith wrote:
> > +++ b/include/net/busy_poll.h
> > @@ -109,7 +109,8 @@ static inline bool sk_busy_loop(struct sock *sk, int nonblock)
> >  		cpu_relax();
> >  
> >  	} while (!nonblock && skb_queue_empty(&sk->sk_receive_queue) &&
> > -		 !need_resched() && !busy_loop_timeout(end_time));
> > +		 !need_resched() && !busy_loop_timeout(end_time) &&
> > +		 nr_running_this_cpu() < 2);
> >  

So as has been said by now; this is horrible.

We should not export nr_running like this ever. Your usage of < 2
implies this can be hit with nr_running == 0, and therefore you can also
hit it with nr_running == 1 where the one is not network related and you
get random delays.

Worse still, you have BH (and thereby preemption) disabled, you should
not _ever_ have undefined and indefinite waits like that.

You also destroy any hope of dropping into lower power states; even when
there's never going to be a packet ever again, also bad.

All in all, a complete trainwreck.

NAK.
