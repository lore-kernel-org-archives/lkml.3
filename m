Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaGIMnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:43:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:41152 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbaGIMnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:43:09 -0400
Message-ID: <53BD38D3.2000204@linutronix.de>
Date: Wed, 09 Jul 2014 14:42:59 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mika.westerberg@linux.intel.com
Subject: Re: [RFC PATCH 3/4] tty: serial: 8250 core: add runtime pm
References: <1404491651-1388-1-git-send-email-bigeasy@linutronix.de> <1404491651-1388-3-git-send-email-bigeasy@linutronix.de> <20140707142056.46f61cf9@alan.etchedpixels.co.uk> <20140709111705.GR28884@atomide.com> <53BD291D.3040307@linutronix.de> <20140709114837.GU28884@atomide.com>
In-Reply-To: <20140709114837.GU28884@atomide.com>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 01:48 PM, Tony Lindgren wrote:
>>> So we can certainly enable this in a generic way, however, this
>>> can only be done under the following conditions:
> 
> Sorry forgot to mention why I think this can now be done in a
> generic way, that's because we have now runtime PM in Linux.

I have a problem to follow here. I need set SET_RUNTIME_PM_OPS in
.pm member of the driver. This is around for a while now maybe it
wasn't around by the omap-serial was written but this doesn't matter
now.

As for the dw driver (as one of the gnomes points out) it shouldn't
matter because it is enabled / disabled based on 8250's pm callback. So
while the device is active and the 8250 core grabs & puts the
reference, nothing should change. Still a double check from Mika
wouldn't hurt.

If I understand the omap case correct (and please correct me if I don't)
the 8250-omap driver assumes that the device can go to sleep
after the probe function completes. This does not happen
because pm_runtime_set_autosuspend_delay() sets the delay to -1.
If the user changes this via sysfs, then the device might go to sleep
and the IP block switched of. Therefore we need the runtime pm
callbacks in 8250-core before the register access because we can't
access the it otherwise.
The core should wake us up in case there is incoming RX action to be
handled so we can restore register's content. And for TX we have the
proper pm hooks.
The dw driver also only disables / enables the clock. So they don't
lose the register's content like omap does. Thus they don't need the
one struct I exported.

I don't think that it makes sense to make this restore/save part
generic if this what it is about. OMAP at least has a few registers
more to take care of and set-termios is already different.

>>> 1. We can save and restore the serial register context and detect
>>>    when context was lost in the serial driver. The context loss
>>>    can be detected by looking at some registers that are only
>>>    initialized during init.
>>
>> A register check on restore context? DLL+DLH might be a good hint here
>> since its value should be >0 in the running case.
> 
> OK yeah that would be a generic way to do it potentially ;)
> 
> Note that all the context_loss_cnt stuff in omap-serial.c can
> then be ignored, that's still only needed for the omap3 legacy
> mode booting case and won't be needed much longer.

Ah. The way the code reads, it is just an optimization in case the core
didn't go off after all so we don't have to restore the registers.

>>> 2. There's a way for the serial RX pin to wake the SoC. On some
>>>    omaps there's a separate pin specific wake-up interrupt that
>>>    can be used for that.
>>
>> That one would be handled by omap separately.
> 
> OK great.
>  
>>> 3. The serial PM features must be only enabled if requested by
>>>    the user via sysfs. Typically extra latency and loss of the
>>>    first RX character occur which is not acceptable to most
>>>    applications.
>>
>> Unless I'm mistaken the omap driver now initializes the timeout to -1.
>> So nothing happens unless this is enabled separately.
> 
> Yes that's the only safe approach so the serial port behaves in
> the standard Linux way unless specifically requested by the
> user.
> 
> Regards,
> 
> Tony

Sebastian
