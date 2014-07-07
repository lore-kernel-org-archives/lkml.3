Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaGGVO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 17:14:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaGGVO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 17:14:56 -0400
Date: Mon, 7 Jul 2014 14:14:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] kernel: Add support for restart notifier call
 chain
Message-Id: <20140707141454.3ca1e2fc2e6a4c985d7d2f35@linux-foundation.org>
In-Reply-To: <1404689900-27421-2-git-send-email-linux@roeck-us.net>
References: <1404689900-27421-1-git-send-email-linux@roeck-us.net>
	<1404689900-27421-2-git-send-email-linux@roeck-us.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  6 Jul 2014 16:38:14 -0700 Guenter Roeck <linux@roeck-us.net> wrote:

> Various drivers implement architecture and/or device specific means
> to restart (reset) the system. Various mechanisms have been implemented
> to support those schemes. The best known mechanism is arm_pm_restart,
> which is a function pointer to be set either from platform specific code
> or from drivers. Another mechanism is to use hardware watchdogs to issue
> a reset; this mechanism is used if there is no other method available
> to reset a board or system. Two examples are alim7101_wdt, which currently
> uses the reboot notifier to trigger a reset, and moxart_wdt, which registers
> the arm_pm_restart function.
> 
> The existing mechanisms have a number of drawbacks. Typically only one scheme
> to restart the system is supported (at least if arm_pm_restart is used).
> At least in theory there can be mutliple means to restart the system, some of
> which may be less desirable (for example one mechanism may only reset the CPU,
> while another may reset the entire system). Using arm_pm_restart can also be
> racy if the function pointer is set from a driver, as the driver may be in
> the process of being unloaded when arm_pm_restart is called.
> Using the reboot notifier is always racy, as it is unknown if and when
> other functions using the reboot notifier have completed execution
> by the time the watchdog fires.
> 
> To solve the problem, introduce a system restart notifier. This notifier
> is expected to be called from the architecture specific machine_restart()
> function. Drivers providing system restart functionality (such as the watchdog
> drivers mentioned above) are expected to register with this notifier.

It all looks sane to my unfamiliar eye.

>  /*
> + *	Notifier list for kernel code which wants to be called
> + *	to restart the system.
> + */

hm, is this all we have to say?

> --- a/kernel/reboot.c
> +++ b/kernel/reboot.c
> @@ -104,6 +104,38 @@ int unregister_reboot_notifier(struct notifier_block *nb)
>  }
>  EXPORT_SYMBOL(unregister_reboot_notifier);
>  
> +/**
> + *	register_restart_notifier - Register function to be called to reset
> + *				    the system
> + *	@nb: Info about notifier function to be called
> + *
> + *	Registers a function with the list of functions
> + *	to be called to restart the system.
> + *
> + *	Currently always returns zero, as blocking_notifier_chain_register()
> + *	always returns zero.
> + */

This would be a good place to describe what those notifier callbacks
actually do.  Why they exist, what their role is, under what
circumstances they are called, what values they should return, etc.


