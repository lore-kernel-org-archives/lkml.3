Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3GXUWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:22:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38493 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3GXUV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:21:58 -0400
Date: Wed, 24 Jul 2013 21:21:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Fix deadlock scenario with smp_send_stop()
Message-ID: <20130724202148.GA24642@n2100.arm.linux.org.uk>
References: <1373384217-26307-1-git-send-email-sboyd@codeaurora.org> <20130724185618.GD27761@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130724185618.GD27761@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 11:56:18AM -0700, Stephen Boyd wrote:
> On 07/09, Stephen Boyd wrote:
> > If one process calls sys_reboot and that process then stops other
> > CPUs while those CPUs are within a spin_lock() region we can
> > potentially encounter a deadlock scenario like below.
> > 
> > CPU 0                   CPU 1
> > -----                   -----
> >                         spin_lock(my_lock)
> > smp_send_stop()
> >  <send IPI>             handle_IPI()
> >                          disable_preemption/irqs
> >                           while(1);
> >  <PREEMPT>
> > spin_lock(my_lock) <--- Waits forever
> > 
> > We shouldn't attempt to run any other tasks after we send a stop
> > IPI to a CPU so disable preemption so that this task runs to
> > completion.
> > 
> > Reported-by: Sundarajan Srinivasan <sundaraj@codeaurora.com>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> > 
> > Resending this patch now that the context has changed.
> 
> Ping? Shall I put this in the patch tracker?

Well, looking at x86, they use local_irq_disable() before sending the
stop, so I think we should do the same for cross-arch consistency.
