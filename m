Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbaJUMFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:05:47 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56331 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755281AbaJUMFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:05:46 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Philippe =?ISO-8859-1?Q?R=E9tornaz?= 
	<philippe.retornaz@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v2 01/47] kernel: Add support for poweroff handler call chain
Date: Tue, 21 Oct 2014 14:26:10 +0200
Message-ID: <41603148.RJg26vx0Wv@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413864783-3271-2-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net> <1413864783-3271-2-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 20, 2014 09:12:17 PM Guenter Roeck wrote:
> Various drivers implement architecture and/or device specific means to
> remove power from the system.  For the most part, those drivers set the
> global variable pm_power_off to point to a function within the driver.
> 
> This mechanism has a number of drawbacks.  Typically only one scheme
> to remove power is supported (at least if pm_power_off is used).
> At least in theory there can be multiple means remove power, some of
> which may be less desirable. For example, some mechanisms may only
> power off the CPU or the CPU card, while another may power off the
> entire system.  Others may really just execute a restart sequence
> or drop into the ROM monitor. Using pm_power_off can also be racy
> if the function pointer is set from a driver built as module, as the
> driver may be in the process of being unloaded when pm_power_off is
> called. If there are multiple poweroff handlers in the system, removing
> a module with such a handler may inadvertently reset the pointer to
> pm_power_off to NULL, leaving the system with no means to remove power.
> 
> Introduce a system poweroff handler call chain to solve the described
> problems.  This call chain is expected to be executed from the
> architecture specific machine_power_off() function.  Drivers providing
> system poweroff functionality are expected to register with this call chain.
> By using the priority field in the notifier block, callers can control
> poweroff handler execution sequence and thus ensure that the poweroff
> handler with the optimal capabilities to remove power for a given system
> is called first.

Well, I must admit to having second thoughts regarding this particular
mechanism.  Namely, notifiers don't seem to be the best way of expressing
what's needed from the design standpoint.

It looks like we need a list of power off methods and a way to select one
of them, so it seems that using a plist would be a natural choice here?

Rafael

