Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab3CTAgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:36:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59452 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab3CTAgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:36:19 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 19 Mar 2013 17:36:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Simon J. Rowe" <srowe@mose.org.uk>
Cc: lm-sensors@lm-sensors.org, tomas.winkler@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: RFC (v2): Intel QST sensor driver
Message-ID: <20130320003618.GA23631@roeck-us.net>
References: <51478535.8080107@mose.org.uk>
 <20130319002724.GA1843@roeck-us.net>
 <5148DCC3.6040406@mose.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5148DCC3.6040406@mose.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 09:46:43PM +0000, Simon J. Rowe wrote:
> On 19/03/13 00:27, Guenter Roeck wrote:
> >Couple of problems I noticed when browsing through the code.
> >
> >- Some functions return errors with return code 0.
> >
> >	if (ret <= 0)
> >		goto out;
> >	...
> >out:
> >	return ret;
> >
> >   For values of 0, the calling code will likely miss the error.
> Thanks for your helpful comments.
> 
> In some of the low-level code I decided to use return 0 to indicate
> nothing was transmitted. Probably these situations should be
> regarded as an error and -EAGAIN used. I'll check them and fix this.

Code such as

	if (ret <= 0) {
		pr_err(...);
		goto out;
	}

does look like an error, though. If it isn't, there should be no error message.

And if it is a function such as qst_get_mon_config(), which ends up printing
the content of the non-retrieved message, it most definitely looks wrong.

The same really applies to each case I have noticed.

> >
> >- In some cases, returned errors are replaced with another error
> >
> >	if (ret < 0)
> >		return -EIO;
> >
> >   You should return the original error.
> >
> >- Try using something better than -EIO is possible. For example, you can use
> >   -EINVAL for invalid parameters.
> I'd noticed -EIO was used quite a bit in some existing modules (e.g.
> abitguru3.ko) and thought this was a general convention. I'll switch
> to using the original return codes.

Other drivers doing the same bad thing doesn't mean you should do it as well :).

Just think about the best error to use. For example, you use -EINVAL if
wait_event_interruptible_timeout times out. That should really, at least most
likely, be -ETIMEDOUT. Actually those calls are problematic anyway, as they 
are interruptable and might leave the mei device in an undefined state.
Can that happen ?

> >
> >- Don't use strict_str functions. Use kstr functions instead (checkpatch should
> >   tell you that, actually).
> Ah, I'd run checkpatch on my dev box (which runs 2.6.39), the newer
> source trees do indeed flag this up, I'll fix it.
> >
> >- Try using dev_ messages as much as possible (instead of pr_)
> >
> >- Try allocating memory with devm_ functions. This way you can drop the matching
> >   calls to kfree().
> The client objects don't contain a struct device. Multiple clients
> have a pointer to the underlying supporting device but from what I
> understand of devm_kzalloc() that would defer freeing memory until
> the device is shut down (which only happens on module unload). That
> could leave an increasing amount of memory tied up.

Ok, makes sense.

> >
> >- I notice you use kmalloc() a lot. That is ok if you know that you'll
> >   initialize all fields, but it is kind of risky. Better use kzalloc().
> >   (if you start using devm_kzalloc, the issue becomes mostly irrelevant,
> >   as there is no devm_kmalloc).
> >
> I'd avoided using kzalloc() when I knew I'd need to initialize
> members, but none of the code is on a hot path and it avoids
> oversights when new members get added.

Hmm .. usually one initializes the structure to zero to avoid unpredictable
behavior. The argument for zeroing out a data structure is pretty much the
same as yours for not zeroing it out.

With your approach you hope to get either a compiler error or some
unpredictable behavior / crash if you forget to initialize an element.
I don't think that is such a good idea.

> >>I've added documents that explain the QST protocol and also the design
> >>of the driver.
> >>
> >For my part I like the architecture of your driver. Wonder how difficult
> >it would be to implement the functionality supported by the in-kernel driver
> >(eg watchdog) with your infrastructure.
> The MEI watchdog? that would be quite straightforward to create a
> module for. I had planned to write one but didn't have access to any
> hardware with this function.
> >
> >Overall it would be great if you and Tomas could get together and come up
> >with a unified implementation.
> >
> >
> I'd be happy to help getting a driver that fits everybody's needs.
> The difficult is there are slight differences in approach. From what
> I can see from the QST SDK the kernel driver was written to provide
> a minimal implementation with the majority of the logic in a
> cross-platform userspace library. My driver was aimed at providing a
> base to make it easy to write other kernel modules like the QST one.
> 
> There's no reason why an adaptation layer that provides the same
> ioctl()/dev interface as the current Intel driver couldn't be
> created.
> 
The kernel community in general prefers an incremental approach, where an
existing driver is not replaced but continually improved. I don't know what the
best approach is here, but you'll need to find a way to introduce your code
in a non-disruptive way.

Couple of additional comments.

return; at the end of a void function is really not necessary.

There are several functions which can get an error from underlying code, display
an error to the log, yet return void. Maybe there is a good reason for that, but
it would be better to pass errors to calling code whenever possible.

In some cases, such as mei_attach_client(), it definitely looks wrong that
errors are just ignored - especially since the calling code does have a return
value.

It is also a bit odd that functions like handle_ver_rsp() report an error to
the log, yet return no indication to the caller about it. Anything resulting
in a pr_err log message should really be reported to the caller, or it is not
an error.

Thanks,
Guenter
