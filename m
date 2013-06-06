Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3FFNSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:18:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:40658 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3FFNSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:18:34 -0400
Date: Thu, 6 Jun 2013 15:18:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Liu ShuoX <shuox.liu@intel.com>
cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        fweisbec@gmail.com, sedat.dilek@gmail.com,
        yanmin_zhang@linux.intel.com, srivatsa.bhat@linux.vnet.ibm.com,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [PATCH] irq: add a new function irq_in_progress to check pending
 IRQ handlers
In-Reply-To: <1370504296-24389-1-git-send-email-shuox.liu@intel.com>
Message-ID: <alpine.LFD.2.02.1306061505210.2905@ionos>
References: <1370504296-24389-1-git-send-email-shuox.liu@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jun 2013, shuox.liu@intel.com wrote:
> From: Zhang Yanmin <yanmin.zhang@intel.com>
> 
> synchronize_irq waits pending IRQ handlers to be finished. If using this
> function while holding a resource, the IRQ handler may cause deadlock.
> 
> Here we add a new function irq_in_progress which doesn't wait for the handlers
> to be finished.
> 
> A typical use case at suspend-to-ram:
> 
> device driver's irq handler is complicated and might hold a mutex at rare cases.
> Its suspend function is called and a suspended flag is set.
> In case its IRQ handler is running, suspend function calls irq_in_progress. if
> handler is running, abort suspend.
> The irq handler checks the suspended flag. If the device is suspended, irq handler
> either ignores the interrupt, or wakes up the whole system, and the driver's
> resume function could deal with the delayed interrupt handling.

This is as wrong as it can be. Fix the driver instead of hacking racy
functions into the core code.

So your problem looks like this:

CPU 0				CPU 1
irq_handler_thread()		suspend()
   .....			mutex_lock(&m);
   mutex_lock(&m);		synchronize_irq();

So why needs the mutex to be taken before synchronize_irq()? Why not
doing the obvious?

suspend()
  disable_irq(); (Implies synchronize_irq)
  mutex_lock(&m);
  ....
  mutex_unlock(&m);
  enable_irq();

Thanks,

	tglx
