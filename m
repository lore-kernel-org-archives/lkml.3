Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab3HMTd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:33:27 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44517 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516Ab3HMTdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:33:25 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>,
        =?utf-8?Q?Beno=C3=AEt?= Coussno <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: Platform device tester - Allow removal
References: <1376386470-27328-1-git-send-email-panto@antoniou-consulting.com>
	<20130813182012.GE7740@kroah.com>
	<70F17005-652E-4C04-B6EC-51E16EE237C3@antoniou-consulting.com>
	<20130813185512.GA25647@n2100.arm.linux.org.uk>
Date: Tue, 13 Aug 2013 12:33:21 -0700
In-Reply-To: <20130813185512.GA25647@n2100.arm.linux.org.uk> (Russell King's
	message of "Tue, 13 Aug 2013 19:55:12 +0100")
Message-ID: <87ioz9idxa.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Tue, Aug 13, 2013 at 09:42:27PM +0300, Pantelis Antoniou wrote:
>> But creation just crashes.
>> 
>> > root@beaglebone:/sys/bus/platform/drivers/omap_i2c# echo 4819c000.i2c >bind   
>> > [  145.053929] Unable to handle kernel NULL pointer dereference at virtual address 00000001
>> > [  145.062651] pgd = ca8c0000
>> > [  145.065507] [00000001] *pgd=8f437831, *pte=00000000, *ppte=00000000
>> > [  145.072163] Internal error: Oops: 17 [#1] SMP ARM
>> > [  145.077105] Modules linked in: ipv6 autofs4
>> > [  145.081537] CPU: 0 PID: 301 Comm: sh Not tainted 3.11.0-rc5-00125-g3b988fb #146
>> > [  145.089222] task: cf5b5580 ti: cf464000 task.ti: cf464000
>> > [  145.094918] PC is at omap_i2c_runtime_suspend+0x10/0xb4
>> > [  145.100408] LR is at omap_i2c_runtime_suspend+0x8/0xb4
>
> Well then, what you have here is a bug in the way that OMAP re-uses the
> platform device stuff - and that _does_ need fixing somehow.
>
> The problem is that i2c_dev->regs is NULL at the point where
> pm_runtime_set_autosuspend_delay() is called, which as autosuspend
> is still set from the time that the device was unbound, it means that
> this triggers an immediate suspend.
>
> I suspect that:
>
>         pm_runtime_set_autosuspend_delay(dev->dev, OMAP_I2C_PM_TIMEOUT);
>         pm_runtime_use_autosuspend(dev->dev);
>
> should be moved later in the probe function, after the switch (scheme)
> block.

That's correct.  

At a minimum, it should be after the _get_sync() call.  Without any
users (callers of pm_runtime_get*) the _set_autosuspend_delay() call
will try to rpm_idle().

Kevin
