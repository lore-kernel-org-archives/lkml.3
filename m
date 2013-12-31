Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab3LaSDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 13:03:40 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:58144 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab3LaSDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 13:03:39 -0500
MIME-Version: 1.0
In-Reply-To: <20131228204039.GA19982@spo001.leaseweb.com>
References: <1385160964-18578-1-git-send-email-markus.mayer@linaro.org>
	<20131228204039.GA19982@spo001.leaseweb.com>
Date: Tue, 31 Dec 2013 10:03:37 -0800
Message-ID: <CAPdLdqkNtvPwETc+TK9xRSh-ru6q4VvUk7zfYEbjPb1TOESMaA@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] watchdog: bcm281xx: Watchdog Driver
From: Markus Mayer <markus.mayer@linaro.org>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Guenter Roeck <linux@roeck-us.net>, Christian Daudt <bcm@fixthebug.org>,
        Linaro Patches <patches@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

Thanks for your comments. I addressed them and will be sending out the
resulting patches shortly.

> Questions/remarks I still have:
> 1) *debugfs is defined in the bcm_kona_wdt struct, but busy_count isn't.
>    Seems odd to me. What's the reason?

secure_register_read() only took a void __iomem * argument, but I
changed that to struct bcm_kona_wdt * and offset. With that change,
busy_count can be part of struct bcm_kona_wdt.

> 2) I don't like the #ifdef pieces in the probe and remove functions.
>    The preferred method is to not have the #ifdefs there, but to have an
>    init and exit function that is defined in a similar way:

I took care of those. However I opted to pass a struct platform_device
* to the new functions bcm_kona_wdt_debug_init() and
bcm_kona_wdt_debug_exit(). The reason being that bcm_kona_wdt_remove()
didn't have a struct bcm_kona_wdt * outside the #ifdef that I was
about to remove. For consistency, I then used struct platform_device *
for bcm_kona_wdt_debug_init(), as well.

>         #ifdef CONFIG_BCM_KONA_WDT_DEBUG
>         ...
>         static void bcm_kona_wdt_debug_init(struct bcm_kona_wdt *wdt)
>         {
>                 wdt->debugfs = bcm_kona_wdt_debugfs_init(wdt, &bcm_kona_wdt_wdd);
>         }
>         ...
>         #else /* !CONFIG_BCM_KONA_WDT_DEBUG */
>         static void bcm_kona_wdt_debug_init(struct bcm_kona_wdt *wdt) {}
>         ...
>         #endif /* CONFIG_BCM_KONA_WDT_DEBUG */

Now I have a question (or rather a comment) of my own. I noticed that
you "squashed" my two original patches into a single patch before
breaking out the debugfs related code. The side-effect of this was
that two lines of my bcm_defconfig change (CONFIG_WATCHDOG=y and
CONFIG_BCM_KONA_WDT=y) were included in the patch you took into
linux-watchdog-next.

If I understand correctly (and this is why I had broken out the
bcm_defconfig change into a separate patch), a defconfig change would
normally go through the platform maintainer's tree, in this case
Christian, whereas the actual driver would go upstream through your
tree.

I don't think it makes too much of a difference with regards to this
driver where the defconfig change goes. In fact, taking it all through
one tree might even be slightly easier and reduce the chance of
conflicts, but I still think Christian needs to at least be aware of
this change going through the watchdog tree. He owns bcm_defconfig,
after all.

A loosely related comment: gitweb for linux-watchdog-next seems to be
broken: http://www.linux-watchdog.org/cgi-bin/gitweb.cgi?p=linux-watchdog-next.git;a=summary.
I stumbled upon this yesterday when I was trying to look at the
current status of this tree.

In case readers of this e-mail are interested in taking a quick peek
at the parts of the Kona watchdog driver that were already accepted,
without cloning the entire repo, I created a temporary watchdog mirror
with the commit in question available for in-browser viewing at
http://git.linaro.org/people/markus.mayer/watchdog-next-mirror.git/commit/bd90ccd42c5d6317979c62919ba1c79fd34fa785

Regards,
-Markus

-- 
Markus Mayer
Broadcom Landing Team
