Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681Ab3BNKFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:05:15 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42806 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3BNKFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:05:13 -0500
Date: Thu, 14 Feb 2013 10:04:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: anish singh <anish198519851985@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        viro@zeniv.linux.org.uk, rusty@rustcorp.com.au, hpa@linux.intel.com,
        jim.cromie@gmail.com, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        broonie@opensource.wolfsonmicro.com,
        Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH] driver core: add wait event for deferred probe
Message-ID: <20130214100452.GF17833@n2100.arm.linux.org.uk>
References: <1360429077-14616-1-git-send-email-haojian.zhuang@linaro.org> <20130213213624.079BA3E3557@localhost> <CAK7N6voJJ_g_LLmKdd=95fQOQPaTvQbs3HJsKJoPcrDUyUWxaA@mail.gmail.com> <201302140956.36843.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302140956.36843.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 09:56:36AM +0000, Arnd Bergmann wrote:
> I would put it this way: With the introduction of deferred probing, the
> rules for the use of __init sections have changed slightly for some
> corner cases. While normal device drivers can, as before, not call
> __init functions from their .probe() callbacks, we could do that in
> drivers as long as they were built-in and did not support hotplug,
> and that exception was used in console drivers. This exception has
> now become more specific, and those drivers also must not use
> deferred probing that depends on other loadable modules or hotpluggable
> devices.

In the general case, that remains true, but it's still _not_ true for
console drivers.

The console _should_ be initialised before it is attempted to be opened
before passing control to userspace, which happens before the .init
section is freed.

If the console is deferred past that point, then userspace has no console.
The behaviour of userspace in that situation can be very interesting, and
I'd suggest that such is not well tested; consider the effect of not
having fd 0,1,2 connected to something like a console but your filesystem
and something doing a printf().  You can hope that userspace will take
care of that condition, but I personally would not put much faith in it.

With the plethora of 'init' daemon solutions we now have, I have less
faith than I used to that such a condition would be correctly handled
by all of them.
