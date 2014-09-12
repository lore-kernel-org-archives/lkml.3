Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaILSQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:16:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaILSQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:16:03 -0400
Date: Fri, 12 Sep 2014 11:16:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        Kaixu Xia <kaixu.xia@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>,
        "r.sengupta@samsung.com" <r.sengupta@samsung.com>,
        Robert Marklund <robbelibobban@gmail.com>,
        Patch Tracking <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deepak Saxena <dsaxena@linaro.org>
Subject: Re: [PATCH 01/11 v6] coresight: add CoreSight core layer framework
Message-ID: <20140912181601.GA21033@kroah.com>
References: <1410450558-12358-1-git-send-email-mathieu.poirier@linaro.org>
 <1410450558-12358-2-git-send-email-mathieu.poirier@linaro.org>
 <20140911203344.GA7593@kroah.com>
 <CANLsYkyPFvOnqRJaWZrvw1aVjBWG=tHuv+V9Tj5RhMy_gD_oiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLsYkyPFvOnqRJaWZrvw1aVjBWG=tHuv+V9Tj5RhMy_gD_oiA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 11:41:44AM -0600, Mathieu Poirier wrote:
> Good morning and thanks for the review.  Pls see comments below.
> 
> Mathieu
> 
> On 11 September 2014 14:33, Greg KH <gregkh@linuxfoundation.org> wrote:
> > Some first impressions in glancing at the code, not a complete review at
> > all:
> >
> > On Thu, Sep 11, 2014 at 09:49:08AM -0600, mathieu.poirier@linaro.org wrote:
> >> --- /dev/null
> >> +++ b/drivers/coresight/coresight.c
> >> @@ -0,0 +1,663 @@
> >> +/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 and
> >> + * only version 2 as published by the Free Software Foundation.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + */
> >> +
> >> +#define pr_fmt(fmt) "coresight: " fmt
> >
> > MODULE_NAME ?
> 
> Is this what you had in mind?
> 
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Sorry, yes, that's much better and "portable".

But as you are using the driver model, the odds of you ever using a pr_*
call is all but none, so why do you even need this?

> 
> >
> >> +
> >> +#include <linux/kernel.h>
> >> +#include <linux/module.h>
> >> +#include <linux/init.h>
> >> +#include <linux/types.h>
> >> +#include <linux/device.h>
> >> +#include <linux/io.h>
> >> +#include <linux/err.h>
> >> +#include <linux/export.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/semaphore.h>
> >> +#include <linux/clk.h>
> >> +#include <linux/coresight.h>
> >> +#include <linux/of_platform.h>
> >> +#include <linux/debugfs.h>
> >> +#include <linux/delay.h>
> >> +
> >> +#include "coresight-priv.h"
> >> +
> >> +struct dentry *cs_debugfs_parent = NULL;
> >> +
> >> +static LIST_HEAD(coresight_orph_conns);
> >> +static LIST_HEAD(coresight_devs);
> >
> > You are a struct device, you don't need a separate list, why not just
> > iterate over your bus list of devices?
> 
> Because coresight devices are not powered on the bus.  As such, every
> time we iterate over the bus we'd need to setup the clock for the
> device, power up its domain (if necessary) and lookup the device ID.
> Isn't better to simply keep a list of the devices that were found at
> boot time and use that whenever we want to make configuration changes?

You have that list already, as part of the bus list in the driver core.
I'm not asking you to "power up" anything, just use the data structures
the kernel already provides for you.

> With regards to @coresight_orph_conns, on top of the above problem
> we'd also have to add a flag in the @coresight_device structure to
> indicate that a device has been connected to the topology or not. To
> me using a list is much cleaner.

A single flag is "cleaner" than a whole separate list, not to mention
simpler to understand :)

