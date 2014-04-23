Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbaDWOoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:44:34 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:55912 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbaDWOob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:44:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140423140508.2575AC408D2@trevor.secretlab.ca>
References: <1353509071-8658-1-git-send-email-grant.likely@secretlab.ca>
 <CAL_JsqJFM1e2Y7GykK06KuZ8fD8iZ=64W1i+tqibJ9datCUR0Q@mail.gmail.com> <20140423140508.2575AC408D2@trevor.secretlab.ca>
From: Grant Likely <grant.likely@linaro.org>
Date: Wed, 23 Apr 2014 15:44:10 +0100
X-Google-Sender-Auth: eET7HbH5UMuxj1CQcd-zSsc30Ck
Message-ID: <CACxGe6vT82JyLY7_DmUdA292R40XyqVi+5gn6khobHS_LvnRdA@mail.gmail.com>
Subject: Re: [RFC] driver-core: Remove dummy 'platform_bus'
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 3:05 PM, Grant Likely <grant.likely@linaro.org> wrote:
> On Mon, 21 Apr 2014 16:05:29 -0500, Rob Herring <robherring2@gmail.com> wrote:
>> On Wed, Nov 21, 2012 at 8:44 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> > The "platform_bus" (note: not platform_bus_type) only exists as an empty
>> > directory to put platform devices into. However, it really doesn't make
>> > sense to segregate all the platform devices into a sub directory when
>> > typically they are memory mapped devices that doen't go through any
>> > particular bus. Particularly on embedded type platforms the platform_bus
>> > directory doesn't add anything.
>> >
>> > However, this will probably just end up breaking some userspace that
>> > depends on the /sys/devices/platform/ path to be present (no matter how
>> > much we protest that userspace must not depend on paths in sysfs). So
>> > while I'm seriously proposing this change, it may just be unacceptable
>> > ABI breakage
>>
>> An old thread, but was there ever a conclusion to this? We now have a
>> mixture of using platform_bus as the parent or not on various ARM
>> platforms.
>
> We kind of concluded in the opposite direction. Instead of removing the
> /sys/device/platform directory, the drivers/of code should be changed to
> use it.
>
> The following patch is sufficient to have the same effect. It doesn't
> unify the OF and non-OF paths of platform device addition, but it gets
> them closer. I've been nervous about applying it because I'm concerned
> about userspace breakage, but maybe it just needs to be merged and we
> can quirk out systems that break.

Ugh, no matter what we do, something is going to be inconsistent. With
this patch, the platform_devices get moved under
/sys/devices/platform, but an amba_device at the top level stays where
it is. We could move amba devices under the same hierarchy, but that
doesn't seem appropriate.

We could have a separate /sys/devices/of hierarchy for generating
devices into if this really is a problem that needs to be solved. I'm
not convinced that a real problem exists though. PowerPC has been
creating the devices directly under /sys/devices at least since
2.6.12. With the DT being hierarchical to begin with, and the dt code
preserving the hierarchy, on most platforms there won't be a lot of
things at the root.

Anyway, whatever. I don't care enough to argue anymore. Move them if
you like, but make sure the root AMBA devices get created in the same
place.

g.

>
> ---
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 404d1daebefa..40a85b85c932 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -175,7 +175,7 @@ struct platform_device *of_device_alloc(struct device_node *np,
>  #if defined(CONFIG_MICROBLAZE)
>         dev->dev.dma_mask = &dev->archdata.dma_mask;
>  #endif
> -       dev->dev.parent = parent;
> +       dev->dev.parent = parent ? parent : &platform_bus;
>
>         if (bus_id)
>                 dev_set_name(&dev->dev, "%s", bus_id);
>
