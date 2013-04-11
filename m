Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934901Ab3DKOPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:15:40 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:37559 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3DKOPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:15:37 -0400
From: Kevin Hilman <khilman@linaro.org>
To: "Bedia\, Vaibhav" <vaibhav.bedia@ti.com>
Cc: "Poddar\, Sourav" <sourav.poddar@ti.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tony\@atomide.com" <tony@atomide.com>,
        "rmk+kernel\@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial\@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "Shilimkar\, Santosh" <santosh.shilimkar@ti.com>,
        "Balbi\, Felipe" <balbi@ti.com>, "Nayak\, Rajendra" <rnayak@ti.com>
Subject: Re: [PATCHv3] driver: serial: prevent UART console idle on suspend while using "no_console_suspend"
References: <1365167733-28083-1-git-send-email-sourav.poddar@ti.com>
	<87mwtclvua.fsf@linaro.org> <516463D2.2070008@ti.com>
	<87obdnh6au.fsf@linaro.org> <516501A0.4000004@ti.com>
	<B5906170F1614E41A8A28DE3B8D121433ED96446@DBDE01.ent.ti.com>
	<51653450.2010200@ti.com>
	<B5906170F1614E41A8A28DE3B8D121433ED96C45@DBDE01.ent.ti.com>
	<87bo9myt52.fsf@linaro.org>
Date: Thu, 11 Apr 2013 07:15:33 -0700
In-Reply-To: <87bo9myt52.fsf@linaro.org> (Kevin Hilman's message of "Wed, 10
	Apr 2013 14:26:17 -0700")
Message-ID: <87y5cpxiey.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Hilman <khilman@linaro.org> writes:

> "Bedia, Vaibhav" <vaibhav.bedia@ti.com> writes:
>
>> Hi Sourav,
>>
>> On Wed, Apr 10, 2013 at 15:13:44, Poddar, Sourav wrote:
>> [...]
>>> Yes, had a look at that and found your situation similar to UART.
>>> 
>>> But how exactly this gets used, I mean I don't  see any drivers/ in mainline
>>> making use of this compatible string  "ti,am3352-ocmcram".  ?
>>
>> OCMC clock is enabled during bootup (not sure whether that's the h/w
>> default or ROM does it) since the initial bootloader runs from there.
>> By marking the corresponding hwmod with HWMOD_INIT_NO_IDLE we leave the
>> clock running. Right now the sram code under arch/arm/plat-omap/ is what
>> manages the OCMC. I guess this needs to move somewhere under drivers/
>> and start managing the clocks. Even then we'll need a mechanism
>> to leave the clocks running as part of the kernel suspend process
>> since the assembly code which runs at the fag end of the suspend
>> process runs out of OCMC and hence we can't cut its clock.
>>
>> On AM335x, the OCMC clock is cut to have PER power domain transition
>> but that's done in the WKUP-M3 firmware when going down. During the
>> wakeup sequence, WKUP-M3 re-enables the OCMC clock so that when the
>> kernel resumes the h/w state is same.
>
> OK, but *today*, in *mainline*, where in the linux kernel (not the M3
> firmware) is the OCMRAM clock cut during suspend?
>
> From what I can see, there is no driver for this device, so there are no
> system PM calls being done for that device, and thus no omap_device
> calls being done for that device, so the no_idle_on_suspend has no
> effect.

OK, I think I confused things here, sorry. I was thinking runtime PM
here, but wrote system PM.  The no_idle_on_suspend feature only affects
system PM, and the omap_device calls will still be called during system
PM, even without a driver.

That being said, the commit below[1], added in v3.6 should prevent the
any automaic clock gating for devices without drivers bound.  Since
there is no driver for the OCM RAM block, you shouldn't be affected by
the automatic idle on suspend anyways.

So, my proposal is that Sourav remove that flag from the AM33xx hwmod
when he removes this feature.

Kevin


[1]
commit 72bb6f9b51c82c820ddef892455a85b115460904
Author: Kevin Hilman <khilman@ti.com>
Date:   Tue Jul 10 15:29:04 2012 -0700

    ARM: OMAP: omap_device: don't attempt late suspend if no driver bound
    
    Currently, the omap_device PM domain layer uses the late suspend and
    early resume callbacks to ensure devices are in their low power
    states.
    
    However, this is attempted even in cases where a driver probe has
    failed.  If a driver's ->probe() method fails, the driver is likely in
    a state where it is not expecting its runtime PM callbacks to be
    called, yet currently the omap_device PM domain code attempts to call
    the drivers callbacks.
    
    To fix, use the omap_device driver_status field to check whether a
    driver is bound to the omap_device before attempting to trigger driver
    callbacks.
    
    Reviewed-by: Paul Walmsley <paul@pwsan.com>
    Signed-off-by: Kevin Hilman <khilman@ti.com>
