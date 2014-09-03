Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbaICIHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:07:20 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:35111 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbaICIHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:07:08 -0400
MIME-Version: 1.0
In-Reply-To: <1409159852-7249-2-git-send-email-mathieu.poirier@linaro.org>
References: <1409159852-7249-1-git-send-email-mathieu.poirier@linaro.org>
	<1409159852-7249-2-git-send-email-mathieu.poirier@linaro.org>
Date: Wed, 3 Sep 2014 10:07:07 +0200
Message-ID: <CACRpkdZapQ5UeOQfO4g+Vz6r2V2R5OJUrkm9eKbm6uBJZObb9w@mail.gmail.com>
Subject: Re: [PATCH 01/11 v5] coresight: add CoreSight core layer framework
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        Kaixu Xia <kaixu.xia@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>, r.sengupta@samsung.com,
        Robert Marklund <robbelibobban@gmail.com>, Tony.Armitstead@arm.com,
        Patch Tracking <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 7:17 PM,  <mathieu.poirier@linaro.org> wrote:

> From: Pratik Patel <pratikp@codeaurora.org>
>
> CoreSight components are compliant with the ARM CoreSight
> architecture specification and can be connected in various
> topologies to suite a particular SoCs tracing needs. These trace
> components can generally be classified as sources, links and
> sinks. Trace data produced by one or more sources flows through
> the intermediate links connecting the source to the currently
> selected sink.
>
> CoreSight framework provides an interface for the CoreSight trace
> drivers to register themselves with. It's intended to build up a
> topological view of the CoreSight components and configure the
> right series of components on user input via debugfs.
>
> For eg., when enabling a source, framework builds up a path
> consisting of all the components connecting the source to the
> currently selected sink(s) and enables all of them.
>
> The framework also supports switching between available sinks
> and also provides status information to user space applications
> through the debugfs interface.
>
> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
> Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
(...)

> +       pr_err("coresight: couldn't find inport, parent: %d, child: %d\n",
> +              parent->id, csdev->id);

Instead of repitetively prefixing all debug prints with "coresight:" like this,
at the top of the file do this:

#define pr_fmt(fmt) "coresight: " fmt

Then just pr_err(couldn't find...\n");

Try it, it's cool!

Same thing for the other files using such prints. NB: has to be
in each .c file, a shared .h may affect unwanted stuff.

> +static int coresight_enable_sink(struct coresight_device *csdev)
> +{
> +       int ret;
> +
> +       if (csdev->refcnt.sink_refcnt == 0) {
> +               if (sink_ops(csdev)->enable) {
> +                       ret = sink_ops(csdev)->enable(csdev);
> +                       if (ret)
> +                               goto err;

Convoluted, just

  return err;

here.

> +                       csdev->enable = true;
> +               }
> +       }
> +       csdev->refcnt.sink_refcnt++;

There is quite a lot of refcounting code in this file.

Why can't <linux/kref.h> be used instead of inventing a custom
reference counter?

I think it could cut down the code a bit and make it even cleaner.

> +
> +       return 0;
> +err:
> +       return ret;
> +}

And skip that exit goto label.

> +static void coresight_disable_sink(struct coresight_device *csdev)
> +{
> +       if (csdev->refcnt.sink_refcnt == 1) {
> +               if (sink_ops(csdev)->disable) {
> +                       sink_ops(csdev)->disable(csdev);
> +                       csdev->enable = false;
> +               }
> +       }
> +       csdev->refcnt.sink_refcnt--;
> +}

So with kref you would just kref_put(kref, release) it and this
cleanup function would get called from the release function
when the ref goes to zero. Which is what you want.

> +static int coresight_enable_link(struct coresight_device *csdev)
> +{
> +       int ret;
> +       int link_subtype;
> +       int refport, inport, outport;
> +
> +       inport = coresight_find_link_inport(csdev);
> +       outport = coresight_find_link_outport(csdev);
> +
> +       link_subtype = csdev->subtype.link_subtype;
> +       if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG)
> +               refport = inport;
> +       else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT)
> +               refport = outport;
> +       else
> +               refport = 0;
> +
> +       if (csdev->refcnt.link_refcnts[refport] == 0) {
> +               if (link_ops(csdev)->enable) {
> +                       ret = link_ops(csdev)->enable(csdev, inport, outport);
> +                       if (ret)
> +                               goto err;

Just return err;

> +                       csdev->enable = true;
> +               }
> +       }

