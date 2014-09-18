Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaIRXJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 19:09:14 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56598 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaIRXJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 19:09:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140912181601.GA21033@kroah.com>
References: <1410450558-12358-1-git-send-email-mathieu.poirier@linaro.org>
	<1410450558-12358-2-git-send-email-mathieu.poirier@linaro.org>
	<20140911203344.GA7593@kroah.com>
	<CANLsYkyPFvOnqRJaWZrvw1aVjBWG=tHuv+V9Tj5RhMy_gD_oiA@mail.gmail.com>
	<20140912181601.GA21033@kroah.com>
Date: Thu, 18 Sep 2014 17:09:11 -0600
Message-ID: <CANLsYkz1DhJ-DCgaUHFgmtUB+QfGDKrnbGRJQDBp=PkKvg9RMA@mail.gmail.com>
Subject: Re: [PATCH 01/11 v6] coresight: add CoreSight core layer framework
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2014 12:16, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Sep 12, 2014 at 11:41:44AM -0600, Mathieu Poirier wrote:
>> Good morning and thanks for the review.  Pls see comments below.
>>
>> Mathieu
>>
>> On 11 September 2014 14:33, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > Some first impressions in glancing at the code, not a complete review at
>> > all:
>> >
>> > On Thu, Sep 11, 2014 at 09:49:08AM -0600, mathieu.poirier@linaro.org wrote:
>> >> --- /dev/null
>> >> +++ b/drivers/coresight/coresight.c
>> >> @@ -0,0 +1,663 @@
>> >> +/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
>> >> + *
>> >> + * This program is free software; you can redistribute it and/or modify
>> >> + * it under the terms of the GNU General Public License version 2 and
>> >> + * only version 2 as published by the Free Software Foundation.
>> >> + *
>> >> + * This program is distributed in the hope that it will be useful,
>> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> >> + * GNU General Public License for more details.
>> >> + */
>> >> +
>> >> +#define pr_fmt(fmt) "coresight: " fmt
>> >
>> > MODULE_NAME ?
>>
>> Is this what you had in mind?
>>
>> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
> Sorry, yes, that's much better and "portable".
>
> But as you are using the driver model, the odds of you ever using a pr_*
> call is all but none, so why do you even need this?

You suggest to use dev_* instead?  My (perhaps flawed) logic was that
the framework ins't associated with a single device but a set of them.

>> >
>> >> +
>> >> +#include <linux/kernel.h>
>> >> +#include <linux/module.h>
>> >> +#include <linux/init.h>
>> >> +#include <linux/types.h>
>> >> +#include <linux/device.h>
>> >> +#include <linux/io.h>
>> >> +#include <linux/err.h>
>> >> +#include <linux/export.h>
>> >> +#include <linux/slab.h>
>> >> +#include <linux/semaphore.h>
>> >> +#include <linux/clk.h>
>> >> +#include <linux/coresight.h>  The original author had created a new bus (called "coresight") and lumped all the coresight components found on the system under that sysfs entry.
>> >> +#include <linux/of_platform.h>
>> >> +#include <linux/debugfs.h>
>> >> +#include <linux/delay.h>
>> >> +
>> >> +#include "coresight-priv.h"
>> >> +
>> >> +struct dentry *cs_debugfs_parent = NULL;
>> >> +
>> >> +static LIST_HEAD(coresight_orph_conns);
>> >> +static LIST_HEAD(coresight_devs);
>> >
>> > You are a struct device, you don't need a separate list, why not just
>> > iterate over your bus list of devices?
>>
>> Because coresight devices are not powered on the bus.  As such, every
>> time we iterate over the bus we'd need to setup the clock for the
>> device, power up its domain (if necessary) and lookup the device ID.
>> Isn't better to simply keep a list of the devices that were found at
>> boot time and use that whenever we want to make configuration changes?
>
> You have that list already, as part of the bus list in the driver core.
> I'm not asking you to "power up" anything, just use the data structures
> the kernel already provides for you.

After looking into this further I believe to understand what you are asking for.

>
>> With regards to @coresight_orph_conns, on top of the above problem
>> we'd also have to add a flag in the @coresight_device structure to
>> indicate that a device has been connected to the topology or not. To
>> me using a list is much cleaner.
>
> A single flag is "cleaner" than a whole separate list, not to mention
> simpler to understand :)  The original author had created a new bus (called "coresight") and lumped all the coresight components found on the system under that sysfs entry.

Very well.

