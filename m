Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbaJUMlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:41:04 -0400
Received: from gloria.sntech.de ([95.129.55.99]:54499 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423AbaJUMlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:41:01 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Lee Jones <lee.jones@linaro.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Philippe =?ISO-8859-1?Q?R=E9tornaz?= 
	<philippe.retornaz@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v2 01/47] kernel: Add support for poweroff handler call chain
Date: Tue, 21 Oct 2014 14:44 +0200
Message-ID: <1752920.2kdbbr5GW9@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <41603148.RJg26vx0Wv@vostro.rjw.lan>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net> <1413864783-3271-2-git-send-email-linux@roeck-us.net> <41603148.RJg26vx0Wv@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 21. Oktober 2014, 14:26:10 schrieb Rafael J. Wysocki:
> On Monday, October 20, 2014 09:12:17 PM Guenter Roeck wrote:
> > Various drivers implement architecture and/or device specific means to
> > remove power from the system.  For the most part, those drivers set the
> > global variable pm_power_off to point to a function within the driver.
> > 
> > This mechanism has a number of drawbacks.  Typically only one scheme
> > to remove power is supported (at least if pm_power_off is used).
> > At least in theory there can be multiple means remove power, some of
> > which may be less desirable. For example, some mechanisms may only
> > power off the CPU or the CPU card, while another may power off the
> > entire system.  Others may really just execute a restart sequence
> > or drop into the ROM monitor. Using pm_power_off can also be racy
> > if the function pointer is set from a driver built as module, as the
> > driver may be in the process of being unloaded when pm_power_off is
> > called. If there are multiple poweroff handlers in the system, removing
> > a module with such a handler may inadvertently reset the pointer to
> > pm_power_off to NULL, leaving the system with no means to remove power.
> > 
> > Introduce a system poweroff handler call chain to solve the described
> > problems.  This call chain is expected to be executed from the
> > architecture specific machine_power_off() function.  Drivers providing
> > system poweroff functionality are expected to register with this call
> > chain. By using the priority field in the notifier block, callers can
> > control poweroff handler execution sequence and thus ensure that the
> > poweroff handler with the optimal capabilities to remove power for a
> > given system is called first.
> 
> Well, I must admit to having second thoughts regarding this particular
> mechanism.  Namely, notifiers don't seem to be the best way of expressing
> what's needed from the design standpoint.
> 
> It looks like we need a list of power off methods and a way to select one
> of them, so it seems that using a plist would be a natural choice here?

I actually like Guenter's approach of traversing a sorted list of poweroff 
methods until one of them really turns off the device.


For example, one device I work on has this strange mechanism where the device 
stays powered on while either a gpio is high or the device is connected to a 
host via usb - it cannot be turned off at all while it is connected via usb.

So the established way of handling poweroff there is to check the usb 
connection and either shutdown or restart [where the bootloader will enter a 
charging cycle and really poweroff the device once it gets disconnected].

If there is only one method to shutdown possible this device-specific behaviour 
would need to be encoded in some sort of poweroff driver, while with Guenter's 
current approach I could just register the gpio-poweroff at a higher priority 
which would then fall down to the lower priority restart if the device stays 
powered due to the usb connection.


Heiko
