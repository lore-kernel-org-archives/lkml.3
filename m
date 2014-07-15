Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbaGOUwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:52:39 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:63461 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbaGOUwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:52:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKagkczEK8WZx3-gxzz3mquZ0rQLsaZrVO-bPP4+BtVMw@mail.gmail.com>
References: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org>
	<1403892261-25026-2-git-send-email-mathieu.poirier@linaro.org>
	<CAL_JsqKagkczEK8WZx3-gxzz3mquZ0rQLsaZrVO-bPP4+BtVMw@mail.gmail.com>
Date: Tue, 15 Jul 2014 21:52:35 +0100
Message-ID: <CANLsYkwi-4sF1LZ4+318KP7HLm4OUWMKWnbAR0D3Dmx4OaB5PQ@mail.gmail.com>
Subject: Re: [PATCH 1/9 v2] coresight: add CoreSight core layer framework
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        Arnd Bergmann <arnd@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>,
        "r.sengupta@samsung.com" <r.sengupta@samsung.com>,
        Robert Marklund <robbelibobban@gmail.com>,
        Tony Armitstead <Tony.Armitstead@arm.com>,
        Linaro Patches <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snip...

>> +static void of_coresight_get_ports(struct device_node *node,
>> +                                  int *nr_inports, int *nr_outports)
>> +{
>> +       struct device_node *ep = NULL;
>> +       int in = 0, out = 0;
>> +
>> +       do {
>> +               ep = of_get_coresight_endpoint(node, ep);
>
> Does for_each_child_of_node not work here?

Using for_each_child_of_node yields the first child of that node,
which may or may not be "ports" or "port".  By using
of_get_coresight_endpoint we let of_graph_get_next_endpoint to deal
with that hierarchy.  Moreover the latter will also deal with the
hierarchy of port under ports, something that would need to be
duplicated if for_each_child_of_node was used.

Get back to me if you disagree.

>
>> +               if (!ep)
>> +                       break;
>> +               of_coresight_is_input_port(ep) ? in++ : out++;
>> +
>> +       } while (ep);
>> +
>> +       *nr_inports = in;
>> +       *nr_outports = out;
>> +}
>> +
>> +static int of_coresight_alloc_memory(struct device *dev,
>> +                       struct coresight_platform_data *pdata)
>> +{
>> +       /* list of output port on this component */
>> +       pdata->outports = devm_kzalloc(dev, pdata->nr_outports *
>> +                                      sizeof(*pdata->outports),
>> +                                      GFP_KERNEL);
>> +       if (!pdata->outports)
>> +               return -ENOMEM;
>> +
>> +
>> +       /* children connected to this component via @outport */
>> +       pdata->child_ids = devm_kzalloc(dev, pdata->nr_outports *
>> +                                       sizeof(*pdata->child_ids),
>> +                                       GFP_KERNEL);
>> +       if (!pdata->child_ids)
>> +               return -ENOMEM;
>> +
>> +       /* port number on the child this component is connected to */
>> +       pdata->child_ports = devm_kzalloc(dev, pdata->nr_outports *
>> +                                         sizeof(*pdata->child_ports),
>> +                                         GFP_KERNEL);
>> +       if (!pdata->child_ports)
>> +               return -ENOMEM;
>> +
>> +       return 0;
>> +}
>> +
>> +struct coresight_platform_data *of_get_coresight_platform_data(
>> +                               struct device *dev, struct device_node *node)
>> +{
>> +       u32 id;
>> +       int i = 0, ret = 0;
>> +       struct device_node *cpu;
>> +       struct coresight_platform_data *pdata;
>> +       struct of_endpoint endpoint, rendpoint;
>> +       struct device_node *ep = NULL;
>> +       struct device_node *rparent = NULL;
>> +       struct device_node *rport = NULL;
>> +
>> +       pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>> +       if (!pdata)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       /* use the base address as id */
>> +       id = of_get_coresight_id(node);
>> +       if (id == 0)
>> +               return  ERR_PTR(-EINVAL);
>> +
>> +       pdata->id = id;
>> +
>> +       /* use device name as debugfs handle */
>> +       pdata->name = dev_name(dev);
>> +
>> +       /* get the number of input and output port for this component */
>> +       of_coresight_get_ports(node, &pdata->nr_inports, &pdata->nr_outports);
>> +
>> +       if (pdata->nr_outports) {
>> +               ret = of_coresight_alloc_memory(dev, pdata);
>> +               if (ret)
>> +                       return ERR_PTR(-ENOMEM);
>> +
>> +               /* iterate through each port to discover topology */
>> +               do {
>> +                       /* get a handle on a port */
>> +                       ep = of_get_coresight_endpoint(node, ep);
>> +                       if (!ep)
>> +                               break;
>
> for_each_child_of_node

Same as above.

>
>> +
>> +                       /* no need to deal with input ports, processing for as
>> +                        * processing for output ports will deal with them.
>> +                        */
>> +                       if (of_coresight_is_input_port(ep))
>> +                               continue;
>> +
>> +                       /* get a handle on the local endpoint */
>> +                       ret = of_graph_parse_endpoint(ep, &endpoint);
>> +
>> +                       if (!ret) {
>
> You can save some indentation with:
>
> if (ret)
>  continue;
>
>> +                               /* the local out port number */
>> +                               *(u32 *)&pdata->outports[i] = endpoint.id;
>
> Can't you avoid this casting?
>
>> +
>> +                               /* get a handle the remote port and parent
>> +                                * attached to it.
>> +                                */
>> +                               rparent = of_graph_get_remote_port_parent(ep);
>> +                               rport = of_graph_get_remote_port(ep);
>> +
>> +                               if (!rparent || !rport)
>> +                                       continue;
>> +
>> +                               if (of_graph_parse_endpoint(rport,
>> +                                                            &rendpoint))
>> +                                       continue;
>> +
>> +                               *(u32 *)&pdata->child_ids[i] =
>> +                                       of_get_coresight_id(rparent);
>> +                               *(u32 *)&pdata->child_ports[i] = rendpoint.id;
>
> and these?
>
>> +
>> +                               i++;
>> +                       }
>> +
>> +               } while (ep);
>> +       }
>> +
>> +       pdata->default_sink = of_property_read_bool(node,
>> +                                                   "coresight-default-sink");
>> +
>> +       /* affinity defaults to CPU0 */
>> +       pdata->cpu = 0;
>> +       cpu = of_parse_phandle(node, "cpu", 0);
>> +       if (cpu) {
>> +               const u32 *mpidr;
>> +               int len, index;
>> +
>> +               mpidr = of_get_property(cpu, "reg", &len);
>> +               if (mpidr && len == 4) {
>> +                       index = get_logical_index(be32_to_cpup(mpidr));
>
> Don't we have some helper for translating a cpu phandle to logical index?

I haven't found one - the same trickery can be found in [1] [2]. Even
the very recent 64 bit implementation doesn't use a helper function
[3].  The opposite direction i.e, going from a logical CPU to a
device_node, has a helper function.  If you have something on the top
of your mind I'd like to know.

[1]. arch/arm/kernel/devtree.c, (arm_dt_init_cpu_maps)
[2]. arch/powerpc/kernel/smp.c, (cpu_to_corei_id)
[3]. arch/arm64/kernel/smp.c, (smp_init_cpus)

>
>> +                       if (index != -EINVAL)
>> +                               pdata->cpu = index;
>> +               }
>> +       }
>> +
>> +       return pdata;
>> +}
>> +EXPORT_SYMBOL_GPL(of_get_coresight_platform_data);
>> diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
>> index fdd7e1b..cdddabe 100644
>> --- a/include/linux/amba/bus.h
>> +++ b/include/linux/amba/bus.h
>> @@ -23,6 +23,7 @@
>>
>>  #define AMBA_NR_IRQS   9
>>  #define AMBA_CID       0xb105f00d
>> +#define CORESIGHT_CID  0xb105900d
>>
>>  struct clk;
>>
>> diff --git a/include/linux/coresight.h b/include/linux/coresight.h
>> new file mode 100644
>> index 0000000..a19420e
>> --- /dev/null
>> +++ b/include/linux/coresight.h
>> @@ -0,0 +1,190 @@
>> +/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef _LINUX_CORESIGHT_H
>> +#define _LINUX_CORESIGHT_H
>> +
>> +#include <linux/device.h>
>> +
>> +/* Peripheral id registers (0xFD0-0xFEC) */
>> +#define CORESIGHT_PERIPHIDR4   (0xFD0)
>> +#define CORESIGHT_PERIPHIDR5   (0xFD4)
>> +#define CORESIGHT_PERIPHIDR6   (0xFD8)
>> +#define CORESIGHT_PERIPHIDR7   (0xFDC)
>> +#define CORESIGHT_PERIPHIDR0   (0xFE0)
>> +#define CORESIGHT_PERIPHIDR1   (0xFE4)
>> +#define CORESIGHT_PERIPHIDR2   (0xFE8)
>> +#define CORESIGHT_PERIPHIDR3   (0xFEC)
>> +/* Component id registers (0xFF0-0xFFC) */
>> +#define CORESIGHT_COMPIDR0     (0xFF0)
>> +#define CORESIGHT_COMPIDR1     (0xFF4)
>> +#define CORESIGHT_COMPIDR2     (0xFF8)
>> +#define CORESIGHT_COMPIDR3     (0xFFC)
>> +
>> +#define ETM_ARCH_V3_3          (0x23)
>> +#define ETM_ARCH_V3_5          (0x25)
>> +#define PFT_ARCH_V1_1          (0x31)
>> +
>> +#define CORESIGHT_UNLOCK       (0xC5ACCE55)
>
> Parentheses are not necessary.
>
>> +enum coresight_clk_rate {
>> +       CORESIGHT_CLK_RATE_OFF,
>> +       CORESIGHT_CLK_RATE_TRACE,
>> +       CORESIGHT_CLK_RATE_HSTRACE,
>> +};
>> +
>> +enum coresight_dev_type {
>> +       CORESIGHT_DEV_TYPE_NONE,
>> +       CORESIGHT_DEV_TYPE_SINK,
>> +       CORESIGHT_DEV_TYPE_LINK,
>> +       CORESIGHT_DEV_TYPE_LINKSINK,
>> +       CORESIGHT_DEV_TYPE_SOURCE,
>> +};
>> +
>> +enum coresight_dev_subtype_sink {
>> +       CORESIGHT_DEV_SUBTYPE_SINK_NONE,
>> +       CORESIGHT_DEV_SUBTYPE_SINK_PORT,
>> +       CORESIGHT_DEV_SUBTYPE_SINK_BUFFER,
>> +};
>> +
>> +enum coresight_dev_subtype_link {
>> +       CORESIGHT_DEV_SUBTYPE_LINK_NONE,
>> +       CORESIGHT_DEV_SUBTYPE_LINK_MERG,
>> +       CORESIGHT_DEV_SUBTYPE_LINK_SPLIT,
>> +       CORESIGHT_DEV_SUBTYPE_LINK_FIFO,
>> +};
>> +
>> +enum coresight_dev_subtype_source {
>> +       CORESIGHT_DEV_SUBTYPE_SOURCE_NONE,
>> +       CORESIGHT_DEV_SUBTYPE_SOURCE_PROC,
>> +       CORESIGHT_DEV_SUBTYPE_SOURCE_BUS,
>> +       CORESIGHT_DEV_SUBTYPE_SOURCE_SOFTWARE,
>> +};
>> +
>> +struct coresight_ops_entry {
>> +       const char *name;
>> +       umode_t mode;
>> +       const struct file_operations *ops;
>> +};
>> +
>> +struct coresight_dev_subtype {
>> +       enum coresight_dev_subtype_sink sink_subtype;
>> +       enum coresight_dev_subtype_link link_subtype;
>> +       enum coresight_dev_subtype_source source_subtype;
>> +};
>> +
>> +struct coresight_platform_data {
>> +       int id;
>> +       int cpu;
>> +       const char *name;
>> +       int nr_inports;
>> +       const int *outports;
>> +       const int *child_ids;
>> +       const int *child_ports;
>> +       int nr_outports;
>> +       bool default_sink;
>> +       struct clk *clk;
>> +};
>> +
>> +struct coresight_desc {
>> +       enum coresight_dev_type type;
>> +       struct coresight_dev_subtype subtype;
>> +       const struct coresight_ops *ops;
>> +       struct coresight_platform_data *pdata;
>> +       struct device *dev;
>> +       const struct coresight_ops_entry **debugfs_ops;
>> +       struct module *owner;
>> +};
>> +
>> +struct coresight_connection {
>> +       int outport;
>> +       int child_id;
>> +       int child_port;
>> +       struct coresight_device *child_dev;
>> +       struct list_head link;
>> +};
>> +
>> +struct coresight_refcnt {
>> +       int sink_refcnt;
>> +       int *link_refcnts;
>> +       int source_refcnt;
>> +};
>> +
>> +struct coresight_device {
>> +       int id;
>> +       struct coresight_connection *conns;
>> +       int nr_conns;
>> +       enum coresight_dev_type type;
>> +       struct coresight_dev_subtype subtype;
>> +       const struct coresight_ops *ops;
>> +       struct dentry *de;
>> +       struct device dev;
>> +       struct coresight_refcnt refcnt;
>> +       struct list_head dev_link;
>> +       struct list_head path_link;
>> +       struct module *owner;
>> +       bool enable;
>> +};
>> +
>> +#define to_coresight_device(d) container_of(d, struct coresight_device, dev)
>> +
>> +#define CORESIGHT_DEBUGFS_ENTRY(__name, __entry_name,                  \
>> +                                __mode, __get, __set, __fmt)           \
>> +DEFINE_SIMPLE_ATTRIBUTE(__name ## _ops, __get, __set, __fmt)           \
>> +static const struct coresight_ops_entry __name ## _entry = {           \
>> +       .name = __entry_name,                                           \
>> +       .mode = __mode,                                                 \
>> +       .ops  = &__name ## _ops                                         \
>> +}
>> +
>> +struct coresight_ops_sink {
>> +       int (*enable)(struct coresight_device *csdev);
>> +       void (*disable)(struct coresight_device *csdev);
>> +       void (*abort)(struct coresight_device *csdev);
>> +};
>> +
>> +struct coresight_ops_link {
>> +       int (*enable)(struct coresight_device *csdev, int iport, int oport);
>> +       void (*disable)(struct coresight_device *csdev, int iport, int oport);
>> +};
>> +
>> +struct coresight_ops_source {
>> +       int (*enable)(struct coresight_device *csdev);
>> +       void (*disable)(struct coresight_device *csdev);
>> +};
>> +
>> +struct coresight_ops {
>> +       const struct coresight_ops_sink *sink_ops;
>> +       const struct coresight_ops_link *link_ops;
>> +       const struct coresight_ops_source *sourcearch/arm64/kernel/smp.c_ops;
>> +};
>> +
>> +#ifdef CONFIG_CORESIGHT
>> +extern struct coresight_device *
>> +coresight_register(struct coresight_desc *desc);
>> +extern void coresight_unregister(struct coresight_device *csdev);
>> +extern int coresight_enable(struct coresight_device *csdev);
>> +extern void coresight_disable(struct coresight_device *csdev);
>> +extern void coresight_abort(void);
>> +extern struct clk *coresight_get_clk(void);
>> +#else
>> +static inline struct coresight_device *
>> +coresight_register(struct coresight_desc *desc) { return NULL; }
>> +static inline void coresight_unregister(struct coresight_device *csdev) {}
>> +static inline int
>> +coresight_enable(struct coresight_device *csdev) { return -ENOSYS; }
>> +static inline void coresight_disable(struct coresight_device *csdev) {}
>> +static inline void coresight_abort(void) {}
>> +extern struct clk *coresight_get_clk(void) {};
>> +#endif
>> +
>> +#endif
>> diff --git a/include/linux/of_coresight.h b/include/linux/of_coresight.h
>> new file mode 100644
>> index 0000000..6a5e4d4
>> --- /dev/null
>> +++ b/include/linux/of_coresight.h
>
> I would just put this into coresight.h.
>
>
>> @@ -0,0 +1,27 @@
>> +/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef __LINUX_OF_CORESIGHT_H
>> +#define __LINUX_OF_CORESIGHT_H
>> +
>> +#ifdef CONFIG_OF
>> +extern struct coresight_platform_data *of_get_coresight_platform_data(
>> +                               struct device *dev, struct device_node *node);
>> +#else
>> +static inline struct coresight_platform_data *of_get_coresight_platform_data(
>> +                               struct device *dev, struct device_node *node)
>> +{
>> +       return NULL;
>> +}
>> +#endif
>> +
>> +#endif
>> --
>> 1.9.1
>>
