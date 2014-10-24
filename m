Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaJXTbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:31:49 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:54136 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaJXTbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:31:48 -0400
Date: Fri, 24 Oct 2014 21:28:45 +0200
From: Johan Hovold <johan@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Johan Hovold <johan@kernel.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: remove redundant irq disable at halt and restart
Message-ID: <20141024192845.GC19377@localhost>
References: <1414177592-14547-1-git-send-email-johan@kernel.org>
 <20141024191627.GA11455@saruman>
 <20141024192111.GC11455@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024192111.GC11455@saruman>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 02:21:11PM -0500, Felipe Balbi wrote:
> On Fri, Oct 24, 2014 at 02:16:27PM -0500, Felipe Balbi wrote:
> > On Fri, Oct 24, 2014 at 09:06:32PM +0200, Johan Hovold wrote:
> > > Remove redundant local_irq_disable() at machine halt and restart.
> > > 
> > > Since commit 44424c34049f ("ARM: 7803/1: Fix deadlock scenario with
> > > smp_send_stop()") interrupts are disabled before stopping secondary
> > > CPUs.
> > 
> > Assuming this is correct, you should have:
> > 
> > Fixes: 44424c3 (ARM: 7803/1: Fix deadlock scenario with smp_send_stop())
> > Cc: <stable@vger.kernel.org> # v3.12+

It's not a bug. Just a redundant disabling of already disabled
interrupts, something which could possibly lead someone to believe that
interrupts could be re-enabled by the power-off handler.

And if that was the case, wouldn't that introduce the bug that
44424c34049f ("ARM: 7803/1: Fix deadlock scenario with smp_send_stop()")
was trying to fix?

> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > ---
> > >  arch/arm/kernel/process.c | 2 --
> > >  1 file changed, 2 deletions(-)
> > > 
> > > diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> > > index a35f6ebbd2c2..5663ab57cf07 100644
> > > --- a/arch/arm/kernel/process.c
> > > +++ b/arch/arm/kernel/process.c
> > > @@ -195,7 +195,6 @@ void machine_halt(void)
> > >  	local_irq_disable();
> > >  	smp_send_stop();
> > >  
> > > -	local_irq_disable();
> > >  	while (1);
> > >  }
> > >  
> > > @@ -237,7 +236,6 @@ void machine_restart(char *cmd)
> > >  
> > >  	/* Whoops - the platform was unable to reboot. Tell the user! */
> > >  	printk("Reboot failed -- System halted\n");
> > > -	local_irq_disable();
> > 
> > ... but wouldn't this reintroduce the the buck which that commit fixed ?
> 
> s/buck/bug :-) my fingers have a mind of their own, aparently.

:)

No, the interrupts would still be disabled.

Thanks,
Johan
