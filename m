Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793AbaEQOYc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 10:24:32 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:32792 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793AbaEQOYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 10:24:31 -0400
Message-ID: <53777113.3070909@gmail.com>
Date: Sat, 17 May 2014 16:24:19 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 2/9] dt: deps: dependency based device creation
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>	<1399913280-6915-3-git-send-email-holler@ahsoftware.de> <20140514140534.897F8C4153D@trevor.secretlab.ca>
In-Reply-To: <20140514140534.897F8C4153D@trevor.secretlab.ca>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 14.05.2014 16:05, Grant Likely wrote:
> On Mon, 12 May 2014 18:47:53 +0200, Alexander Holler <holler@ahsoftware.de> wrote:
>> Use the properties named 'dependencies' in binary device tree blobs to build
>> a dependency based initialization order for platform devices and drivers.
>>
>> This is done by building a directed acyclic graph using an adjacency list
>> and doing a topological sort to retrieve the order in which devices/drivers
>> should be created/initialized.
>>
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> 
> Hi Alexander,
> 
> Thanks for looking at this. It is a difficult problem. I've made
> comments below, but first I've got some general comments...
> 
> First, I'm going to be very cautious about this. It is a complicated
> piece of code making the device initialization process a lot more
> complicated than it already is. I'm the first one to admit that deferred
> probe handles the problem in quite a naive manner, but it is simple,
> correct (when drivers support deferred probe) and easy to audit. This
> series digs deep into the registration order of *both* devices and
> drivers which gives me the heebee jeebees.
> 
> Personally, I think the parts of this patch that manipulate the device registration
> order is entirely the wrong way to handle it. If anything, I would say
> continue to register the devices, even if the dependencies are unmet.
> Instead, I would focus on the driver core (drivers/base) to catch
> device probe attempts when a known dependency is not met, remember it,
> and perform the probe after the other driver shows up. That is also
> going to be a complicated bit of code, but it works for every kind of
> device, not just platform_devices, and has far less impact on the
> platform setup code.

Grant, I tend to disagree with you on this. While Alexander's solution
has certain flaws (that I'm going to list further in my reply), I also
believe that an approach based on device registration order is most
likely the way to go. As compared to other possible approaches, here is
the list of advantages I can see (in random order):

1) If compared with resource-based approach, when you detect
dependencies at runtime, based on existing resource specifiers (GPIOs,
clocks, etc.), you don't need to change anything in the implementation
whenever a new kind of resources is introduced. Moreover, there is no
need to make device probing code aware of any resources or dependencies,
because all you need to do is to register devices in certain order, as
defined by precompiled dependency lists.

2) If implemented properly, it helps solving problem of binding proper
driver to a device with multiple compatible strings. Current way of
handling this by Linux is _broken_, because the device will be bound to
first driver that shows up and contains matching compatible string in
its match table. Notice that this way the whole idea of having multiple
compatible strings specified from most specific to most generic is made
useless. Now you may wonder how both problems relate. Basically in both
cases you need to wait until drivers for devices are available (e.g.
registered in system-wide list), either to guarantee that registering a
device means probing it (in first case) or to look through the list of
available drivers and select the one that is a best match (in second case).

3) DeviceTree is not the only firmware "interface" supported by Linux
and so I'd be careful with pushing this into generic driver core that is
also shared with board files and ACPI and possibly something else I'm
not aware of. Moreover, I think the existing driver core is already
quite complex and complicating it even more might not be the best idea,
unless really the only option.

4) This approach is far less complicated than anything mentioned above.
What's so complicated in creating a graph of devices and registering
them in certain order?

> 
> BTW, this has to be able to work at the level of struct device instead
> of struct platform_device. There are far more kinds of devices than just
> platform_device, and they all have the same problem.

Agreed.

> Also, may I suggest that the more pieces that you can break this series
> up into, the greater chance you'll have of getting a smaller subset
> merged earlier if it can be proven to be useful on its own.

Agreed. It is usually a good idea to separate things that could live on
their own and be useful.

Now, I'll spare myself from judging the code, as until we get an
accepted design, I don't think there is any point in discussing about
implementation details, not even mentioning things like coding style
(which is important, but not when much of the code might still be
rewritten completely).

OK, so I mentioned above what I like in this kind of approach. Now let's
move to what I don't like.

I think the part that alters driver registration and initcalls isn't
really necessary. With current code, we can see that initcalls
themselves (not driver code in terms of driver model) are already well
ordered, as things happening there seems to work, without any need to
defer anything. Now Alexander's approach relies on
module_platform_driver() and similar macros to obtain the list of
platform_drivers in the system, but I think this isn't necessary either.

Now this is just a bit of guessing, as I still haven't been able to
allocate time to take a deeper look into initcall and driver code, but
what if we let the initcalls do their work, let's say up to
late_initcall level and only then register drivers in our precomputed
order? We seem to be already relying an assumption that on late_initcall
level the devices should be already probed, as we have various calls
disabling unused resources, such as regulators and clocks, at this
level. I can see certain drivers being registered in late_initcalls, but
this would be after our device registration, so most of dependencies
should be already there and if not, we still have deferred probing.

With such design in place, we would be able to also solve the other
problem I mentioned above, the problem of matching devices with most
appropriate drivers. Since at device registration and probing time,
(almost) all the drivers would be already available, the matching code
could select the right one to bind.

Alright, that's my take on this. Looking forward to your comments.

Best regards,
Tomasz
