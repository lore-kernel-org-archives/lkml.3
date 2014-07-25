Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaGYF64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 01:58:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52237 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaGYF6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 01:58:54 -0400
Date: Fri, 25 Jul 2014 07:58:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Message-ID: <20140725055847.GQ3935@laptop>
References: <20140724212620.GO3935@laptop>
 <13290270.IfKaUSRMLR@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13290270.IfKaUSRMLR@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 01:10:36AM +0200, Rafael J. Wysocki wrote:
> > There is still enable_irq_wake()/IRQD_WAKEUP_STATE that tries to serve
> > a similar purpose but is equially wrecked for shared interrupts,
> > ideally this would be removed.
> 
> Let me comment about this particular thing.
> 
> I had a discussion with Dmitry about that and his argument was that
> enable_irq_wake() should imply IRQF_NO_SUSPEND, because drivers that
> set up interrupts for system wakeup should expect those interrupts to
> trigger at any time, including system suspend.  Hence the patch that
> added the IRQD_WAKEUP_STATE check to __disable_irq().
> 
> However, in the face of the problem that is being addressed here I'm
> not really sure that this argument is valid, because if the driver
> calling enable_irq_wake() is sharing the IRQ with another one, the
> other driver may not actually know that the IRQ will be a wakeup one
> and still may not expect interrupts to come to it during system
> suspend/resume.
> 
> Yes, drivers using enable_irq_wake() will likely want IRQF_NO_SUSPEND to
> be set for their irqactions, but that should not imply "no suspend" for
> all irqactions sharing the same desc.  So I guess it may be better to go
> forth and use a global "interrupts suspended" state variable instead of the
> IRQS_SUSPENDED flag for each desc and throw away the IRQD_WAKEUP_STATE
> check from suspend_device_irqs() entirely.
> 
> Peter, it looks like you'd prefer that?

My preference would be to shoot enable_irq_wake() in the head, its
fundamentally broken.
