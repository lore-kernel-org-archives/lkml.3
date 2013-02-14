Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642Ab3BNJ5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:57:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64378 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3BNJ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:57:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: anish singh <anish198519851985@gmail.com>
Subject: Re: [PATCH] driver core: add wait event for deferred probe
Date: Thu, 14 Feb 2013 09:56:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        viro@zeniv.linux.org.uk, rusty@rustcorp.com.au, hpa@linux.intel.com,
        jim.cromie@gmail.com, linux-kernel@vger.kernel.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        broonie@opensource.wolfsonmicro.com,
        Patch Tracking <patches@linaro.org>
References: <1360429077-14616-1-git-send-email-haojian.zhuang@linaro.org> <20130213213624.079BA3E3557@localhost> <CAK7N6voJJ_g_LLmKdd=95fQOQPaTvQbs3HJsKJoPcrDUyUWxaA@mail.gmail.com>
In-Reply-To: <CAK7N6voJJ_g_LLmKdd=95fQOQPaTvQbs3HJsKJoPcrDUyUWxaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302140956.36843.arnd@arndb.de>
X-Provags-ID: V02:K0:XUNUpKHEzVzOc0w3Tn59OPFN0Kj6pfTOW17GvTu3Mj6
 Yno2rlmMMzUb86as2s3Qb6z9XG8TMEMLaxaAjWUuNdifUOkr0Q
 u8hOcD+PLPZC9tYTqfUub1RujlGz3MCT0goGuIwZcEpAKvRpjW
 GrEOmW5G907uVafDPdYnfHLGZDxNFp8yuTskJlWM+LSR/KUj69
 yWzIWqZif+M8R4J53bV0WvSSlxYwQEsz0HX+Aq7qCZrbzryykx
 Z3mqvDWOSmVYqKogoZudQISxVdHy/hhnjUrwnU/QPqEcDprDYD
 +/L3tU6nxT34s79iqnbFfCtzIsRARH3Tm2rDJ40UP50DJf/f+z
 iVCa1edZWkM0NJR0FhFY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2013, anish singh wrote:
> Grant, Can you please explain me this problem?My understanding is below:
> If all the detection of devices with there respective driver is done before
> __init section is freed then we will not have the problem mentioned.
> However if the driver requests the probing to be deferred then __init section
> of the deferred driver will not be freed right?

The kernel has no idea which drivers are deferred at the time when all the
__init sections are freed.

> I am afraid but the patch description is bit cryptic for me specially
> this line "kernel has to open console failure & release __init section before
> reinvoking failure".

I would put it this way: With the introduction of deferred probing, the
rules for the use of __init sections have changed slightly for some
corner cases. While normal device drivers can, as before, not call
__init functions from their .probe() callbacks, we could do that in
drivers as long as they were built-in and did not support hotplug,
and that exception was used in console drivers. This exception has
now become more specific, and those drivers also must not use
deferred probing that depends on other loadable modules or hotpluggable
devices.

Grant's patch fixes the corner case where you have a device whose .probe()
callback gets deferred and waits for some object that is provided
by a different built-in driver for a non-hotpluggable device, by making
sure that this particular deferred probe has completed before the __init
section is freed. Unlike Haojian's patch, it allows other deferred
device probe functions that do not need to call __init functions to be
delayed until much later, when a driver module is loaded or a device
is hotplugged.

	Arnd
