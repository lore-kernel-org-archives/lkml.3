Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaAPRWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:22:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbaAPRWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:22:16 -0500
Date: Thu, 16 Jan 2014 09:22:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, jslaby@suse.cz
Subject: Re: [PATCH] tty: Fallback to use dynamic major number
Message-ID: <20140116172240.GB9587@kroah.com>
References: <1389848602-30985-1-git-send-email-tushar.behera@linaro.org>
 <20140116161841.GA7476@kroah.com>
 <20140116170814.GI17314@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116170814.GI17314@sirena.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 05:08:14PM +0000, Mark Brown wrote:
> On Thu, Jan 16, 2014 at 08:18:41AM -0800, Greg KH wrote:
> > On Thu, Jan 16, 2014 at 10:33:22AM +0530, Tushar Behera wrote:
> > > In a multi-platform scenario, the hard-coded major/minor numbers in
> > > serial drivers may conflict with each other. A typical scenario is
> > > observed with amba-pl011 and samsung-uart drivers, both of these
> > > drivers use same set of major/minor numbers. If both of these drivers
> > > are enabled, probe of samsung-uart driver fails because the desired
> > > node is busy.
> 
> > Why would both drivers ever be loaded at the same time?  Don't they bind
> > to different hardware devices, and as such, never will be in the same
> > system?
> 
> No, the issue is happening because the drivers are registering things
> at module load time and not at device instantiation time.

That's a driver bug that could easily be fixed, instead of hacking up
the tty core :)

> While the drivers won't actually be run together things like the
> multiplatform defconfig and distro configs will build them in since
> people tend to like to get serial early on.

Build them into the kernel and not as modules?

> > The driver shouldn't be registering it's tty devices if the hardware
> > isn't present in the system, so how can this codepath ever happen?
> 
> A quick and unscientific poll of serial drivers seems to suggest that
> uart_register_driver() is normally called when the module is loaded (if
> it shouldn't be this is at least a very common error pattern).

It's a common error pattern :)

> > > The issue is fixed by adding a fallback in driver core, so that we can
> > > use dynamic major number in case device node allocation fails for
> > > hard-coded major/minor number.
> 
> > Did you test this out?  You still get userspace breakage with it :(
> 
> Yes.  I should put my hands up and say that this was my idea.  The
> theory is that any system using static allocation for a device shouldn't
> be affected (modulo races, it's not perfect obviously), any currently
> broken system with a userspace with a dynamic dev will start working and
> any breakage is confined to drivers which duplicated major numbers (and
> even then only on systems with static /dev).
> 
> The other solutions I can think of are moving tty_register_driver() to
> device probe time, allowing tty_register_driver() to accept duplicate
> majors and the complaining when the devices actually get instantiated
> or changing major numbers where there is a duplicate which is guaranteed
> to break at least some userspaces with static devices (which was the
> original patch you complained about).  The first two solutions look a
> bit fun though perhaps they fall out more easily than I suspect.

How about fixing the drivers as I mentioned above, to not register with
the uart or tty core until they know that their hardware is actually
present in the system?  That would keep any tty core "hacks" from being
needed.

thanks,

greg k-h
