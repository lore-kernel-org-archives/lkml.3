Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaLFKVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 05:21:48 -0500
Received: from 1wt.eu ([62.212.114.60]:38075 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbaLFKVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 05:21:46 -0500
Date: Sat, 6 Dec 2014 11:21:43 +0100
From: Willy Tarreau <w@1wt.eu>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Mariusz Gorski <marius.gorski@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: staging: panel: suggestions needed
Message-ID: <20141206102143.GA3574@1wt.eu>
References: <20141202080214.GA4762@sudip-PC> <20141206084108.GA3404@1wt.eu> <20141206100933.GA7141@sudip-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141206100933.GA7141@sudip-PC>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 03:39:33PM +0530, Sudip Mukherjee wrote:
> > Feel free to do so. I never had the luck to own a 4-line LCD so this
> > was never even planned. And yes, I remember something about 4-line LCDs
> > using tricks such as 2x40 addressing being split into 4x20.
> well, i work in a company which is in embedded training, so i have access to
> few hardware, and for this i can have 16x2 and 20x4 lcd, but no serial lcd
> ... :(

You could find a cheap serial LCD, a ks0074-based one if you need.
I even think they use SPI, which might be what is implemented in
the driver (though I didn't know about SPI by then).

> > > 	2) The lcd commands you are writing to the lcd in an escape sequence
> > > 	while writing to the lcd. Instead of that why don't we use ioctl for
> > > 	lcd commands, and writing to the device will involve only sending data
> > > 	to lcd ?
> > 
> > Because you cannot send that from a script. It's just as if you had to use
> > an ioctl to clear your terminal, inverse its video or to move its cursor,
> > it would not be very convenient.
> yes, ioctl will not be possible from script. but here in India, we will
> usually use c code for embedded systems, on very rare occassion we will use
> scripts. and we will be using open(), read(), write(), ioctl() and close()
> system calls from our projects.
> here, we can have both methods in the code. if someone is using escape
> sequence - that will work, and we can also have the ioctl for the same
> purpose.

Sure but similarly the C code can easily emit escape chars that will avoid
to complicate the driver.

> > > 	3) You have given fixed minor number in your code. Any problem if we
> > > 	make it dynamic ?
> > 
> > No objection, but I think we should keep a config option to bind to the
> > old minor. The rationale behind this is that this driver is mostly used
> > in embedded systems with a fixed /dev.
> ok. but one doubt: won't misc_register create the /dev entry automatically ?

Yes, if devtmpfs or udev or equivalent are used. It's not always the case
on systems with very few devices where everything is known in advance and
nothing needs to be dynamically configured. That said, I think that static
/dev entries will progressively disappear as kernels evolve. Anyway what
I'm saying is just a warning not to break userland API, and typically a
fixed /dev/lcd major+minor is in direct relation with userland API : if it
works now, changing that will break programs relying on this. I don't have
strong opinions in this area since I don't know how many people use this
driver anyway. Maybe it would be best to proceed in two phases :
  1) make it possible to use a dynamic entry without removing the option
     for the static one, and deprecating it
  2) remove the static option

That way, if any user gets any issue it will be easier for him to revert
#2 and report about it, or update his system if possible.

Regards,
Willy

