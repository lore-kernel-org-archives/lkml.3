Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab3FGEwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 00:52:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:31189 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab3FGEwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 00:52:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,819,1363158000"; 
   d="scan'208";a="346196288"
Message-ID: <1370580895.4432.64.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH] irq: add a new function irq_in_progress to check
 pending IRQ handlers
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Liu ShuoX <shuox.liu@intel.com>,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        sedat.dilek@gmail.com, srivatsa.bhat@linux.vnet.ibm.com,
        Zhang Yanmin <yanmin.zhang@intel.com>
Date: Fri, 07 Jun 2013 12:54:55 +0800
In-Reply-To: <20130607041922.GA3603@kroah.com>
References: <1370504296-24389-1-git-send-email-shuox.liu@intel.com>
	 <alpine.LFD.2.02.1306061505210.2905@ionos>
	 <1370566409.4432.41.camel@ymzhang.sh.intel.com>
	 <20130607010225.GA28256@kroah.com>
	 <1370572672.4432.49.camel@ymzhang.sh.intel.com>
	 <20130607030853.GA2827@kroah.com>
	 <1370575086.4432.52.camel@ymzhang.sh.intel.com>
	 <20130607041922.GA3603@kroah.com>
Organization: Intel.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-06 at 21:19 -0700, Greg KH wrote:
> On Fri, Jun 07, 2013 at 11:18:06AM +0800, Yanmin Zhang wrote:
> > On Thu, 2013-06-06 at 20:08 -0700, Greg KH wrote:
> > > On Fri, Jun 07, 2013 at 10:37:52AM +0800, Yanmin Zhang wrote:
> > > > On Thu, 2013-06-06 at 18:02 -0700, Greg KH wrote:
> > > > > On Fri, Jun 07, 2013 at 08:53:29AM +0800, Yanmin Zhang wrote:
> > > > > > On Thu, 2013-06-06 at 15:18 +0200, Thomas Gleixner wrote:
> > > > > > > On Thu, 6 Jun 2013, shuox.liu@intel.com wrote:
> > > > > > > > From: Zhang Yanmin <yanmin.zhang@intel.com>
> > > > > > > > 
> > > > > > > > synchronize_irq waits pending IRQ handlers to be finished. If using this
> > > > > > > > function while holding a resource, the IRQ handler may cause deadlock.
> > > > > > > > 
> > > > > > > > Here we add a new function irq_in_progress which doesn't wait for the handlers
> > > > > > > > to be finished.
> > > > > > > > 
> > > > > > > > A typical use case at suspend-to-ram:
> > > > > > > > 
> > > > > > > > device driver's irq handler is complicated and might hold a mutex at rare cases.
> > > > > > > > Its suspend function is called and a suspended flag is set.
> > > > > > > > In case its IRQ handler is running, suspend function calls irq_in_progress. if
> > > > > > > > handler is running, abort suspend.
> > > > > > > > The irq handler checks the suspended flag. If the device is suspended, irq handler
> > > > > > > > either ignores the interrupt, or wakes up the whole system, and the driver's
> > > > > > > > resume function could deal with the delayed interrupt handling.
> > > > > > > 
> > > > > > > This is as wrong as it can be. Fix the driver instead of hacking racy
> > > > > > > functions into the core code.
> > > > > > > 
> > > > > > > So your problem looks like this:
> > > > > > > 
> > > > > > > CPU 0				CPU 1
> > > > > > > irq_handler_thread()		suspend()
> > > > > > >    .....			mutex_lock(&m);
> > > > > > >    mutex_lock(&m);		synchronize_irq();
> > > > > > > 
> > > > > > > So why needs the mutex to be taken before synchronize_irq()? Why not
> > > > > > > doing the obvious?
> > > > > > > 
> > > > > > > suspend()
> > > > > > >   disable_irq(); (Implies synchronize_irq)
> > > > > > >   mutex_lock(&m);
> > > > > > >   ....
> > > > > > >   mutex_unlock(&m);
> > > > > > >   enable_irq();
> > > > > > Thanks for the kind comment.
> > > > > > 
> > > > > > We do consider your solution before and it works well indeed with some specific
> > > > > > simple drivers. For example, some drives use GPIO pin as interrupt source.
> > > > > > 
> > > > > > On one specific platform, disable_irq would really disable the irq at RTE entry,
> > > > > > which means we lose the wakeup capability of this device.
> > > > > > synchronize_irq can be another solution. But we did hit 'DPM device timeout' issue
> > > > > > reported by dpm_wd_handler at suspend-to-ram.
> > > > > > 
> > > > > > The driver is complicated. We couldn't change too many functions to optimize it.
> > > > > > In addition, we have to use the driver instead of throwing it away.
> > > > > 
> > > > > What is preventing you from rewriting it to work properly?
> > > > It's complicated.
> > > 
> > > That sounds like your issue, not ours, so please don't push the problem
> > > onto someone else.  Take ownership of the driver, fix it up, and all
> > > will be good.
> > > 
> > > 
> > > > > > With irq_in_progress, we can resolve this issue and it does work, although it
> > > > > > looks like ugly.
> > > > > 
> > > > > Don't paper over driver bugs in the core kernel, fix the driver.
> > > > It's hard to say it's a driver bug. Could generic kernel provide some
> > > > flexibility for such complicated drivers?
> > > 
> > > Please post the code for the driver, and then we will be glad to
> > > continue the dicussion.
> > Greg,
> > 
> > Thanks for your enthusiasm. It's a private driver for products.
> 
> What do you mean "private driver"?  All drivers need to be merged into
> the mainline kernel, it saves you time and money, and we will fix your
> bugs for you.
> 
> You know that, your bosses know that, your management knows that, so why
> are you trying to hide things?
> 
> totally confused,
They are embedded device drivers, highly depending on specific devices which runs
its own firmware in devices. Here the kernel drivers run at AP side.

One example is Graphics driver, which is very big and coding is not friendly. Kernel
experts can raise tons of questions against the driver, but we have to make the driver
work well on real products.

Another reason is drivers need workaround many hardware issues. That makes it
hard to implement kernel drivers in good shape sometimes.

We need support all cases.

We fixed lots of hard issues on embedded products and think if kernel could be more
flexible to support complicated cases.

Anyway, thanks.

Yanmin