>
>> >> +/**
>> >> + * @id:              unique ID of the component.
>> >> + * @conns:   list of connections associated to this component.
>> >> + * @type:    as defined by @coresight_dev_type.
>> >> + * @subtype: as defined by @coresight_dev_subtype.
>> >> + * @ops:     generic operations for this component, as defined
>> >> +             by @coresight_ops.
>> >> + * @de:              handle on a component's debugfs entry.
>> >> + * @dev:     The device entity associated to this component.
>> >> + * @kref:    keeping count on component references.
>> >> + * @dev_link:        link of current component into list of all components
>> >> +             discovered in the system.
>> >> + * @path_link:       link of current component into the path being enabled.
>> >> + * @owner:   typically "THIS_MODULE".
>> >> + * @enable:  'true' if component is currently part of an active path.
>> >> + * @activated:       'true' only if a _sink_ has been activated.  A sink can be
>> >> +             activated but not yet enabled.  Enabling for a _sink_
>> >> +             happens when a source has been selected for that it.
>> >> + */
>> >> +struct coresight_device {
>> >> +     int id;
>> >
>> > Why not use the device name instead?
>>
>> With regards to memory footprint it is better to keep a single "int"
>> as ID (which is the their memory map start address) than the full
>> string associated with the device name.  Let's take a funnel for
>> example that has up to 8 input port.  To build a path between source
>> and sink we need to keep information about device that are connected
>> to each port.  At this time we use the component's ID, i.e 4 byte.  If
>> we were to use device names, ex "20040000.funnel_cluster0", we are
>> using 24 byte and that, 8 times.
>>
>> Moreover using device names would also mean that we have to used
>> @stcmp everytime we want do lookups.  To me using a single integer to
>> identify coresight components is a much better solution.
>
> Don't try to optimize for something that isn't an issue at all.  You
> aren't searching for devices based on id in any time-critical section,
> and you already have the device id string, so you aren't saving any
> memory, but the opposite, wasting some.  See, your "optimization" ended
> up taking more memory :)

Ok, the least I can do is to give it a try.

>
>> >> +     struct coresight_connection *conns;
>> >> +     int nr_conns;
>> >> +     enum coresight_dev_type type;
>> >> +     struct coresight_dev_subtype subtype;
>> >> +     const struct coresight_ops *ops;
>> >> +     struct dentry *de;
>> >
>> > All devices have a dentry?  in debugfs?  isn't that overkill?
>>
>> All devices along a "path" can require specific configuration, which
>> can only be made by a user.  Exposing the registers via debugfs seemed
>> like the most plausible solution.
>
> configuration is not to be done through debugfs, especially as that is
> restricted to root, and lots of systems don't even have it.  debugfs is
> always optional, don't make your code depend on it to work properly.

Humm... You are the first one to be of the opinion that debugfs
shouldn't be used for coresight configuration - other reviewers have
unequivocally requested that configurables be moved under debugfs.
Debugfs seemed to be a good fit, specifically since ftrace is already
in there.  We could enable CONFIG_DEBUG_FS automatically (the same way
I do it for AMBA) when coresight gets enabled in the kernel config...

If not debugfs, where then?  I'd welcome a suggestion.

>
>> >> +     struct device dev;
>> >> +     struct kref kref;
>> >
>> > You CAN NOT have two reference counts in the same structure, that's a
>> > huge design mistake.  Stick with one reference count, otherwise they are
>> > guaranteed to get out of sync and bad things will happen.
>>
>> In this case the additional @kref is for accounting of components
>> within the coresight framework only.  When the amba framework calls
>> the driver's _probe() routine the kref count is already equal to '2'
>> (as expected), even if no other coresight components have used that
>> device.  Knowing when a component is no longer in use by the framework
>> (but still available in the system) is important for coresight cleanup
>> consideration, i.e switch off the component to save power.
>>
>> The kref helpers don't expose the refcount and @kref_sub will only
>> call the cleanup method when refcount is '1'.  How else should I
>> proceed?
>
> Don't use a kref at all, you should never need to "know" a refcount
> value.  If you do, your logic is incorrect, sorry.  Just use the normal
> driver core functions for when to cleanup memory and the like and you
> will be fine.

I completely agree with you on the fact that the driver core alone
should be the one doing the memory cleanup for a device.  What those
krefs are doing is to keep track of what is happening in the
framework, nothing else.

The framework needs to keep track of component usage by other
components... Say we have a sink that is used by multiple sources.
The framework can't call sink->disable() for as long as a coresight
source is using it and this is exactly what those krefs are for.
Disabling a device in the framework doesn't mean the kernel should be
reclaiming resources for the device.  That device should still be
there for future processing if need be.  On the flip side if a
component isn't used by the framework there is no point using
resources for it i.e, clock, pinout lines, channels...

>
>> >> +#define to_coresight_device(d) container_of(d, struct coresight_device, dev)
>> >> +
>> >> +#define source_ops(csdev)    csdev->ops->source_ops
>> >> +#define sink_ops(csdev)              csdev->ops->sink_ops
>> >> +#define link_ops(csdev)              csdev->ops->link_ops
>> >> +
>> >> +#define CORESIGHT_DEBUGFS_ENTRY(__name, __entry_name,                        \
>> >> +                              __mode, __get, __set, __fmt)           \
>> >> +DEFINE_SIMPLE_ATTRIBUTE(__name ## _ops, __get, __set, __fmt)         \
>> >
>> > Use the RW and RO only versions please.  No need to ever set your own
>> > mode value.
>>
>> I think I get your point but not quite sure how you want me to go
>> about it.  Can you give me a couple more line pls?
>
> Why not just use DEVICE_ATTR_RW()?  and DEVICE_ATTR_RO()? Why create
> your own attribute type?  And if you do, at the very least, use
> __ATTR_RO() and __ATTR_RW(), don't roll your own macros.
>
> And again, you should not need any other mode values other than RO or
> RW, don't make a developer have to think about mode values for any
> attributes.
>
> thanks,
>
> greg k-h
