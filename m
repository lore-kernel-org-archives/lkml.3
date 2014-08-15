Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaHOVHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 17:07:25 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:26919 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaHOVHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 17:07:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19rIAwjLrmkYSeCMOKIiqtu
Date: Fri, 15 Aug 2014 14:07:16 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 05/15] tty: serial: Add 8250-core based omap driver
Message-ID: <20140815210716.GE9239@atomide.com>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
 <1408124563-31541-6-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408124563-31541-6-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140815 10:46]:
> This patch provides a 8250-core based UART driver for the internal OMAP
> UART. The long term goal is to provide the same functionality as the
> current OMAP uart driver and DMA support.
> I tried to merge omap-serial code together with the 8250-core code.
> There should should be hardly a noticable difference. The trigger levels
> are different compared to omap-serial:

Nice, now it mostly works for me with off-idle too :) That is as long
as I have the DMA channels commented out in the .dts file.

And I'm still seeing an occasional hang with pstore console just
showing:

[  289.076538] In-band Error seen by MPU  at address 0
[  289.076538] ------------[ cut here ]------------
[  289.076568] WARNING: CPU: 0 PID: 99 at drivers/bus/omap_l3_smx.c:162 omap3_l3_app_irq+0xdc/0x134()
[  289.076599] Modules linked in:
[  289.076599] CPU: 0 PID: 99 Comm: test-idle-off-8 Tainted: G        W      3.16.0+ #510
[  289.076629] [<c0016c44>] (unwind_backtrace) from [<c00129c8>] (show_stack+0x20/0x24)
[  289.076660] [<c00129c8>] (show_stack) from [<c0714cd4>] (dump_stack+0x88/0xa4)

Which most likely means there's still some glitch with the
runtime PM somewhere and registers are being accessed when
not clocked. I _think_ I did not see it when I did not have
console=ttyS2,115200 in my cmdline but was using just pstore
console.

> The device name is ttyS based instead of ttyO. If a ttyO based node name
> is required please ask udev for it. If both driver are activated (this
> and omap-serial) then this serial driver will take control over the
> device due to the link order

That's still not going to help with the existing kernel cmdlines
and existing installs.. I wonder if we can just do a minimal
dummy serial-omap.c that just proxies all the ttyO read/write
access to ttyS?

Regards,

Tony
