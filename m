Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3HPWVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:21:20 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:47262 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3HPWVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:21:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130816215530.GA14464@mithrandir>
References: <1376685563-1053-1-git-send-email-treding@nvidia.com>
 <1376685563-1053-3-git-send-email-treding@nvidia.com> <20130816210637.GC2198@kroah.com>
 <20130816215530.GA14464@mithrandir>
From: Grant Likely <grant.likely@linaro.org>
Date: Fri, 16 Aug 2013 23:20:55 +0100
X-Google-Sender-Auth: eKZnDrekcLi7mTgDdykLZ31AdY4
Message-ID: <CACxGe6uhiKY7a0+aViEamwKbE2tJicVc8CMZChBUaf+KYTs5rw@mail.gmail.com>
Subject: Re: [RFC 2/4] driver core: Allow early registration of devices
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 10:55 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Fri, Aug 16, 2013 at 02:06:37PM -0700, Greg Kroah-Hartman wrote:
>> On Fri, Aug 16, 2013 at 10:39:21PM +0200, Thierry Reding wrote:
>> > +static DEFINE_MUTEX(device_early_mutex);
>> > +static LIST_HEAD(device_early_list);
>> > +static bool device_is_early = true;
>> > +
>> > +/*
>> > + * Keep a list of early registered devices so that they can be fully
>> > + * registered at a later point in time.
>> > + */
>> > +static void device_early_add(struct device *dev)
>>
>> __init?
>
> Yes.
>
>> > +{
>> > +   mutex_lock(&device_early_mutex);
>> > +   list_add_tail(&dev->p->early, &device_early_list);
>> > +   mutex_unlock(&device_early_mutex);
>> > +}
>> > +
>> > +/*
>> > + * Mark the early device registration phase as completed.
>> > + */
>> > +int __init device_early_init(void)
>> > +{
>> > +   device_is_early = false;
>> > +
>> > +   return 0;
>> > +}
>> > +
>> > +/*
>> > + * Fixup platform devices instantiated from device tree. The problem is
>> > + * that since early registration happens before interrupt controllers
>> > + * have been setup, the OF core code won't know how to map interrupts.
>> > + */
>> > +int __init platform_device_early_fixup(struct platform_device *pdev)
>>
>> This shouldn't be in this file, because:
>>
>> > +/*
>> > + * Fully register early devices.
>> > + */
>> > +int __init device_early_done(void)
>> > +{
>> > +   struct device_private *private;
>> > +
>> > +   list_for_each_entry(private, &device_early_list, early) {
>> > +           struct device *dev = private->device;
>> > +           int err;
>> > +
>> > +           if (dev->bus == &platform_bus_type) {
>>
>> Why special case the platform bus?  We are trying to move things off of
>> the platform bus, don't make it harder to do that :)
>
> I heard about that, but I must have missed the thread where this was
> discussed. Can you point me to it?
>
>> > +                   struct platform_device *pdev = to_platform_device(dev);
>> > +
>> > +                   err = platform_device_early_fixup(pdev);
>> > +                   if (err < 0)
>> > +                           dev_err(&pdev->dev,
>> > +                                   "failed to fixup device %s: %d\n",
>> > +                                   dev_name(&pdev->dev), err);
>> > +           }
>>
>> You should just have a bus callback that can be made here that, if
>> present, can be called.  That way any bus can handle this type of thing,
>> not just the platform one.
>
> You mean something like an .early_fixup() in struct bus_type? That would
> indeed be much cleaner. As I mentioned this is a very early prototype
> and this particular hunk exists specifically to fixup the platform
> devices created by the device tree helpers so that the kernel actually
> boots to the login prompt.
>
>> Not that I really like the whole idea anyway, but I doubt there's much I
>> can do about it...
>
> Well, getting feedback from you and others is precisely the reason why I
> wanted to post this early. There must be a reason why you don't like it,
> so perhaps you can share your thoughts and we can mould this into
> something that you'd be more comfortable with.
>
> To be honest I don't particularly like it either. It's very hackish for
> core code. But on the other hand there are a few device/driver ordering
> problems that this (or something similar) would help solve. I'm
> certainly open to discuss alternatives and perhaps there's a much
> cleaner way to solve the problem.

And on that note, I think we're all in agreement that it's ugly!
Looking at it now, I don't think it is the right approach.

In the big scheme of things, there really aren't a lot of devices that
will need this functionality. Something I don't have a good handle on
is the set of devices needed to be created early. Yes, some of the
clocks and power rails need to be set up, but do all of them? Yes, the
interrupts need to be set up, but was of_irq_init() a mistake?
Cascaded interrupt controllers really could be normal devices if there
isn't anything critical for early boot connected to them (ie. the
timer). If irq references were changed to be parsed at .probe() time
instead of device registration time, the deferred probe would have
everything needed to make sure the interrupt controllers get probed
before the users.

Also, for the devices that are created early, is it really appropriate
to use APIs that require a struct device? I could easily argue that
anything done at early boot should only be the bare minimum to allow
the kernel to get to initcalls, and so mucking about with devices is
inappropriate because it really messes with the assumptions made in
the design of the driver model.

g.
