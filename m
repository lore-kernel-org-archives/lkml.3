Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab3APMu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:50:58 -0500
Received: from mail.openrapids.net ([64.15.138.104]:57947 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751474Ab3APMu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:50:57 -0500
Date: Wed, 16 Jan 2013 07:50:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: rp@svcs.cs.pdx.edu, linux-kernel@vger.kernel.org,
        lttng-dev@lists.lttng.org, stern@rowland.harvard.edu,
        khlebnikov@openvz.org, shemminger@vyatta.com
Subject: Re: [lttng-dev] [PATCH] Add ACCESS_ONCE() to avoid compiler
	splitting assignments
Message-ID: <20130116125054.GA9734@Krystal>
References: <20130115181936.GA30319@linux.vnet.ibm.com> <20130115235642.GA31367@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130115235642.GA31367@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > As noted by Konstantin Khlebnikov, gcc can split assignment of
> > constants to long variables (https://lkml.org/lkml/2013/1/15/141),
> > though assignment of NULL (0) is OK.  Assuming that a gcc bug is
> > fixed (http://gcc.gnu.org/bugzilla/attachment.cgi?id=29169&action=diff
> > has a patch), making the store be volatile keeps gcc from splitting.
> > 
> > This commit therefore applies ACCESS_ONCE() to CMM_STORE_SHARED(),
> > which is the underlying primitive used by rcu_assign_pointer().
> 
> Hi Paul,
> 
> I recognise that this is an issue in the Linux kernel, since a simple
> store is used and expected to be performed atomically when aligned.
> However, I think this does not affect liburcu, see below:

Side question: what gcc versions may issue non-atomic volatile stores ?
I think we should at least document those. Bug
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=55981 seems to target gcc
4.7.2, but I wonder when this issue first appeared on x86 and x86-64
(and if it affects other architectures as well).

Thanks,

Mathieu

> 
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/urcu/system.h b/urcu/system.h
> > index 2a45f22..7a1887e 100644
> > --- a/urcu/system.h
> > +++ b/urcu/system.h
> > @@ -49,7 +49,7 @@
> >   */
> >  #define CMM_STORE_SHARED(x, v)		\
> >  	({				\
> > -		__typeof__(x) _v = _CMM_STORE_SHARED(x, v);	\
> > +		__typeof__(x) CMM_ACCESS_ONCE(_v) = _CMM_STORE_SHARED(x, v);	\
> 
> Here, the macro "_CMM_STORE_SHARED(x, v)" is doing the actual store.
> It stores v into "x". So adding a CMM_ACCESS_ONCE(_v), as you propose
> here, is really only making sure the return value (usually unused),
> located on the stack, is accessed with a volatile access, which does not
> make much sense.
> 
> What really matters is the _CMM_STORE_SHARED() macro:
> 
> #define _CMM_STORE_SHARED(x, v) ({ CMM_ACCESS_ONCE(x) = (v); })
> 
> which already uses a volatile access for the store. So this seems to be
> a case where our preemptive use of volatile for stores in addition to
> loads made us bug-free for a gcc behavior unexpected at the time we
> implemented this macro. Just a touch of paranoia seems to be a good
> thing sometimes. ;-)
> 
> Thoughts ?
> 
> Thanks,
> 
> Mathieu
> 
> >  		cmm_smp_wmc();		\
> >  		_v;			\
> >  	})
> > 
> > 
> > _______________________________________________
> > lttng-dev mailing list
> > lttng-dev@lists.lttng.org
> > http://lists.lttng.org/cgi-bin/mailman/listinfo/lttng-dev
> 
> -- 
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
> 
> _______________________________________________
> lttng-dev mailing list
> lttng-dev@lists.lttng.org
> http://lists.lttng.org/cgi-bin/mailman/listinfo/lttng-dev

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
