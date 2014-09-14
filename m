Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaINXln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 19:41:43 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:37440 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaINXlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 19:41:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH/RFC] rtc: rtc-twl: Fixed nested IRQ handling in resume from suspend
Date: Mon, 15 Sep 2014 02:41:45 +0300
Message-ID: <3285590.DFfac97QLO@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.10.1409132108520.23397@nanos>
References: <1410607196-3941-1-git-send-email-laurent.pinchart@ideasonboard.com> <alpine.DEB.2.10.1409132108520.23397@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Saturday 13 September 2014 21:12:16 Thomas Gleixner wrote:
> On Sat, 13 Sep 2014, Laurent Pinchart wrote:
> > The TWL RTC interrupt is a double-nested threaded interrupt, handled
> > through the TWL SIH (Secondary Interrupt Handler) and PIH (Primary
> > Interrupt Handler).
> > 
> > When the system is woken up from suspend by a TWL RTC alarm interrupt,
> > the TWL PIH and SIH are enabled first (due to the normal IRQ enabling
> > sequence for the PIH and to the IRQF_EARLY_RESUME flag for the SIH)
> > before the TWL RTC interrupt gets enabled. This results on the interrupt
> > being processed by the TWL primary interrupt handler, forwarded to the
> > nested SIH, and then marked as pending for the RTC by handle_nested_irq
> > called from the SIH.
> > 
> > The RTC interrupt then eventually gets reenabled the kernel, which will
> > try to call its top half interrupt handler. As the interrupt is a nested
> > threaded IRQ, its primary handler has been set to the
> > irq_nested_primary_handler function, which is never supposed to be
> > called and generates a WARN_ON, without waking the IRQ thread up.
> > 
> > Fix this by setting the IRQF_EARLY_RESUME for the TWL RTC interrupt to
> > ensure it gets enabled before the parent handlers try to process it.
> > 
> > This is likely a bit of a hack, I have a feeling that a more generic
> > solution that would fix the problem for all nested threaded IRQs enabled
> > as a wake up source by enable_irq_wake would be better.
> 
> Indeed. It's a hack. This is not the first abuse of IRQF_EARLY_RESUME
> which is used to "fix" ordering issues with nested thread handlers.
> 
> I haven't come around yet to analyze the issue and come up with a proper
> core side mechanism to handle that case. I put it on the "look at it while
> trapped in a tin can" list.

Should this patch be applied in the meantime, or do you think you will be 
trapped in a tin can in the not too distant future ?

-- 
Regards,

Laurent Pinchart

