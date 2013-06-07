Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab3FGAvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 20:51:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:48743 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab3FGAvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 20:51:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,818,1363158000"; 
   d="scan'208";a="325544618"
Message-ID: <1370566409.4432.41.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH] irq: add a new function irq_in_progress to check
 pending IRQ handlers
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Liu ShuoX <shuox.liu@intel.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, fweisbec@gmail.com, sedat.dilek@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com,
        Zhang Yanmin <yanmin.zhang@intel.com>
Date: Fri, 07 Jun 2013 08:53:29 +0800
In-Reply-To: <alpine.LFD.2.02.1306061505210.2905@ionos>
References: <1370504296-24389-1-git-send-email-shuox.liu@intel.com>
	 <alpine.LFD.2.02.1306061505210.2905@ionos>
Organization: Intel.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-06 at 15:18 +0200, Thomas Gleixner wrote:
> On Thu, 6 Jun 2013, shuox.liu@intel.com wrote:
> > From: Zhang Yanmin <yanmin.zhang@intel.com>
> > 
> > synchronize_irq waits pending IRQ handlers to be finished. If using this
> > function while holding a resource, the IRQ handler may cause deadlock.
> > 
> > Here we add a new function irq_in_progress which doesn't wait for the handlers
> > to be finished.
> > 
> > A typical use case at suspend-to-ram:
> > 
> > device driver's irq handler is complicated and might hold a mutex at rare cases.
> > Its suspend function is called and a suspended flag is set.
> > In case its IRQ handler is running, suspend function calls irq_in_progress. if
> > handler is running, abort suspend.
> > The irq handler checks the suspended flag. If the device is suspended, irq handler
> > either ignores the interrupt, or wakes up the whole system, and the driver's
> > resume function could deal with the delayed interrupt handling.
> 
> This is as wrong as it can be. Fix the driver instead of hacking racy
> functions into the core code.
> 
> So your problem looks like this:
> 
> CPU 0				CPU 1
> irq_handler_thread()		suspend()
>    .....			mutex_lock(&m);
>    mutex_lock(&m);		synchronize_irq();
> 
> So why needs the mutex to be taken before synchronize_irq()? Why not
> doing the obvious?
> 
> suspend()
>   disable_irq(); (Implies synchronize_irq)
>   mutex_lock(&m);
>   ....
>   mutex_unlock(&m);
>   enable_irq();
Thanks for the kind comment.

We do consider your solution before and it works well indeed with some specific
simple drivers. For example, some drives use GPIO pin as interrupt source.

On one specific platform, disable_irq would really disable the irq at RTE entry,
which means we lose the wakeup capability of this device.
synchronize_irq can be another solution. But we did hit 'DPM device timeout' issue
reported by dpm_wd_handler at suspend-to-ram.

The driver is complicated. We couldn't change too many functions to optimize it.
In addition, we have to use the driver instead of throwing it away.

With irq_in_progress, we can resolve this issue and it does work, although it
looks like ugly.

Yanmin


