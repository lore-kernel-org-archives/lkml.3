Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab3L0DSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 22:18:50 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:60543 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab3L0DSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 22:18:48 -0500
Date: Fri, 27 Dec 2013 12:18:45 +0900
From: Simon Horman <horms@verge.net.au>
To: Julian Anastasov <ja@ssi.bg>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH -v2] ipvs: Remove unused variable ret from
 sync_thread_master()
Message-ID: <20131227031845.GA3795@verge.net.au>
References: <1384266864-564-1-git-send-email-geert@linux-m68k.org>
 <alpine.LFD.2.03.1311130934390.1647@ssi.bg>
 <alpine.LFD.2.11.1312190919160.2940@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1312190919160.2940@ja.home.ssi.bg>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 09:23:51AM +0200, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Wed, 13 Nov 2013, Julian Anastasov wrote:
> 
> > On Tue, 12 Nov 2013, Geert Uytterhoeven wrote:
> > 
> > > net/netfilter/ipvs/ip_vs_sync.c: In function 'sync_thread_master':
> > > net/netfilter/ipvs/ip_vs_sync.c:1640:8: warning: unused variable 'ret' [-Wunused-variable]
> > > 
> > > Commit 35a2af94c7ce7130ca292c68b1d27fcfdb648f6b ("sched/wait: Make the
> > > __wait_event*() interface more friendly") changed how the interruption
> > > state is returned. However, sync_thread_master() ignores this state,
> > > now causing a compile warning.
> > > 
> > > According to Julian Anastasov <ja@ssi.bg>, this behavior is OK:
> > > 
> > >     "Yes, your patch looks ok to me. In the past we used ssleep() but IPVS
> > >      users were confused why IPVS threads increase the load average. So, we
> > >      switched to _interruptible calls and later the socket polling was
> > >      added."
> > > 
> > > Document this, as requested by Peter Zijlstra, to avoid precious developers
> > > disappearing in this pitfall in the future.
> > > 
> > > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > > ---
> > > v2: Document that sync_thread_master() ignores the interruption state,
> > > 
> > >  net/netfilter/ipvs/ip_vs_sync.c |    5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> > > index f63c2388f38d..db801263ee9f 100644
> > > --- a/net/netfilter/ipvs/ip_vs_sync.c
> > > +++ b/net/netfilter/ipvs/ip_vs_sync.c
> > > @@ -1637,7 +1637,10 @@ static int sync_thread_master(void *data)
> > >  			continue;
> > >  		}
> > >  		while (ip_vs_send_sync_msg(tinfo->sock, sb->mesg) < 0) {
> > > -			int ret = __wait_event_interruptible(*sk_sleep(sk),
> > > +			/* (Ab)use interruptible sleep to avoid increasing
> > > +			 * the load avg.
> > > +			 */
> > > +			__wait_event_interruptible(*sk_sleep(sk),
> > >  						   sock_writeable(sk) ||
> > >  						   kthread_should_stop());
> > >  			if (unlikely(kthread_should_stop()))
> > 
> > 	Fabio Estevam posted similar change too early but
> > we are better with such comment.
> > 
> > Acked-by: Julian Anastasov <ja@ssi.bg>
> > 
> > 	Also, the TASK_UNINTERRUPTIBLE | TASK_IDLE idea looks good
> > to me. If such change is planned may be the above patch
> > better not to go via the ipvs-next tree to avoid conflicts?
> > As we don't have any changes in this area let us know if
> > someone takes the above patch for another tree.
> 
> 	Simon, lets apply this patch to ipvs-next tree...

Thanks, done.
