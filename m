Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbaEGPRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:17:32 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37676 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaEGPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:17:31 -0400
MIME-Version: 1.0
In-Reply-To: <53698380.1060006@gmail.com>
References: <536982E3.10303@gmail.com> <53698380.1060006@gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Wed, 7 May 2014 16:17:10 +0100
X-Google-Sender-Auth: dOTGTGfl4DN42FoUNgj6q0yaeoM
Message-ID: <CACxGe6tczi3Vjj44SvXNf+qER0LE_zGd83dJEQauyzD0H8=VMw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] devicetree: set bus type same as parent
To: Frank Rowand <frowand.list@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 1:51 AM, Frank Rowand <frowand.list@gmail.com> wrote:
> From: Frank Rowand <frank.rowand@sonymobile.com>
>
> This is a somewhat scary patch since it touches a path that is central to
> device creation based on the device tree.  It should not be applied without
> careful consideration.
>
> I am not sure if this patch is a good idea, even if it does not break
> anything.
>
> An issue with the path of SPMI nodes under /sys/bus/... was reported in
> https://lkml.org/lkml/2014/4/23/312.  The symptom is that two different
> grandchild nodes of the spmi with the same node-name@unit-address will
> result in attempting to create duplicate links at
> /sys/bus/platform/devices/unit-address.node-name.  It turns out that the
> specific example provided might not be an expected configuration for
> current hardware, but the reported trap remains an issue.
>
> The common pattern exposed is a driver probe function calling
> of_platform_populate() to create child devices.  As the reporting
> email noted, the devices are created with dev.bus set to
> platform_bus_type.  Thus all devices created via this pattern will
> result in a link in /sys/bus/platform/devices/, with the risk that
> a name collision will occur.
>
> This patch reduces the scope of possible name collisions to devices
> on the same bus type.  This is still not ideal, because a legal
> device tree source file can result in run time errors.  In the case
> of SPMI nodes, the collisions will occur in /bus/spmi/devices/.
>
> I have not investigated whether other drivers would be negatively impacted
> by this change - there are 26 drivers in tree that call of_platform_populate().
>
> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
> ---
>  drivers/of/platform.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> Index: b/drivers/of/platform.c
> ===================================================================
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -217,7 +217,10 @@ static struct platform_device *of_platfo
>         dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
>         if (!dev->dev.dma_mask)
>                 dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
> -       dev->dev.bus = &platform_bus_type;
> +       if (parent && parent->bus)
> +               dev->dev.bus = parent->bus;
> +       else
> +               dev->dev.bus = &platform_bus_type;

Yeah, this is a very wrong thing to do. It makes the device accessible
to the other bus types behaviour and most likely will result in
container_of() being used on the struct device to get the other bus
types container structure. It is a very bad idea.

I also suspect that you're conflating the concept of a bus_type and
the instance of a bus (like the platform bus) in the /sys/devices/
hierarchy. Among other things, a bus_type contains a list of drivers
and a list of devices that can potentially be bound together because
they use the same interface.

"platform_bus" on the other hand isn't really a device at all. It is a
bare struct device with no bus type and no behaviour. It exists merely
as a container for other devices. By default, any platform_device that
gets registered will be added as a child of platform_bus unless the
parent pointer is already assigned to something else.

The device hierarchy can pretty much be anything. A child can have any
bus type regardless of the bus type of the parent. Individual
subsystems will put restrictions on this (ie. all children of i2c bus
instances will use the i2c bus type), but the driver core is very
flexible.

The reason we use platform_bus_type so extensively is that there are a
very large number of devices that don't have any bus behaviour
expectations. No hot plug. No auto detection. Usually memory mapped.
The device just exists and is immediately accessible by the system.

g.

>         dev->dev.platform_data = platform_data;
>
>         /* We do not fill the DMA ops for platform devices by default.
