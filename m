Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaJIKbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:31:11 -0400
Received: from lists.s-osg.org ([54.187.51.154]:40052 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaJIKbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:31:00 -0400
Date: Thu, 9 Oct 2014 07:30:52 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 8 (media/usb/gspca)
Message-ID: <20141009073052.0ddc3e97@recife.lan>
In-Reply-To: <1412837128.21441.9.camel@x220>
References: <20141008174923.76786a03@canb.auug.org.au>
	<543570C3.9080207@infradead.org>
	<20141008153105.2fe82fca@recife.lan>
	<5435A44D.2050609@infradead.org>
	<20141008225011.2d034c1e@recife.lan>
	<1412837128.21441.9.camel@x220>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 09 Oct 2014 08:45:28 +0200
Paul Bolle <pebolle@tiscali.nl> escreveu:

> On Wed, 2014-10-08 at 22:50 -0300, Mauro Carvalho Chehab wrote:
> > Em Wed, 08 Oct 2014 13:53:33 -0700
> > Randy Dunlap <rdunlap@infradead.org> escreveu:
> > > On 10/08/14 11:31, Mauro Carvalho Chehab wrote:
> > > > From gpsca's PoV, IMHO, it should be fine to disable the webcam buttons if
> > > > the webcam was compiled as builtin and the input subsystem is compiled as 
> > > > module. The core feature expected on a camera is to capture streams. 
> > > > Buttons are just a plus.
> > > > 
> > > > Also, most cams don't even have buttons. The gspca subdriver has support 
> > > > for buttons for the few models that have it.
> > > > 
> > > > So, IMHO, it should be ok to have GSPCA=y and INPUT=m, provided that 
> > > > the buttons will be disabled.
> > > 
> > > Then all of the sub-drivers that use IS_ENABLED(CONFIG_INPUT) should be
> > > changed to use IS_BUILTIN(CONFIG_INPUT).
> > > 
> > > But that is too restrictive IMO.  The input subsystem will work fine when
> > > CONFIG_INPUT=m and the GSPCA drivers are also loadable modules.
> > 
> > Agreed.
> > 
> > Maybe the solution would be something more complex like 
> > (for drivers/media/usb/gspca/zc3xx.c):
> > 
> > #if (IS_BUILTIN(CONFIG_INPUT)) || (IS_ENABLED(CONFIG_INPUT) && !IS_BUILTIN(CONFIG_USB_GSPCA_ZC3XX))
> 
> The above discussion meanders a bit, and I just stumbled onto it, but
> would
>     #if IS_BUILTIN(CONFIG_INPUT) || (IS_MODULE(CONFIG_INPUT) && defined(MODULE))
> 
> cover your requirements when using macros?

No. What we need to do, for all gspca sub-drivers that have optional
support for buttons is to only enable the buttons support if:

	CONFIG_INPUT=y
or
	CONFIG_INPUT=m and CONFIG_USB_GSPCA_submodule=m

If we use a reverse logic, we need to disable the code if:
	# CONFIG_INPUT is not set
or
	CONFIG_INPUT=m and CONFIG_USB_GSPCA_submodule=y

The rationale for disabling the code on the last expression is that a
builtin code cannot call a function inside a module.

Also, as the submodule is already being compiled, we know that
CONFIG_USB_GSPCA_submodule is either module or builtin.

So, either one of those expressions should work:
	#if (IS_BUILTIN(CONFIG_INPUT)) || (IS_ENABLED(CONFIG_INPUT) && !IS_BUILTIN(CONFIG_USB_GSPCA_submodule))
or
	#if (IS_BUILTIN(CONFIG_INPUT)) || (IS_MODULE(CONFIG_INPUT) && IS_MODULE(CONFIG_USB_GSPCA_submodule) && defined(MODULE))
or
	#if (IS_BUILTIN(CONFIG_INPUT)) || (IS_ENABLED(CONFIG_INPUT) && IS_MODULE(CONFIG_USB_GSPCA_submodule))

> 
> > Probably the best would be to write another macro that would evaluate
> > like the above.
> 
> 
> Paul Bolle
> 
