Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaESDLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 23:11:37 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49481 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbaESDLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 23:11:35 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH 2/9] dt: deps: dependency based device creation
To: Tomasz Figa <tomasz.figa@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Rob Herring <robh+dt@kernel.org>
In-Reply-To: <53777113.3070909@gmail.com>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
	<1399913280-6915-3-git-send-email-holler@ahsoftware.de>
	<20140514140534.897F8C4153D@trevor.secretlab.ca>
	<53777113.3070909@gmail.com>
Date: Sun, 18 May 2014 15:59:22 +0100
Message-Id: <20140518145922.9D59FC40D85@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

Thanks for weighing in on this. Thoughts and comments below.

On Sat, 17 May 2014 16:24:19 +0200, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi,
> 
> On 14.05.2014 16:05, Grant Likely wrote:
> > On Mon, 12 May 2014 18:47:53 +0200, Alexander Holler <holler@ahsoftware.de> wrote:
> >> Use the properties named 'dependencies' in binary device tree blobs to build
> >> a dependency based initialization order for platform devices and drivers.
> >>
> >> This is done by building a directed acyclic graph using an adjacency list
> >> and doing a topological sort to retrieve the order in which devices/drivers
> >> should be created/initialized.
> >>
> >> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> > 
> > Hi Alexander,
> > 
> > Thanks for looking at this. It is a difficult problem. I've made
> > comments below, but first I've got some general comments...
> > 
> > First, I'm going to be very cautious about this. It is a complicated
> > piece of code making the device initialization process a lot more
> > complicated than it already is. I'm the first one to admit that deferred
> > probe handles the problem in quite a naive manner, but it is simple,
> > correct (when drivers support deferred probe) and easy to audit. This
> > series digs deep into the registration order of *both* devices and
> > drivers which gives me the heebee jeebees.
> > 
> > Personally, I think the parts of this patch that manipulate the device registration
> > order is entirely the wrong way to handle it. If anything, I would say
> > continue to register the devices, even if the dependencies are unmet.
> > Instead, I would focus on the driver core (drivers/base) to catch
> > device probe attempts when a known dependency is not met, remember it,
> > and perform the probe after the other driver shows up. That is also
> > going to be a complicated bit of code, but it works for every kind of
> > device, not just platform_devices, and has far less impact on the
> > platform setup code.
> 
> Grant, I tend to disagree with you on this. While Alexander's solution
> has certain flaws (that I'm going to list further in my reply), I also
> believe that an approach based on device registration order is most
> likely the way to go. As compared to other possible approaches, here is
> the list of advantages I can see (in random order):
> 
> 1) If compared with resource-based approach, when you detect
> dependencies at runtime, based on existing resource specifiers (GPIOs,
> clocks, etc.), you don't need to change anything in the implementation
> whenever a new kind of resources is introduced. Moreover, there is no
> need to make device probing code aware of any resources or dependencies,
> because all you need to do is to register devices in certain order, as
> defined by precompiled dependency lists.

I think we can handle the source of dependencies separately from how
those depenencies are used. I would rather not have a separate set of
properties for dependency tracking because of the possiblity of it
being made inconsistent, but I'm not flat out refusing.

> 2) If implemented properly, it helps solving problem of binding proper
> driver to a device with multiple compatible strings. Current way of
> handling this by Linux is _broken_, because the device will be bound to
> first driver that shows up and contains matching compatible string in
> its match table. Notice that this way the whole idea of having multiple
> compatible strings specified from most specific to most generic is made
> useless. Now you may wonder how both problems relate. Basically in both
> cases you need to wait until drivers for devices are available (e.g.
> registered in system-wide list), either to guarantee that registering a
> device means probing it (in first case) or to look through the list of
> available drivers and select the one that is a best match (in second case).

No argument here.

> 3) DeviceTree is not the only firmware "interface" supported by Linux
> and so I'd be careful with pushing this into generic driver core that is
> also shared with board files and ACPI and possibly something else I'm
> not aware of.