> >> +/**
> >> + * @id:              unique ID of the component.
> >> + * @conns:   list of connections associated to this component.
> >> + * @type:    as defined by @coresight_dev_type.
> >> + * @subtype: as defined by @coresight_dev_subtype.
> >> + * @ops:     generic operations for this component, as defined
> >> +             by @coresight_ops.
> >> + * @de:              handle on a component's debugfs entry.
> >> + * @dev:     The device entity associated to this component.
> >> + * @kref:    keeping count on component references.
> >> + * @dev_link:        link of current component into list of all components
> >> +             discovered in the system.
> >> + * @path_link:       link of current component into the path being enabled.
> >> + * @owner:   typically "THIS_MODULE".
> >> + * @enable:  'true' if component is currently part of an active path.
> >> + * @activated:       'true' only if a _sink_ has been activated.  A sink can be
> >> +             activated but not yet enabled.  Enabling for a _sink_
> >> +             happens when a source has been selected for that it.
> >> + */
> >> +struct coresight_device {
> >> +     int id;
> >
> > Why not use the device name instead?
> 
> With regards to memory footprint it is better to keep a single "int"
> as ID (which is the their memory map start address) than the full
> string associated with the device name.  Let's take a funnel for
> example that has up to 8 input port.  To build a path between source
> and sink we need to keep information about device that are connected
> to each port.  At this time we use the component's ID, i.e 4 byte.  If
> we were to use device names, ex "20040000.funnel_cluster0", we are
> using 24 byte and that, 8 times.
> 
> Moreover using device names would also mean that we have to used
> @stcmp everytime we want do lookups.  To me using a single integer to
> identify coresight components is a much better solution.

Don't try to optimize for something that isn't an issue at all.  You
aren't searching for devices based on id in any time-critical section,
and you already have the device id string, so you aren't saving any
memory, but the opposite, wasting some.  See, your "optimization" ended
up taking more memory :)

> >> +     struct coresight_connection *conns;
> >> +     int nr_conns;
> >> +     enum coresight_dev_type type;
> >> +     struct coresight_dev_subtype subtype;
> >> +     const struct coresight_ops *ops;
> >> +     struct dentry *de;
> >
> > All devices have a dentry?  in debugfs?  isn't that overkill?
> 
> All devices along a "path" can require specific configuration, which
> can only be made by a user.  Exposing the registers via debugfs seemed
> like the most plausible solution.

configuration is not to be done through debugfs, especially as that is
restricted to root, and lots of systems don't even have it.  debugfs is
always optional, don't make your code depend on it to work properly.

> >> +     struct device dev;
> >> +     struct kref kref;
> >
> > You CAN NOT have two reference counts in the same structure, that's a
> > huge design mistake.  Stick with one reference count, otherwise they are
> > guaranteed to get out of sync and bad things will happen.
> 
> In this case the additional @kref is for accounting of components
> within the coresight framework only.  When the amba framework calls
> the driver's _probe() routine the kref count is already equal to '2'
> (as expected), even if no other coresight components have used that
> device.  Knowing when a component is no longer in use by the framework
> (but still available in the system) is important for coresight cleanup
> consideration, i.e switch off the component to save power.
> 
> The kref helpers don't expose the refcount and @kref_sub will only
> call the cleanup method when refcount is '1'.  How else should I
> proceed?

Don't use a kref at all, you should never need to "know" a refcount
value.  If you do, your logic is incorrect, sorry.  Just use the normal
driver core functions for when to cleanup memory and the like and you
will be fine.

> >> +#define to_coresight_device(d) container_of(d, struct coresight_device, dev)
> >> +
> >> +#define source_ops(csdev)    csdev->ops->source_ops
> >> +#define sink_ops(csdev)              csdev->ops->sink_ops
> >> +#define link_ops(csdev)              csdev->ops->link_ops
> >> +
> >> +#define CORESIGHT_DEBUGFS_ENTRY(__name, __entry_name,                        \
> >> +                              __mode, __get, __set, __fmt)           \
> >> +DEFINE_SIMPLE_ATTRIBUTE(__name ## _ops, __get, __set, __fmt)         \
> >
> > Use the RW and RO only versions please.  No need to ever set your own
> > mode value.
> 
> I think I get your point but not quite sure how you want me to go
> about it.  Can you give me a couple more line pls?

Why not just use DEVICE_ATTR_RW()?  and DEVICE_ATTR_RO()? Why create
your own attribute type?  And if you do, at the very least, use
__ATTR_RO() and __ATTR_RW(), don't roll your own macros.

And again, you should not need any other mode values other than RO or
RW, don't make a developer have to think about mode values for any
attributes.

thanks,

greg k-h