More refcounting, see.

> +       csdev->refcnt.link_refcnts[refport]++;
> +
> +       return 0;
> +err:
> +       return ret;
> +}

Get rid of err label.

(...)
> +static void coresight_disable_source(struct coresight_device *csdev)
> +{
> +       if (csdev->refcnt.source_refcnt == 1) {
> +               if (source_ops(csdev)->disable) {
> +                       source_ops(csdev)->disable(csdev);
> +                       csdev->enable = false;
> +               }
> +       }
> +       csdev->refcnt.source_refcnt--;
> +}

Again, kref is your friend.

> +static int coresight_build_paths(struct coresight_device *csdev,
> +                                struct list_head *path,
> +                                bool enable)
> +{
> +       int i, ret = -1;

-1 is not a proper error code.

> +       struct coresight_connection *conn;
> +
> +       list_add(&csdev->path_link, path);
> +
> +       if (csdev->type == CORESIGHT_DEV_TYPE_SINK && csdev->activated) {
> +               if (enable)
> +                       ret = coresight_enable_path(path);
> +               else
> +                       ret = coresight_disable_path(path);
> +       } else {
> +               for (i = 0; i < csdev->nr_conns; i++) {
> +                       conn = &csdev->conns[i];
> +                       if (coresight_build_paths(conn->child_dev,
> +                                                   path, enable) == 0)
> +                               ret = 0;
> +               }
> +       }
> +
> +       if (list_first_entry(path, struct coresight_device, path_link) != csdev)
> +               pr_err("coresight: wrong device in %s\n", __func__);
> +
> +       list_del(&csdev->path_link);
> +       return ret;
> +}
(...)