Competely agree. Anything that goes in to driver core cannot be OF
specific. If the driver core is modified, then it needs to be
generically useful regardless of firmware interface.

> Moreover, I think the existing driver core is already
> quite complex and complicating it even more might not be the best idea,
> unless really the only option.

I think it actually is the only option. More below.

> 4) This approach is far less complicated than anything mentioned above.
> What's so complicated in creating a graph of devices and registering
> them in certain order?

As Alexander's patch series shows, merely manipulating the registration
order of devices doesn't actually solve anything. For most platform
devices, link order has a far large impact on probe order than
registration order. Alexander had to hook into the driver registration
patch to get the optimal probe order. For device order to be effective,
all driver registration would need to occur before devices are
registered (opposite of what we do now).

The driver core is very simple in this regard. It accepts device and
driver registration. When one gets registered, it immediately attempts
to match against one of the others. Simple and easy to understand, but
very non-deterministic behaviour.

A lot of devices gets registered well before the driver, platform_devices
especially. Other devices may very well show up afterwards, such as
anything registered by another driver. For example, it is the
responsibility of an i2c bus driver to register all the child i2c
devices. By the time the i2c bus driver gets probed, the i2c drivers may
already be available. And to make things worse, any device could depend
on any other regardless of bus type.

To actually solve the problem we need to deal with dependencies across
all devices, regardless of bus type and regardless of whether or not the
driver gets registered first. Tackling only device order, or only driver
order misses a whole bunch of situations.

Alexander's patch is the right idea here. It collects a bunch of driver
registrations for an initcall without calling probe so that a sorting pass
can be performed first. That approach can solve both the dependency
order and the compatible list problems, and I think it is worth
exploring.

Having said that, there are some things that I worry about. I worry
about the cost of doing dependency sorting, both in calculating the
dependency tree and in pushing back probe calls to the end of initcalls.
I worry that incorrect dependency information will cause some devices to
not get bound (say because the kernel things the dependency isn't met
when it actually is).

Again, that doesn't mean I'm saying "don't do this, it is bad". It just
means those are the corner cases and performance issues that I want to
make sure are handled well. They are the questions I'll be asking before
I merge anything. I'd be thrilled for someone to continue this work.

> > Also, may I suggest that the more pieces that you can break this series
> > up into, the greater chance you'll have of getting a smaller subset
> > merged earlier if it can be proven to be useful on its own.
> 
> I think the part that alters driver registration and initcalls isn't
> really necessary. With current code, we can see that initcalls
> themselves (not driver code in terms of driver model) are already well
> ordered, as things happening there seems to work, without any need to
> defer anything. Now Alexander's approach relies on
> module_platform_driver() and similar macros to obtain the list of
> platform_drivers in the system, but I think this isn't necessary either.

Hahaha, as described above, this is where I think Alexander is on the
right path!!!

> Now this is just a bit of guessing, as I still haven't been able to
> allocate time to take a deeper look into initcall and driver code, but
> what if we let the initcalls do their work, let's say up to
> late_initcall level and only then register drivers in our precomputed
> order?

If we can compute an ideal driver registration order, then this will
always be a helpful thing to do. It doesn't catch everything, but it can
make a lot of things better.

Cheers,
g.

> We seem to be already relying an assumption that on late_initcall
> level the devices should be already probed, as we have various calls
> disabling unused resources, such as regulators and clocks, at this
> level. I can see certain drivers being registered in late_initcalls, but
> this would be after our device registration, so most of dependencies
> should be already there and if not, we still have deferred probing.
> 
> With such design in place, we would be able to also solve the other
> problem I mentioned above, the problem of matching devices with most
> appropriate drivers. Since at device registration and probing time,
> (almost) all the drivers would be already available, the matching code
> could select the right one to bind.
> 
> Alright, that's my take on this. Looking forward to your comments.
> 
> Best regards,
> Tomasz

