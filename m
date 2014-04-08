Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbaDHJrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 05:47:17 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:65261 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaDHJrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 05:47:16 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Freeing of dev->p
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, Peter Wu <lekensteyn@gmail.com>
In-Reply-To: <20140108165628.GA15820@kroah.com>
References: <20140108164058.059cf461@endymion.delvare> <20140108165628. GA15820@kroah.com>
Date: Tue, 08 Apr 2014 10:47:04 +0100
Message-Id: <20140408094704.3B561C40933@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jan 2014 08:56:28 -0800, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Wed, Jan 08, 2014 at 04:40:58PM +0100, Jean Delvare wrote:
> > Hi Greg, hi all,
> > 
> > A memory leak has been reported to me:
> > http://marc.info/?l=linux-i2c&m=138779165123331&w=2
> > 
> > The leak is in i801_probe, caused by an early call to
> > i2c_set_adapdata() which in turn calls dev_set_drvdata() which
> > allocates some memory in device_private_init(). That memory is only
> > freed by the driver core when the i2c_adapter class device is removed.
> > But if the parent (PCI) device probing itself fails for whatever
> > reason, the class device never gets to be created, so it's never
> > removed, thus the memory is never freed.
> > 
> > It is not possible to move the call to i2c_set_adapdata() until after
> > the class device is created, because the data pointed is needed very
> > early after (almost during) i2c adapter creation. So I could make the
> > leak less likely to happen but I can't fix it completely.
> 
> I don't understand, what exactly is leaking?  You have control over your
> own structures, so can't you clean things up on the error path if you
> know something went wrong?
> 
> > I am wondering how this can be solved, and this brought three questions:
> > 
> > 1* What is the rationale for allocating dev->p dynamically? It is
> > allocated as soon as the device is created (in device_add), so as far
> > as I can see every device will need the allocation. Including struct
> > device_private in struct device would not cost more memory, plus it
> > would reduce memory fragmentation. So is this a lifetime issue? Or
> > something else I can't think of?
> 
> I did it to keep things that non-driver-core code should not be
> touching.  Previously, lots of people messed around with the device
> private fields that could confuse the driver core.  Ideally, I'd like to
> be able to move the kobject itself into this structure, to allow devices
> to handle static initialization better, but that never happened, unlike
> other driver core structures.

Picking up on an old thread, but speaking generally. I see that Jean has
posted a patch for this sspecific issue...

I do get concerned about this approach of protect fields by putting them
behind an allocated structure that always needs to be there. It
complicates the code and increases the runtime overhead with no benefits
other than catching badly behaved driver writers. Those /should/ be the
sort of failures we can catch at build time.

I like tglx's approach here in include/linux/irqdesc.h:

struct irq_desc {
		...
		unsigned int core_internal_state__do_not_mess_with_it;
		...

We could have a naming convention for private members and do a sparse or
checkpatch test for non-core code touching private data.

g.