> +static ssize_t debugfs_active_get(void *data, u64 *val)
> +{
> +       struct coresight_device *csdev = data;
> +
> +       *val = csdev->activated;
> +       return 0;
> +}
> +
> +static ssize_t debugfs_active_set(void *data, u64 val)
> +{
> +       struct coresight_device *csdev = data;
> +
> +       val ? (csdev->activated = 1) : (csdev->activated = 0);

It looks vert much like csdev->activated is a bool and this should
assign true or false.

Using the ? operator like that is a bit stressful for me, why not
just use this funky boolean-clamp idiom:

csdev->activated = !!val;

(...)
> +static int debugfs_coresight_init(void)
> +{
> +       if (!cs_debugfs_parent) {
> +               cs_debugfs_parent = debugfs_create_dir("coresight", 0);
> +               if (IS_ERR(cs_debugfs_parent))
> +                       return -1;

return PTR_ERR(cs_debugfs_parent);

> +       }
> +
> +       return 0;
> +}

(...)
> +/*
> + * return 1 if the bit @position in @val is set to @value
> + */
> +int coresight_is_bit_set(u32 val, int position, int value)
> +{
> +       val &= BIT(position);
> +       val >>= position;
> +       return (val == value);
> +}

This is just too overengineered. The value can only be zero or one!
Can't you just inline and please replace *all* uses of this function from
like:

if (coresight_is_bit_set(foo, bar, baz)) {
   ...
}

to

if (foo & BIT(bar)) {
   ...
}

> +void coresight_timeout(void __iomem *addr, u32 offset, int position, int value)
> +{
> +       int i;
> +       u32 val;
> +
> +       for (i = TIMEOUT_US; i > 0; i--) {
> +               val = __raw_readl(addr + offset);
> +               if (coresight_is_bit_set(val, position, value))
> +                       return;
> +               udelay(1);

Why 1 us? Add a comment. Does this vary with silicon?

> +       }
> +
> +       WARN(1,
> +            "coresight: timeout observed when proving at offset %#x\n",
> +            offset);
> +}

(...)
> diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
(...)
> new file mode 100644
> index 0000000..f90a024
> --- /dev/null
> +++ b/drivers/coresight/of_coresight.c
> @@ -0,0 +1,202 @@
> +/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/err.h>
> +#include <linux/slab.h>
> +#include <linux/clk.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_graph.h>
> +#include <linux/coresight.h>
> +#include <asm/smp_plat.h>
> +
> +static int of_get_coresight_id(struct device_node *node, int *id)
> +{
> +       const __be32 *reg;
> +       u64 addr;
> +
> +       /* derive component id from its memory map */
> +       reg = of_get_property(node, "reg", NULL);
> +       if (reg) {
> +               addr = of_translate_address(node, reg);
> +               if (addr != OF_BAD_ADDR) {
> +                       *id = addr;
> +                       return 0;
> +               }
> +       }
> +
> +       /* no "reg", we have a non-configurable replicator */
> +       reg = of_get_property(node, "id", NULL);
> +       if (reg) {
> +               *id = of_read_ulong(reg, 1);
> +               return 0;
> +       }
> +
> +       return -1;

return -EINVAL?

(...)
> +static bool of_coresight_is_input_port(struct device_node *port)
> +{
> +       return of_find_property(port, "slave-mode", NULL);
> +}

Can't you just replace this at the place where it's used with:

if (of_coresight_is_input_port(np)) ...

Instead:

if (of_property_read_bool(np, "slave-mode")) ...

And skip this extra function.

If you absolutely want that helper function name make
the preprocessor inline it:

#define of_coresight_is_input_port(a) of_property_read_bool(a, "slave-mode")

> +static void of_coresight_get_ports(struct device_node *node,
> +                                  int *nr_inports, int *nr_outports)
> +{
> +       struct device_node *ep = NULL;
> +       int in = 0, out = 0;
> +
> +       do {
> +               ep = of_get_coresight_endpoint(node, ep);
> +               if (!ep)
> +                       break;
> +               of_coresight_is_input_port(ep) ? in++ : out++;

Aha there is one such construction again. Well I'd just

if (of_property_read_bool(ep, "slave-mode"))
   in++
else
  out++;

But I guess you maybe really like the ? operator so no
big deal.

(...)
> +struct coresight_platform_data *of_get_coresight_platform_data(
> +                               struct device *dev, struct device_node *node)
> +{
> +       int id, i = 0, ret = 0;
> +       struct device_node *cpu;
> +       struct coresight_platform_data *pdata;
> +       struct of_endpoint endpoint, rendpoint;
> +       struct device_node *ep = NULL;
> +       struct device_node *rparent = NULL;
> +       struct device_node *rport = NULL;
> +
> +       pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +       if (!pdata)
> +               return ERR_PTR(-ENOMEM);
> +
> +       /* use the base address as id */
> +       ret = of_get_coresight_id(node, &id);
> +       if (ret)
> +               return ERR_PTR(-EINVAL);

Just propagate the error code:

return ERR_PTR(ret);

> +       pdata->id = id;
> +
> +       /* use device name as debugfs handle */
> +       pdata->name = dev_name(dev);
> +
> +       /* get the number of input and output port for this component */
> +       of_coresight_get_ports(node, &pdata->nr_inports, &pdata->nr_outports);
> +
> +       if (pdata->nr_outports) {
> +               ret = of_coresight_alloc_memory(dev, pdata);
> +               if (ret)
> +                       return ERR_PTR(-ENOMEM);

return ERR_PTR(ret);

(...)
> diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
> @@ -23,6 +23,7 @@
>
>  #define AMBA_NR_IRQS   9
>  #define AMBA_CID       0xb105f00d
> +#define CORESIGHT_CID  0xb105900d

These guys really have a sense of humour.

> diff --git a/include/linux/coresight.h b/include/linux/coresight.h
(...)

> +struct coresight_platform_data {
> +       int id;
> +       int cpu;
> +       const char *name;
> +       int nr_inports;
> +       int *outports;
> +       int *child_ids;
> +       int *child_ports;
> +       int nr_outports;
> +       struct clk *clk;
> +};

This struct could maybe need some kerneldoc. Not all members
are self-evident.

(...)
> +struct coresight_refcnt {
> +       int sink_refcnt;
> +       int *link_refcnts;
> +       int source_refcnt;
> +};

So I suggest replacing this with kref.

> +struct coresight_device {
> +       int id;
> +       struct coresight_connection *conns;
> +       int nr_conns;
> +       enum coresight_dev_type type;
> +       struct coresight_dev_subtype subtype;
> +       const struct coresight_ops *ops;
> +       struct dentry *de;
> +       struct device dev;
> +       struct coresight_refcnt refcnt;
> +       struct list_head dev_link;
> +       struct list_head path_link;
> +       struct module *owner;
> +       bool enable;    /* true only if configured as part of a path */
> +       bool activated; /* only valid for sinks */
> +};

Hey it is bool ... yet the code assigns 0/1 instead of false/true
in most places.

Yours,
Linus Walleij
