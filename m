Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3FGDIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 23:08:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3FGDIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 23:08:21 -0400
Date: Thu, 6 Jun 2013 20:08:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Liu ShuoX <shuox.liu@intel.com>,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        sedat.dilek@gmail.com, srivatsa.bhat@linux.vnet.ibm.com,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [PATCH] irq: add a new function irq_in_progress to check pending
 IRQ handlers
Message-ID: <20130607030853.GA2827@kroah.com>
References: <1370504296-24389-1-git-send-email-shuox.liu@intel.com>
 <alpine.LFD.2.02.1306061505210.2905@ionos>
 <1370566409.4432.41.camel@ymzhang.sh.intel.com>
 <20130607010225.GA28256@kroah.com>
 <1370572672.4432.49.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370572672.4432.49.camel@ymzhang.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 10:37:52AM +0800, Yanmin Zhang wrote:
> On Thu, 2013-06-06 at 18:02 -0700, Greg KH wrote:
> > On Fri, Jun 07, 2013 at 08:53:29AM +0800, Yanmin Zhang wrote:
> > > On Thu, 2013-06-06 at 15:18 +0200, Thomas Gleixner wrote:
> > > > On Thu, 6 Jun 2013, shuox.liu@intel.com wrote:
> > > > > From: Zhang Yanmin <yanmin.zhang@intel.com>
> > > > > 
> > > > > synchronize_irq waits pending IRQ handlers to be finished. If using this
> > > > > function while holding a resource, the IRQ handler may cause deadlock.
> > > > > 
> > > > > Here we add a new function irq_in_progress which doesn't wait for the handlers
> > > > > to be finished.
> > > > > 
> > > > > A typical use case at suspend-to-ram:
> > > > > 
> > > > > device driver's irq handler is complicated and might hold a mutex at rare cases.
> > > > > Its suspend function is called and a suspended flag is set.
> > > > > In case its IRQ handler is running, suspend function calls irq_in_progress. if
> > > > > handler is running, abort suspend.
> > > > > The irq handler checks the suspended flag. If the device is suspended, irq handler
> > > > > either ignores the interrupt, or wakes up the whole system, and the driver's
> > > > > resume function could deal with the delayed interrupt handling.
> > > > 
> > > > This is as wrong as it can be. Fix the driver instead of hacking racy
> > > > functions into the core code.
> > > > 
> > > > So your problem looks like this:
> > > > 
> > > > CPU 0				CPU 1
> > > > irq_handler_thread()		suspend()
> > > >    .....			mutex_lock(&m);
> > > >    mutex_lock(&m);		synchronize_irq();
> > > > 
> > > > So why needs the mutex to be taken before synchronize_irq()? Why not
> > > > doing the obvious?
> > > > 
> > > > suspend()
> > > >   disable_irq(); (Implies synchronize_irq)
> > > >   mutex_lock(&m);
> > > >   ....
> > > >   mutex_unlock(&m);
> > > >   enable_irq();
> > > Thanks for the kind comment.
> > > 
> > > We do consider your solution before and it works well indeed with some specific
> > > simple drivers. For example, some drives use GPIO pin as interrupt source.
> > > 
> > > On one specific platform, disable_irq would really disable the irq at RTE entry,
> > > which means we lose the wakeup capability of this device.
> > > synchronize_irq can be another solution. But we did hit 'DPM device timeout' issue
> > > reported by dpm_wd_handler at suspend-to-ram.
> > > 
> > > The driver is complicated. We couldn't change too many functions to optimize it.
> > > In addition, we have to use the driver instead of throwing it away.
> > 
> > What is preventing you from rewriting it to work properly?
> It's complicated.

That sounds like your issue, not ours, so please don't push the problem
onto someone else.  Take ownership of the driver, fix it up, and all
will be good.


> > > With irq_in_progress, we can resolve this issue and it does work, although it
> > > looks like ugly.
> > 
> > Don't paper over driver bugs in the core kernel, fix the driver.
> It's hard to say it's a driver bug. Could generic kernel provide some
> flexibility for such complicated drivers?

Please post the code for the driver, and then we will be glad to
continue the dicussion.

As for "complicated", just make it "uncomplicated", it's just code :)

greg k-h
