Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbaEOUvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:51:44 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56717 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaEOUvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:51:42 -0400
Date: Thu, 15 May 2014 21:50:20 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/6] watchdog: Add API to trigger reboots
Message-ID: <20140515215020.38f03ab1@alan.etchedpixels.co.uk>
In-Reply-To: <1400186304-1691-2-git-send-email-linux@roeck-us.net>
References: <1400186304-1691-1-git-send-email-linux@roeck-us.net>
	<1400186304-1691-2-git-send-email-linux@roeck-us.net>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +void watchdog_do_reboot(void)
> +{
> +	if (wdd_reboot_dev)
> +		wdd_reboot_dev->ops->reboot(wdd_reboot_dev);
> +}
> +EXPORT_SYMBOL(watchdog_do_reboot);

Crashes and burns if you are unloading a watchdog just as you try to
reboot. Yes its wildly unlikely but it's still conceptually wrong.

>  
> +	if (wdd->ops->reboot)
> +		wdd_reboot_dev = wdd;
> +

Two parallel registers from different bus types, parallel
register/unregister ?

This feels to me like a backward step. We've gone from various device
bits leaking into the core code (where they can work all the time) to
various core code leaking into the devices which is asking for init order
problems and other races.

Given we are talking about stuff of the order of 10-20 instructions I
think duplication is not only the lesser evil it's also smaller, more
reliable and easier to maintain.

IMHO this is a solution looking for a problem.

Alan
