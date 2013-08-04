Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3HDXSl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 19:18:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58830 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3HDXSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 19:18:40 -0400
Date: Mon, 5 Aug 2013 07:19:58 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bob Smith <bsmith@linuxtoys.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a
 /sys-like interface
Message-ID: <20130804231958.GA25418@kroah.com>
References: <51FC5478.40500@linuxtoys.org>
 <51FC5A97.1090102@linuxtoys.org>
 <20130803223828.GA14611@kroah.com>
 <51FECDA6.5070001@linuxtoys.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FECDA6.5070001@linuxtoys.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 04, 2013 at 02:54:46PM -0700, Bob Smith wrote:
> >>+Proxy has some unique features that make ideal for providing a
> >>+/sys like interface.  It has no internal buffering.  The means
> >>+the daemon can not write until a client program is listening.
> >>+Both named pipes and pseudo-ttys have internal buffers.
> >
> >So what is wrong with internal buffers?  Named pipes have been around
> >for a long time, they should be able to be used much like this, right?
> Buffers are great for streaming data but are unneeded for
> configuration and status information.  Neither sysfs or procfs
> have internal buffers because they are not needed.

That's because they have a "consumer" at all times already, the kernel
itself.  And there is a buffer used, but it's quickly cleaned up.

>   In a way the problem is not the buffer itself but that a write
> into a named pipe, for example, will succeed even if there is no
> one at the other end to receive the data.  I think you'd want an
> open and write on a device driver to fail if the driver is not
> there and ready for the request.

Yes, but you aren't a device driver, you are a IPC between userspace
processes.

> >Adding a new IPC function to the kernel should not be burried down in
> >drivers/char/.  We have 10+ different IPC mechanisms already, some
> >simple, some more complex.  Are you _sure_ none of the existing ones
> >will not work for you?
> I'm convinced this has the fewest lines of new code and the
> smallest impact on the rest of the system, but I could be wrong.
> The minimum feature set I want is to emulate for my user-space
> device driver what the kernel has for procfs and sysfs, That is,
> 	echo 1 > /proc/sys/net/ipv4/ip_forward  # procfs
> 	echo 75 > /dev/motors/left/speed        # proxy dev

As I mentioned above, the kernel does have buffers, and you are using
them to talk to the device / driver / hardware / kernel when accessing
proc and sysfs files.

> > Maybe a simple userspace library that wraps the
> >existing mechanisms would be better (no kernel changes needed, portable
> >to any kernel release, etc.)?
> Yes, this is the traditional model for approaching problems like
> the one I have.  It would involve opening a unix socket, defining
> a protocol for that socket, and then writing several bindings for
> that protocol for different languages.  Wow, that is a LOT of work.

Use protobufs, all of the bindings and protocol is already handled for
you.

>   Luckily for us the procfs and sysfs authors have given us a much
> better model to use: ASCII characters terminated by a newline.  My
> Raspberry Pi customers expect to control an LED with a command like
> this:	echo 1 > /sys/class/gpio/gpio25

That is because you are talking to a hardware device, so that makes
sense.

> So it is entirely reasonable on their part to want to control a
> stepper motor with a command like this:
> 	echo 300 > /dev/robot/stepper0/count

That would be good, if you were talking to hardware.  But you aren't,
you are talking to another userspace process "somewhere else".

thanks,

greg k-h
