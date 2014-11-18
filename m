Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbaKRQhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:37:34 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:51770 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaKRQha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:37:30 -0500
MIME-Version: 1.0
In-Reply-To: <1415841047.5124.62.camel@kernel.crashing.org>
References: <1415342031.4925.27.camel@kernel.crashing.org> <1415342117.4925.29.camel@kernel.crashing.org>
 <1415596626.5769.14.camel@kernel.crashing.org> <CAL_JsqKG=vpeGKj3v-2VW9oGQsnmuYMHRfy6LuXDXE=ROjHT4w@mail.gmail.com>
 <1415841047.5124.62.camel@kernel.crashing.org>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 18 Nov 2014 10:37:08 -0600
Message-ID: <CAL_Jsq+YyfMWxiOFv4x3g5hZJH0XRqCKj2He1XO9eyXWjHTMrg@mail.gmail.com>
Subject: Re: [PATCH] drivers/core/of: Add symlink to device-tree from devices
 with an OF node
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jeremy Kerr <jeremy.kerr@au1.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 7:10 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> So I've been annoyed lately with having a bunch of devices such as i2c
> eeproms (for use by VPDs, server world !) and other bits and pieces that
> I want to be able to identify from userspace, and possibly provide
> additional data about from FW.
>
> Basically, it boils down to correlating the sysfs device with the OF
> tree device node, so that user space can use device-tree info such as
> additional "location" or "label" (or whatever else we can come up with)
> propreties to identify a given device, or get some attributes of use
> about it, etc...
>
> Now, so far, we've done that in some subsystem in a fairly ad-hoc basis
> using "devspec" properties. For example, PCI creates them if it can
> correlate the probed device with a DT node. Some powerpc specific busses
> do that too.
>
> However, i2c doesn't and it would be nice to have something more generic
> since technically any device can have a corresponding device tree node.
>
> This patch adds an "of_node" symlink to devices that have a non-NULL
> dev->of_node pointer, the patch is pretty trivial and seems to work just
> fine for me.
>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 20da3ad..8c7b607 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -493,6 +493,15 @@ static int device_add_attrs(struct device *dev)
>                         goto err_remove_dev_groups;
>         }
>
> +#ifdef CONFIG_OF
> +       if (dev->of_node) {

if (IS_ENABLED(CONFIG_OF) && dev->of_node)

> +               error = sysfs_create_link(&dev->kobj, &dev->of_node->kobj,
> +                                         "of_node");
> +               if (error)
> +                       dev_warn(dev, "Error %d creating of_node link\n", error);
> +       }
> +#endif /* CONFIG_OF */
> +
>         return 0;
>
>   err_remove_dev_groups:
>
>
