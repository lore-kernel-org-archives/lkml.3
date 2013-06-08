Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166Ab3FHCc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 22:32:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:59076 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab3FHCc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 22:32:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,826,1363158000"; 
   d="scan'208";a="314005769"
Message-ID: <1370658872.4432.109.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH] irq: add a new function irq_in_progress to check
 pending IRQ handlers
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Liu ShuoX <shuox.liu@intel.com>,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        sedat.dilek@gmail.com, srivatsa.bhat@linux.vnet.ibm.com,
        Zhang Yanmin <yanmin.zhang@intel.com>
Date: Sat, 08 Jun 2013 10:34:32 +0800
In-Reply-To: <20130607150835.GA5264@kroah.com>
References: <1370504296-24389-1-git-send-email-shuox.liu@intel.com>
	 <alpine.LFD.2.02.1306061505210.2905@ionos>
	 <1370566409.4432.41.camel@ymzhang.sh.intel.com>
	 <20130607010225.GA28256@kroah.com>
	 <1370572672.4432.49.camel@ymzhang.sh.intel.com>
	 <20130607030853.GA2827@kroah.com>
	 <1370575086.4432.52.camel@ymzhang.sh.intel.com>
	 <20130607041922.GA3603@kroah.com>
	 <1370580895.4432.64.camel@ymzhang.sh.intel.com>
	 <20130607150835.GA5264@kroah.com>
Organization: Intel.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-07 at 08:08 -0700, Greg KH wrote:
> On Fri, Jun 07, 2013 at 12:54:55PM +0800, Yanmin Zhang wrote:
> > On Thu, 2013-06-06 at 21:19 -0700, Greg KH wrote:
> > > On Fri, Jun 07, 2013 at 11:18:06AM +0800, Yanmin Zhang wrote:
> > > > On Thu, 2013-06-06 at 20:08 -0700, Greg KH wrote:
> > > > > On Fri, Jun 07, 2013 at 10:37:52AM +0800, Yanmin Zhang wrote:
> > > > > > On Thu, 2013-06-06 at 18:02 -0700, Greg KH wrote:
> > > > > > > On Fri, Jun 07, 2013 at 08:53:29AM +0800, Yanmin Zhang wrote:
> > > > > > > > On Thu, 2013-06-06 at 15:18 +0200, Thomas Gleixner wrote:
> > > > > > > > > On Thu, 6 Jun 2013, shuox.liu@intel.com wrote:
> > > > > > > > > > From: Zhang Yanmin <yanmin.zhang@intel.com>
> > > > > > > > > > 
> > > > > > > > > > synchronize_irq waits pending IRQ handlers to be finished. If using this
> > > > > > > > > > function while holding a resource, the IRQ handler may cause deadlock.
> > > > > > > > > > 
> > > > > > > > > > Here we add a new function irq_in_progress which doesn't wait for the handlers
> > > > > > > > > > to be finished.
> > > > > > > > > > 
> > > > > > > > > > A typical use case at suspend-to-ram:
> > > > > > > > > > 
> > > > > > > > > > device driver's irq handler is complicated and might hold a mutex at rare cases.
> > > > > > > > > > Its suspend function is called and a suspended flag is set.
> > > > > > > > > > In case its IRQ handler is running, suspend function calls irq_in_progress. if
> > > > > > > > > > handler is running, abort suspend.
> > > > > > > > > > The irq handler checks the suspended flag. If the device is suspended, irq handler
> > > > > > > > > > either ignores the interrupt, or wakes up the whole system, and the driver's
> > > > > > > > > > resume function could deal with the delayed interrupt handling.
> > > > > > > > > 
> > > > > > > > > This is as wrong as it can be. Fix the driver instead of hacking racy
> > > > > > > > > functions into the core code.
> > > > > > > > > 
> > > > > > > > > So your problem looks like this:
> > > > > > > > > 
> > > > > > > > > CPU 0				CPU 1
> > > > > > > > > irq_handler_thread()		suspend()
> > > > > > > > >    .....			mutex_lock(&m);
> > > > > > > > >    mutex_lock(&m);		synchronize_irq();
> > > > > > > > > 
> > > > > > > > > So why needs the mutex to be taken before synchronize_irq()? Why not
> > > > > > > > > doing the obvious?
> > > > > > > > > 
> > > > > > > > > suspend()
> > > > > > > > >   disable_irq(); (Implies synchronize_irq)
> > > > > > > > >   mutex_lock(&m);
> > > > > > > > >   ....
> > > > > > > > >   mutex_unlock(&m);
> > > > > > > > >   enable_irq();
> > > > > > > > Thanks for the kind comment.
> > > > > > > > 
> > > > > > > > We do consider your solution before and it works well indeed with some specific
> > > > > > > > simple drivers. For example, some drives use GPIO pin as interrupt source.
> > > > > > > > 
> > > > > > > > On one specific platform, disable_irq would really disable the irq at RTE entry,
> > > > > > > > which means we lose the wakeup capability of this device.
> > > > > > > > synchronize_irq can be another solution. But we did hit 'DPM device timeout' issue
> > > > > > > > reported by dpm_wd_handler at suspend-to-ram.
> > > > > > > > 
> > > > > > > > The driver is complicated. We couldn't change too many functions to optimize it.
> > > > > > > > In addition, we have to use the driver instead of throwing it away.
> > > > > > > 
> > > > > > > What is preventing you from rewriting it to work properly?
> > > > > > It's complicated.
> > > > > 
> > > > > That sounds like your issue, not ours, so please don't push the problem
> > > > > onto someone else.  Take ownership of the driver, fix it up, and all
> > > > > will be good.
> > > > > 
> > > > > 
> > > > > > > > With irq_in_progress, we can resolve this issue and it does work, although it
> > > > > > > > looks like ugly.
> > > > > > > 
> > > > > > > Don't paper over driver bugs in the core kernel, fix the driver.
> > > > > > It's hard to say it's a driver bug. Could generic kernel provide some
> > > > > > flexibility for such complicated drivers?
> > > > > 
> > > > > Please post the code for the driver, and then we will be glad to
> > > > > continue the dicussion.
> > > > Greg,
> > > > 
> > > > Thanks for your enthusiasm. It's a private driver for products.
> > > 
> > > What do you mean "private driver"?  All drivers need to be merged into
> > > the mainline kernel, it saves you time and money, and we will fix your
> > > bugs for you.
> > > 
> > > You know that, your bosses know that, your management knows that, so why
> > > are you trying to hide things?
> > > 
> > > totally confused,
> > They are embedded device drivers, highly depending on specific devices which runs
> > its own firmware in devices. Here the kernel drivers run at AP side.
> 
> That's no different from loads of drivers that we have in the kernel
> today, no need to keep them from being merged, please submit them.
It need managers' approval and is beyond my capability.

