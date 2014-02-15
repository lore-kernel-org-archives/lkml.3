Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaBOJu1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 04:50:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33216 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaBOJuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 04:50:23 -0500
Date: Sat, 15 Feb 2014 10:50:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <chris@printf.net>, linux-mmc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/2] genirq: Provide synchronize_hardirq()
Message-ID: <20140215095008.GG14089@laptop.programming.kicks-ass.net>
References: <20140215002742.507053194@linutronix.de>
 <20140215003823.653236081@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140215003823.653236081@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 12:55:18AM -0000, Thomas Gleixner wrote:
> synchronize_irq() waits for hard irq and threaded handlers to complete
> before returning. For some special cases we only need to make sure
> that the hard interrupt part of the irq line is not in progress when
> we disabled the - possibly shared - interrupt at the device level.
> 
> A proper use case for this was provided by Russell. The sdhci driver
> requires some irq triggered functions to be run in thread context. The
> current implementation of the thread context is a sdio private kthread
> construct, which has quite some shortcomings. These can be avoided
> when the thread is directly associated to the device interrupt via the
> generic threaded irq infrastructure.
> 
> Though there is a corner case related to run time power management
> where one side disables the device interrupts at the device level and
> needs to make sure, that an already running hard interrupt handler has
> completed before proceeding further. Though that hard interrupt
> handler might wake the associated thread, which in turn can request
> the runtime PM to reenable the device. Using synchronize_irq() leads
> to an immediate deadlock of the irq thread waiting for the PM lock and
> the synchronize_irq() waiting for the irq thread to complete.
> 
> Due to the fact that it is sufficient for this case to ensure that no
> hard irq handler is executing a new function which avoids the check
> for the thread is required.
> 
> Add a function, which just monitors the hard irq parts and ignores the
> threaded handlers.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Peter Zijlstra <peterz@infradead.org>
