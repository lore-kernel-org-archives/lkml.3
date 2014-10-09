Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaJILwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 07:52:21 -0400
Received: from lists.s-osg.org ([54.187.51.154]:40070 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaJILwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 07:52:13 -0400
Date: Thu, 9 Oct 2014 08:52:07 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 8 (media/usb/gspca)
Message-ID: <20141009085207.70d6b1d1@recife.lan>
In-Reply-To: <1412853970.21441.32.camel@x220>
References: <20141008174923.76786a03@canb.auug.org.au>
	<543570C3.9080207@infradead.org>
	<20141008153105.2fe82fca@recife.lan>
	<5435A44D.2050609@infradead.org>
	<20141008225011.2d034c1e@recife.lan>
	<1412837128.21441.9.camel@x220>
	<20141009073052.0ddc3e97@recife.lan>
	<1412853970.21441.32.camel@x220>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 09 Oct 2014 13:26:10 +0200
Paul Bolle <pebolle@tiscali.nl> escreveu:

> On Thu, 2014-10-09 at 07:30 -0300, Mauro Carvalho Chehab wrote:
> > Em Thu, 09 Oct 2014 08:45:28 +0200
> > Paul Bolle <pebolle@tiscali.nl> escreveu:
> > > The above discussion meanders a bit, and I just stumbled onto it, but
> > > would
> > >     #if IS_BUILTIN(CONFIG_INPUT) || (IS_MODULE(CONFIG_INPUT) && defined(MODULE))
> > > 
> > > cover your requirements when using macros?
> > 
> > No. What we need to do, for all gspca sub-drivers that have optional
> > support for buttons is to only enable the buttons support if:
> > 
> > 	CONFIG_INPUT=y
> > or
> > 	CONFIG_INPUT=m and CONFIG_USB_GSPCA_submodule=m
> > 
> > If we use a reverse logic, we need to disable the code if:
> > 	# CONFIG_INPUT is not set
> > or
> > 	CONFIG_INPUT=m and CONFIG_USB_GSPCA_submodule=y
> > 
> > The rationale for disabling the code on the last expression is that a
> > builtin code cannot call a function inside a module.
> > 
> > Also, as the submodule is already being compiled, we know that
> > CONFIG_USB_GSPCA_submodule is either module or builtin.
> > 
> > So, either one of those expressions should work:
> > 	#if (IS_BUILTIN(CONFIG_INPUT)) || (IS_ENABLED(CONFIG_INPUT) && !IS_BUILTIN(CONFIG_USB_GSPCA_submodule))
> > or
> > 	#if (IS_BUILTIN(CONFIG_INPUT)) || (IS_MODULE(CONFIG_INPUT) && IS_MODULE(CONFIG_USB_GSPCA_submodule) && defined(MODULE))
> 
> I thought MODULE was only defined for code that will be part of a
> module. So "IS_MODULE(CONFIG_USB_GSPCA_submodule)" and "defined(MODULE)"
> should be equal when used _inside_ [...]/usb/gspca/that_submodule.c,

Ah, I didn't know that. In such case, your suggestion is indeed better,
as it is easier to write the patch.

> shouldn't they? That would make this option basically identical to my
> suggestion. Or are you thinking about using these tests outside of these
> submodules themselves?

> 
> > or
> > 	#if (IS_BUILTIN(CONFIG_INPUT)) || (IS_ENABLED(CONFIG_INPUT) && IS_MODULE(CONFIG_USB_GSPCA_submodule))
> 
> I think it's clearer to use
>     IS_BUILTIN(CONFIG_FOO) || (IS_MODULE(CONFIG_FOO) && [...])
> 
> Ditto above. Perhaps just a matter of taste.
> 
> (Depending on INPUT is apparently not possible for these submodules. 

No, because the main functionality (webcam support) doesn't depend on
INPUT.

> So
> obviously any solution needs to check whether input is available, say
> like
>     if (IS_MODULE(CONFIG_INPUT))
>         if (!is_input_loaded())
>             goto no_input;
> 
> Doesn't it?)

Yeah, but the thing is that it breaks at compilation time, because
the builtin module would try to use some symbols that are defined only
at runtime.

So, the above won't solve the issue.

One possibility for future Kernels would be to add some logic that would
automatically load the module if a call to one of those symbols defined
inside a module happens inside a builtin module.

The DVB subsystem actually does that for I2C frontend drivers, 
using those macros:

#define dvb_attach(FUNCTION, ARGS...) ({ \
	void *__r = NULL; \
	typeof(&FUNCTION) __a = symbol_request(FUNCTION); \
	if (__a) { \
		__r = (void *) __a(ARGS); \
		if (__r == NULL) \
			symbol_put(FUNCTION); \
	} else { \
		printk(KERN_ERR "DVB: Unable to find symbol "#FUNCTION"()\n"); \
	} \
	__r; \
})

#define dvb_detach(FUNC)	symbol_put_addr(FUNC)

The above works reasonably fine when there's just one symbol needed
from the module driver.

There are, however, some issues with such approach:

1) as symbol_request increments refcount, this works very badly when
   there's more than one symbol needed, as symbol_put() would need
   to be called as many times as symbol_request() is called;

2) lsmod doesn't list what module is actually requesting such symbol
   (if the caller is also a module). It just increments refcounting.
    There were some patches meant to fix that, send a long time ago,
    but were never merged. Can't remember why:
	http://linuxtv.org/pipermail/linux-dvb/2006-August/012322.html

Due to the above issues, and because we want to better use the I2C
binding model, we're currently trying to get rid of such approach for
the DVB subsystem, but there are too many changes to get rid of it.
So, the migration is slow.

Anyway, IMHO, having such sort of logic would help to solve the issues
with some weird configs like INPUT=m.

Regards,
Mauro
