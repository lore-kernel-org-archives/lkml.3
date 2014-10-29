Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaJ2TyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:54:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:58576 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbaJ2TyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:54:03 -0400
Date: Wed, 29 Oct 2014 20:53:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: e1000_netpoll(): disable_irq() triggers might_sleep() on
 linux-next
In-Reply-To: <1414611641.2420.54.camel@jtkirshe-mobl>
Message-ID: <alpine.DEB.2.11.1410292049350.5308@nanos>
References: <20141029155620.GA4886@kria>  <20141029180734.GQ12706@worktop.programming.kicks-ass.net>  <alpine.DEB.2.11.1410291918060.5308@nanos>  <20141029193603.GS12706@worktop.programming.kicks-ass.net> <1414611641.2420.54.camel@jtkirshe-mobl>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Jeff Kirsher wrote:
> On Wed, 2014-10-29 at 20:36 +0100, Peter Zijlstra wrote:
> > On Wed, Oct 29, 2014 at 07:33:00PM +0100, Thomas Gleixner wrote:
> > > Yuck. No. You are just papering over the problem.
> > > 
> > > What happens if you add 'threadirqs' to the kernel command line? Or if
> > > the interrupt line is shared with a real threaded interrupt user?
> > > 
> > > The proper solution is to have a poll_lock for e1000 which serializes
> > > the hardware interrupt against netpoll instead of using
> > > disable/enable_irq().
> > > 
> > > In fact that's less expensive than the disable/enable_irq() dance and
> > > the chance of contention is pretty low. If done right it will be a
> > > NOOP for the CONFIG_NET_POLL_CONTROLLER=n case.
> > > 
> > 
> > OK a little something like so then I suppose.. But I suspect most all
> > the network drivers will need this and maybe more, disable_irq() is a
> > popular little thing and we 'just' changed semantics on them.
> 
> Thomas- if you are fine with Peter's patch, I can get this under
> testing.

I'm fine with it except for the comment part of disable_irq(), but
that does not matter :)

One nitpick: Instead of having the lock unconditionally, I'd make it
depend on CONFIG_NET_POLL_CONTROLLER.

#ifdef CONFIG_NET_POLL_CONTROLLER
static inline void netpoll_lock(struct e1000_adapter *adapter)
{
	spin_lock(&adapter->irq_lock);
}

static inline void netpoll_unlock(struct e1000_adapter *adapter)
{
	spin_unlock(&adapter->irq_lock);
}
#else
static inline void netpoll_lock(struct e1000_adapter *adapter) { }
static inline void netpoll_unlock(struct e1000_adapter *adapter) { }
#endif

and use that instead of the unconditional spin[un]lock() invocations.

But that's up to you.

Thanks,

	tglx

