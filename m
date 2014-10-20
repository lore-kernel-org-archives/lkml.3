Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaJTWQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:16:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32835 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaJTWQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:16:58 -0400
Date: Mon, 20 Oct 2014 15:16:56 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Kumar Gala <galak@codeaurora.org>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] tty: serial: msm: Fix lock init issue with earlycon
Message-ID: <20141020221656.GC12469@codeaurora.org>
References: <1413551588-14877-1-git-send-email-galak@codeaurora.org>
 <544553F6.1020409@codeaurora.org>
 <544580ED.3050604@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544580ED.3050604@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20, Peter Hurley wrote:
> On 10/20/2014 02:27 PM, Stephen Boyd wrote:
> > On 10/17/2014 06:13 AM, Kumar Gala wrote:
> >> With CONFIG_DEBUG_SPINLOCK enabled we see:
> >>
> >> BUG: spinlock bad magic on CPU#0, swapper/0
> >>   lock: early_console_dev+0x8/0x160, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> >> CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-09733-gb446b33-dirty #18
> > 
> > [...]
> > 
> >> diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
> >> index 4b6c783..8ab27c9 100644
> >> --- a/drivers/tty/serial/msm_serial.c
> >> +++ b/drivers/tty/serial/msm_serial.c
> >> @@ -973,6 +973,8 @@ msm_serial_early_console_setup(struct earlycon_device *device, const char *opt)
> >>       if (!device->port.membase)
> >>           return -ENODEV;
> >>   +    spin_lock_init(&device->port.lock);
> >> +
> >>       device->con->write = msm_serial_early_write;
> >>       return 0;
> >>   }
> >> @@ -995,6 +997,8 @@ msm_serial_early_console_setup_dm(struct earlycon_device *device,
> >>       if (!device->port.membase)
> >>           return -ENODEV;
> >>   +    spin_lock_init(&device->port.lock);
> >> +
> >>       device->con->write = msm_serial_early_write_dm;
> >>       return 0;
> >>   }
> > 
> > Could this be done in the tty core instead?
> 
> Or even better: refactor __msm_console_write() so no spin_lock() is required
> for the earlycon write.

Can't we keep the early console forever with keep_bootcon? In
which case we may want to prevent things from trampling on each
other? I don't see how the lock will help us here though because
the port isn't even the same between the earlycon and the ttyMSM
console. Removing the lock from the earlycon path is probably
easier than caring about this debugging scenario.

> 
> FWIW, __msm_console_write() is a deadlock-waiting-to_happen since it does
> not disable interrupts with spin_lock_irqsave().
> 

Yeah we should fix that. As far as I can tell we've never used
the irqsave variant of the lock in the console path. Did this
become necessary at some point since this driver was introduced?
I'm wondering how many stable trees need the fix.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
