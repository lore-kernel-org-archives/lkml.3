Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbaLOV6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:58:40 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50264 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751034AbaLOV6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:58:35 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ARM: at91: fix irq_pm_install_action WARNING
Date: Mon, 15 Dec 2014 23:20:17 +0100
Message-ID: <2662748.NJbkr6jW7r@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 15, 2014 05:15:47 PM Boris Brezillon wrote:
> Commit cab303be91dc47942bc25de33dc1140123540800 [1] introduced a WARN_ON
> test which triggers a WARNING backtrace on at91 platforms.

Pretty much as intended.

> While this WARN_ON is absolutely necessary to warn users that they should
> not mix request with and without IRQF_NO_SUSPEND flags on shared IRQs,
> there is no easy way to solve this issue on at91 platforms.
> 
> The main reason is that the init timer is often using a shared irq line
> and thus request this irq with IRQF_NO_SUSPEND flag set, while other
> peripherals request the same irq line without this flag.
> 
> We could deal with that by identifying whether a given peripheral is
> connected to the init timer shared irq line and add the IRQF_NO_SUSPEND
> in this case, but this implies adding the logic in all peripheral drivers
> that could be connected to this shared irq.
> 
> This series takes the reverse approach: force IRQ users to specify that
> they take care of disabling peripheral interrupts and that IRQ core can
> safely leave the handler in a suspended state without having to bother
> about spurious interrupts.
> This is done by mean of a new IRQF_SUSPEND_NOACTION flag which tells the
> core to move the action handler to a suspended list, thus preventing its
> execution when we are in suspend mode.
> Of course, specifying the IRQF_SUSPEND_NOACTION flag implies taking care
> of masking/unmasking the peripheral interrupts in the suspend/resume
> implementation.

Well, I'm not sure how much value is in all that to be honest.  The only
thing it helps with is to make the WARN_ON go away in some cases, while
the drivers in question need to make sure that they disable their interrupts
properly anyway, so what exactly is the purpose of the new irqaction
shuffling?

It might just be simpler to add a flag to suppress the WARN_ON that would be
set by the user of IRQF_NO_SUSPEND that is broken enough to have to share the
interrupt with others ...


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
