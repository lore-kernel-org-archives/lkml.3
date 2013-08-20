Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979Ab3HTKNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:13:46 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:41976 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab3HTKNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:13:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130820120105.55a4c0ce@armhf>
References: <20130820120105.55a4c0ce@armhf>
From: Grant Likely <grant.likely@linaro.org>
Date: Tue, 20 Aug 2013 11:13:24 +0100
X-Google-Sender-Auth: Z7QWHaOC1ucOwZc_GGVuJb4q1OI
Message-ID: <CACxGe6vNKoi47-R3H2sYUhGuX5Lh0nokWaj6Bzw2zv2U0_Wgsg@mail.gmail.com>
Subject: Re: [PATCH] of: reduce the number of PROBE_DEFERs
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 11:01 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
> This patch populates the platform from the device tree into two steps:
> the first step creates the nodes that are referenced by a phandle,
> the second step creates the other nodes.
>
> This permits to reduce the number of PROBE_DEFERs.
>
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
> A better way to reduce probe deferral could be sorting the nodes
> according to their phandle level in the DT blob at compilation time ...

Have you got measurements or statistics that show this making a
difference? I suspect you'll find for boot time it will have little to
no affect since the device driver probe order is more closely related
to the kernel link order than the order that devices were registered.

g.

> ---
>  drivers/of/platform.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index e0a6514..a2ea858 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -382,8 +382,23 @@ static int of_platform_bus_create(struct device_node *bus,
>         if (!dev || !of_match_node(matches, bus))
>                 return 0;
>
> +       /* first step: create the nodes that are referenced by phandle */
>         for_each_child_of_node(bus, child) {
> -               pr_debug("   create child: %s\n", child->full_name);
> +               if (child->phandle == 0)
> +                       continue;
> +               pr_debug("   create child 1: %s\n", child->full_name);
> +               rc = of_platform_bus_create(child, matches, lookup, &dev->dev, strict);
> +               if (rc) {
> +                       of_node_put(child);
> +                       return rc;
> +               }
> +       }
> +
> +       /* second step: create the other nodes */
> +       for_each_child_of_node(bus, child) {
> +               if (child->phandle != 0)
> +                       continue;
> +               pr_debug("   create child 2: %s\n", child->full_name);
>                 rc = of_platform_bus_create(child, matches, lookup, &dev->dev, strict);
>                 if (rc) {
>                         of_node_put(child);
>
>
> --
> Ken ar c'hentañ |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
