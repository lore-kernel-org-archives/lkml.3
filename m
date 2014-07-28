Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaG1KFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:05:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34262 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaG1KFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:05:40 -0400
Date: Mon, 28 Jul 2014 12:05:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH RFC v2] PM / sleep: Fix racing timers
Message-ID: <20140728100538.GA16237@amd.pavel.ucw.cz>
References: <53D083C5.2000501@linaro.org>
 <1406322408-15408-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406322408-15408-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-07-25 14:06:48, Soren Brinkmann wrote:
> On platforms that do not power off during suspend, successfully entering
> suspend races with timers.
> 
> The race happening in a couple of location is:
> 
>   1. disable IRQs   		(e.g. arch_suspend_disable_irqs())
>      ...
>   2. syscore_suspend()
>       -> timekeeping_suspend()
>        -> clockevents_notify(SUSPEND)
>         -> tick_suspend()   	(timers are turned off here)
>      ...
>   3. wfi            		(wait for wake-IRQ here)
> 
> Between steps 1 and 2 the timers can still generate interrupts that are
> not handled and stay pending until step 3. That pending IRQ causes an
> immediate - spurious - wake.
> 
> The solution is to move the clockevents suspend/resume notification
> out of the syscore_suspend step and explictly call them at the appropriate
> time in the suspend/hibernation paths. I.e. timers are suspend _before_
> IRQs get disabled. And accordingly in the resume path.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Did you test the hibernation?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
