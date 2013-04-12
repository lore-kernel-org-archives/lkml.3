Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab3DLWGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:06:37 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:36647 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3DLWGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:06:36 -0400
Date: Fri, 12 Apr 2013 15:06:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Federico Vaga <federico.vaga@gmail.com>
Cc: linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alessandro Rubini <rubini@gnudd.com>
Subject: Re: drivers/base/core.c: about device_find_child() function
Message-ID: <20130412220633.GA16524@kroah.com>
References: <3798489.yISokZugC2@harkonnen>
 <20130411134844.GA3489@kroah.com>
 <2849474.HO2K6X9Bdi@harkonnen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2849474.HO2K6X9Bdi@harkonnen>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 02:09:20PM +0200, Federico Vaga wrote:
> On Thursday 11 April 2013 06:48:44 Greg Kroah-Hartman wrote:
> > On Thu, Apr 11, 2013 at 01:52:36PM +0200, Federico Vaga wrote:
> > > Hello,
> > > 
> > > I'm using the function device_find_child() [drivers/base/core.c] to
> > > retrieve a specific child of a device. I see that this function invokes
> > > get_device(child) when a child matches. I think that this function must
> > > return the reference to the child device without getting it.
> > 
> > No, it should not, otherwise the device could "disappear" at any moment,
> > and the caller who had the handle, would now have a stale pointer.
> 
> I know, I am aware of this, but sometimes it *seems* that it does not
> matter. (argument later [**])

It does matter, it's just that you are finding users that aren't really
caring about the device at all, just if it is present or not.

<snip>

> In this case, it does not matter to get_device(), the driver is interested
> only on the child existence, it does not use the child.
> Maybe it is wrong a driver that works like this. I mean, why retrieve a
> child if you do not want to use it? This can be implemented also with
> the function device_for_each_child() and return an error if a channel already
> exist (-EBUSY).

Yes, you could use device_for_each_child(), but some people find
device_find_child() easier to call, that's up to them.  It doesn't
really matter either way.

> Anyway, my suggestion was more about the function name rather than its 
> content (again, I am aware that the refcount must be increased if I
> work on the retrieved child). Because the verb 'find' does not imply the
> verb 'get', so, a function named device_find_child() should not do
> get_device() because it may not obvious for the reader. I think that
> the name should be something like get_device_child(), get_child_device(),
> get_child(), and for symmetry the user will do put_device() on the
> retrived child. But I understand that for legacy reason it could be
> better to continue use device_find_child()

All functions in the driver core that return a pointer to a reference
counted device, return with it incremented.  The "get" vs, "find" names
do not matter here.  Symmetry would have been nice, and I have taken
some heat about the naming of the driver core functions at times,
especially by people new to the code, but realize that this was created
10+ years ago, and has grown over time.  We didn't have any real help
way back then, so we have what we have.

Patches to try to make things "cleaner" are always appreciated, as long
as you aren't just gratuitously renaming functions.

> I did not study serial_core, I was looking only for device_find_child().
> Probably I'm missing something. Anyway, here what does not convice me:
> 
> (line number on next-20130412)
> serial_core.c:2003
> 	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
> 	if (!uport->suspended && device_may_wakeup(tty_dev)) {
> 		if (uport->irq_wake) {
> 			disable_irq_wake(uport->irq);
> 			uport->irq_wake = 0;
> 		}
> +               put_device(tty_dev);
> 		mutex_unlock(&port->mutex);
> 		return 0;
> 	}
> +	put_device(tty_dev);
> 	uport->suspended = 0; 
> 
> serial_core:1936
> 	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
> 	if (device_may_wakeup(tty_dev)) {
> 		if (!enable_irq_wake(uport->irq))
> 			uport->irq_wake = 1;
> 		put_device(tty_dev);
> 		mutex_unlock(&port->mutex);
> 		return 0;
> 	}
> +	put_device(tty_dev);

That looks like a good patch, care to properly send it, (after you test
it first of course), so that we can apply it?

thanks,

greg k-h
