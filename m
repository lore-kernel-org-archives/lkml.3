Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaAHQ4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 11:56:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbaAHQz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 11:55:59 -0500
Date: Wed, 8 Jan 2014 08:56:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, Peter Wu <lekensteyn@gmail.com>
Subject: Re: Freeing of dev->p
Message-ID: <20140108165628.GA15820@kroah.com>
References: <20140108164058.059cf461@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108164058.059cf461@endymion.delvare>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 04:40:58PM +0100, Jean Delvare wrote:
> Hi Greg, hi all,
> 
> A memory leak has been reported to me:
> http://marc.info/?l=linux-i2c&m=138779165123331&w=2
> 
> The leak is in i801_probe, caused by an early call to
> i2c_set_adapdata() which in turn calls dev_set_drvdata() which
> allocates some memory in device_private_init(). That memory is only
> freed by the driver core when the i2c_adapter class device is removed.
> But if the parent (PCI) device probing itself fails for whatever
> reason, the class device never gets to be created, so it's never
> removed, thus the memory is never freed.
> 
> It is not possible to move the call to i2c_set_adapdata() until after
> the class device is created, because the data pointed is needed very
> early after (almost during) i2c adapter creation. So I could make the
> leak less likely to happen but I can't fix it completely.

I don't understand, what exactly is leaking?  You have control over your
own structures, so can't you clean things up on the error path if you
know something went wrong?

> I am wondering how this can be solved, and this brought three questions:
> 
> 1* What is the rationale for allocating dev->p dynamically? It is
> allocated as soon as the device is created (in device_add), so as far
> as I can see every device will need the allocation. Including struct
> device_private in struct device would not cost more memory, plus it
> would reduce memory fragmentation. So is this a lifetime issue? Or
> something else I can't think of?

I did it to keep things that non-driver-core code should not be
touching.  Previously, lots of people messed around with the device
private fields that could confuse the driver core.  Ideally, I'd like to
be able to move the kobject itself into this structure, to allow devices
to handle static initialization better, but that never happened, unlike
other driver core structures.

> 2* What is the rationale for making void *driver_data part of struct
> device_private and not struct device itself?

To "hide" information / details that non-driver core code should not
care about or touch.

> 3* If the current implementation is considered correct, does it mean
> that dev_set_drvdata() should never be used for class devices?

No, it should be fine, I don't understand the issue with your usage that
is causing the problem, care to explain it better, or point me at some
code?

thanks,

greg k-h
