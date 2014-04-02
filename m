Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbaDBMOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 08:14:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55550 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758614AbaDBMOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 08:14:46 -0400
Date: Wed, 2 Apr 2014 13:14:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Alessandro Gardich <gremlin@gremlin.it>,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: [PATCH] RFC: MFD: driver for Atmel Microcontroller on iPaq h3xxx
Message-ID: <20140402121440.GF18518@lee--X1>
References: <1391175275-27347-1-git-send-email-linus.walleij@linaro.org>
 <20140217092155.GB17875@lee--X1>
 <CACRpkdZ5YQoV3zxXiF5H-nxf-Kz_YiETvLsbJ9pkT=ueZ=VJSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZ5YQoV3zxXiF5H-nxf-Kz_YiETvLsbJ9pkT=ueZ=VJSQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Does it matter that you're using:
> >
> >   module_platform_driver();
> >
> > ... yet you can't build this as a module?
> 
> I think it's a conceptual thing. Module means two things (IIUC):
> (a) it is a run-time loadable module
> (b) it's a piece of compartmentalized code
> 
> In this case the macro refers to (b). module_platform_driver()
> resolves to module_driver() from <linux/device.h>
> and it's clearly a core part of the device core and available
> no matter whether the file is used as module at runtime or not.
> It just simplifies the initcalls and that's no different depending
> on whether the code is compiled-in or used as module.

Fair enough.

> >> +     case MSG_KEYBOARD:
> >> +             if (micro->key != NULL)
> >
> > !micro->key
> 
> I guess you mean if (micro->key) {} rather than the !invert,
> but I get it, changed everywhere we check for != NULL like this.

Yes sorry, I'm so used to seeing (thing == NULL), but you knew what I
meant.

[...]

> >> +static int micro_suspend(struct device *dev)
> >> +{
> >> +     return 0;
> >> +}
> >
> > Doesn't the PM framework check for NULL .suspend?
> 
> No it's just like:
> 
> #ifdef CONFIG_SUSPEND
>         case PM_EVENT_SUSPEND:
>                 return ops->suspend;
>         case PM_EVENT_RESUME:
>                 return ops->resume;
> #endif /* CONFIG_SUSPEND */
> 
> (drivers/power/main.c)

  base/ ---^

Right, but a NULL return _is_ valid from here and is subsequently dealt
with in the correct way.

[...]
        callback = pm_op(dev->type->pm, state);
        goto Driver;

[...]

Driver:
       if (!callback && dev->driver && dev->driver->pm) {
               info = "driver ";
               callback = pm_op(dev->driver->pm, state);
       }
[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
