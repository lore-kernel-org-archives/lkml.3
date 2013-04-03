Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3DCEVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 00:21:36 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65358 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab3DCEVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 00:21:35 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 2 Apr 2013 21:21:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Tony Chung <tonychung00@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] watchdog: fix w83627hf_wdt clear timeout expired
Message-ID: <20130403042142.GA3640@roeck-us.net>
References: <1364795972-8649-1-git-send-email-tonychung00@gmail.com>
 <1364795972-8649-2-git-send-email-tonychung00@gmail.com>
 <20130402000741.GA4077@roeck-us.net>
 <CAHyaeP1ExzMr8_KvSrmf6+urVROEHRePs_KA3CZ3bnU6Ov79LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHyaeP1ExzMr8_KvSrmf6+urVROEHRePs_KA3CZ3bnU6Ov79LQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 09:59:00PM -0700, Tony Chung wrote:
> Thanks Guenter!
> I agree with you.  My first reaction was also about a small watchdog
> server that will start in early boot process.  There are pros and
> cons.   For example, there are many types of watchdog devices such as
> ipmi_watchdog which can accept more than  255 seconds for timeout. So
> you really need udev to pick the correct watchdog driver.  It could be
> very complex.
> 
> Our requirement don't need watchdog protection during the boot process
> until application is fully up but a driver should not assume anything.

Ok, but then the BIOS should not enable the watchdog.

>  Anyway, an unexpected reboot is definitely a bug that need to be
> fixed.   It is really easily reproducible.  Depending on your hardware

Agreed.

> and BIOS settings, just reboot the boot, wait for 5 minutes and then
> run "insmod w83627hf_wdt.ko".  The box just reboot by itself.  The
> watchdog sever is not even started.
> 
Doesn't happen for me, as the watchdog is initially not enabled in my system,
and bit 4 is never set. And when it gets set, the system immediately reboots.

> This line is actually the original fix that is running over a year:
>     outb_p(0, WDT_EFDR);    /* disable to prevent reboot */
> 
Unfortunately this turns off the watchdog if it was running and has triggered.

> When I tried to cleanup it up,  I thought I don't need it but it
> turned out it was still needed.
> When I changed it from 0xC0 to 0xD0, it still reboot.
> 
So it looks like the watchdog triggered, for some reason did not cause
a reset, but resetting the trigger flag does.

Ultimately, the new code turns the watchdog off if it was running, has already
triggered, but did not cause a reset. The ultimate effect is that the system
will hang if it gets stuck before the watchdog application is started later on.
Maybe that is not your application, but others wil defintely want that
protection.

So I don't think the solution is correct. We should find out why the watchdog
trigger did not cause a reset. Also, I think it would be better in this
situation (if watchdog has triggered) to restart it with the default timeout.

What is the exact chip type in your system ? I want to have a look into the
datasheet; maybe I can find out how it can trigger without causing a reset.

Thanks,
Guenter