> 
> > One example is Graphics driver, which is very big and coding is not friendly. Kernel
> > experts can raise tons of questions against the driver, but we have to make the driver
> > work well on real products.
> 
> So you are saying that "kernel experts" don't ask questions that
> actually make drivers "work well on real products"?
Obviously, I didn't say that. Pls. also remove the ", as I really
think I'm talking to kernel experts indeed.

>   If that's how you
> feel about the community, then why are you asking the community for help
> in the first place?
1) If upstream merges the patch, we wouldn't always port it to new kernel when
we upgrade our kernel to the latest.
2) Benefit others;

> 
> And do you somehow think that we don't know how to review/write/fix
> graphics drivers?
You know that.

>   Who do you think made Linux in the first place?
All guys who work in linux community proactively.

> 
> > Another reason is drivers need workaround many hardware issues. That makes it
> > hard to implement kernel drivers in good shape sometimes.
> 
> That's hogwash, we deal with that every single day, in almost every
> single driver we write.  That's why we have a kernel in the first place,
> to fix hardware problems and provide a unified interface to userspace so
> that it does NOT have to deal with hardware problems and differences.
Right. Linux kernel is good, but not perfect.
It's a trade-off between perfect and real utilization.

> 
> > We need support all cases.
> 
> What "cases"?
> 
> > We fixed lots of hard issues on embedded products and think if kernel could be more
> > flexible to support complicated cases.
> 
> Do you think that Linux is not "flexible"?  It runs on more processors,
> and more system configurations than any other operating system ever has
> in the history of computing.  How is that not "complicated"?
> 
> No one is forcing you to use Linux, so if you don't want to participate
> by providing your drivers and accepting feedback, don't expect us to
> change the core for drivers we have never seen and feel are broken.  It
> doesn't work that way.
> 
> I think you need to spend some time with your company's Linux community
> development training programs, it's pretty obvious that you don't
> understand how the Linux kernel development process works at all.
It seems I could only say that: Linux kernel is perfect. It has no fault.

We just submitted a patch to provide a method to support a use case. Then,
you pour out so many things which are far away from the original discussion. :)

Yanmin


