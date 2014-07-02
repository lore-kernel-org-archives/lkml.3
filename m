Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbaGBRGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:06:48 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:37120 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaGBRGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:06:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKagkczEK8WZx3-gxzz3mquZ0rQLsaZrVO-bPP4+BtVMw@mail.gmail.com>
References: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org>
	<1403892261-25026-2-git-send-email-mathieu.poirier@linaro.org>
	<CAL_JsqKagkczEK8WZx3-gxzz3mquZ0rQLsaZrVO-bPP4+BtVMw@mail.gmail.com>
Date: Wed, 2 Jul 2014 11:06:45 -0600
Message-ID: <CANLsYkxKW5DbnAbtfLmF0=1WSXbKv2Waj9kHBHVrk13CJoKA+g@mail.gmail.com>
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
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>, r.sengupta@samsung.com,
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

On 27 June 2014 16:01, Rob Herring <robherring2@gmail.com> wrote:
> On Fri, Jun 27, 2014 at 1:04 PM,  <mathieu.poirier@linaro.org> wrote:
>> From: Pratik Patel <pratikp@codeaurora.org>
>>
>> CoreSight components are compliant with the ARM CoreSight
>> architecture specification and can be connected in various
>> topologies to suite a particular SoCs tracing needs. These trace
>> components can generally be classified as sources, links and
>> sinks. Trace data produced by one or more sources flows through
>> the intermediate links connecting the source to the currently
>> selected sink.
>>
>> CoreSight framework provides an interface for the CoreSight trace
>> drivers to register themselves with. It's intended to build up a
>> topological view of the CoreSight components and configure the
>> right series of components on user input via debugfs.
>>
>> For eg., when enabling a source, framework builds up a path
>> consisting of all the components connecting the source to the
>> currently selected sink and enables all of them.
>>
>> Framework also supports switching between available sinks and
>> also provides status information to user space applications
>> through the debugfs interface.
>>
>> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
>> Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>> ---
>>  .../devicetree/bindings/arm/coresight.txt          | 141 +++++
>
> We prefer bindings as separate patch and you have not cc'd all maintainers.

Very well.  DT maintainers you mean?

>
>
>> diff --git a/Documentation/devicetree/bindings/arm/coresight.txt b/Documentation/devicetree/bindings/arm/coresight.txt
>> new file mode 100644
>> index 0000000..9d4eb53
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/coresight.txt
>> @@ -0,0 +1,141 @@
>> +* CoreSight Components
>> +
>> +CoreSight components are compliant with the ARM CoreSight architecture
>> +specification and can be connected in various topologies to suit a particular
>> +SoCs tracing needs. These trace components can generally be classified as sinks,
>> +links and sources. Trace data produced by one or more sources flows through the
>> +intermediate links connecting the source to the currently selected sink. Each
>> +CoreSight component device should use these properties to describe its hardware
>> +characteristcs.
>> +
>> +Required properties:
>> +
>> +- compatible : name of the component used for driver matching.  Possible values
>> +       include: "arm,coresight-etb", "arm,coresight-tpiu", "arm,coresight-tmc",
>> +       "arm,coresight-funnel", and "arm,coresight-etm".  All of these have to
>> +       be supplemented with "arm,primecell" as drivers are using the AMBA bus
>> +       interface.
>
> Is there no versioning needed with any of these?

That is a possibility yes.  Versions can happen:

1) Within the same family:
"arm,coresight-etm" and "arm,coresight-etmv4"

2) Throughout vendors:
"arm,coresight-tpiu" and "acme,coresigh-tpiu"

I was going to use different names as above for the differentiation.
Do you have another suggestion?

>
>> +- reg : physical base address and length of the register set(s) of the component
>> +- clocks : the clock associated to this component
>> +- clock-names: the name of the clock as referenced by the code.  Since we are
>> +       using the AMBA framework, the name should be "apb_pclk".
>> +- ports or port: The representation of the component's port layout using the
>> +       generic DT graph presentation found in "bindings/graph.txt"
>> +
>> +Optional properties for Sinks:
>> +- coresight-default-sink: must be specified for one of the sink devices that is
>> +intended to be made the default sink. Other sink devices must not have this
>> +specified. Not specifying this property on any of the sinks is invalid.
>> +
>> +Optional properties for ETM/PTMs:
>> +- arm,cp14 : access to ETM/PTM management registers is made via cp14.
>> +- cpu: the cpu this ETM/PTM is affined to.
>
> Why optional?

Because accessing management registers is an implementation defined
choice.  If the "cpu" is omitted the component is assumed to be
affined to cpu 0.

>
> Clarify that this is a phandle.

Very well.

>
>> +
>> +Optional property for TMC:
>> +- arm,buffer-size : size of contiguous buffer space for TMC ETR (embedded trace router)
>
> ETBs don't need a size?

The ETB RAM buffer size it read from the configuration register.

>
> Not really much more to say given you are using the graph binding!

I think it makes for a much cleaner representation - thanks for the suggestion.

>
>> +
>> +
>> +Example:
>> +
>> +1. Sinks
>> +       etb: etb@20010000 {
>> +               compatible = "arm,coresight-etb", "arm,primecell";
>> +               reg = <0 0x20010000 0 0x1000>;
>> +
>> +               coresight-default-sink;
>> +               clocks = <&oscclk6a>;
>> +               clock-names = "apb_pclk";
>> +               port {
>> +                       etb_in_port: endpoint@0 {
>> +                               slave-mode;
>> +                               remote-endpoint = <&funnel_out_port0>;
>> +                       };
>> +               };
>> +       };
>> +
>> +       tpiu: tpiu@20030000 {
>> +               compatible = "arm,coresight-tpiu", "arm,primecell";
>> +               reg = <0 0x20030000 0 0x1000>;
>> +
>> +               clocks = <&oscclk6a>;
>> +               clock-names = "apb_pclk";
>> +               port {
>> +                       tpiu_in_port: endpoint@0 {
>> +                               slave-mode;
>> +                               remote-endpoint = <&funnel_out_port1>;
>> +                       };
>> +               };
>> +       };
>> +
>> +2. Links
>> +       funnel {
>> +               compatible = "arm,coresight-funnel", "arm,primecell";
>> +               reg = <0 0x20040000 0 0x1000>;
>> +
>> +               clocks = <&oscclk6a>;
>> +               clock-names = "apb_pclk";
>> +               ports {
>> +                       #address-cells = <1>;
>> +                       #size-cells = <0>;
>
> You are getting this from the graph binding, but this node is a bit
> pointless. #address-cells and #size-cells can be in the funnel node.
> The extra layer is not necessary for that. The documentation says it
> is optional, but perhaps the code or other uses require it.
>
> Philipp, any comments on this?
>
> [...]
>
>> +/*
>> + * Coresight management registers (0xF00-0xFCC)
>> + * 0xFA0 - 0xFA4: Management   registers in PFTv1.0
>> + *               Trace         registers in PFTv1.1
>> + */
>> +#define CORESIGHT_ITCTRL       (0xF00)
>> +#define CORESIGHT_CLAIMSET     (0xFA0)
>> +#define CORESIGHT_CLAIMCLR     (0xFA4)
>> +#define CORESIGHT_LAR          (0xFB0)
>> +#define CORESIGHT_LSR          (0xFB4)
>> +#define CORESIGHT_AUTHSTATUS   (0xFB8)
>> +#define CORESIGHT_DEVID                (0xFC8)
>> +#define CORESIGHT_DEVTYPE      (0xFCC)
>> +
>> +#define TIMEOUT_US             (100)
>
> Parentheses are not needed for constants and lower case hex is preferred.

checkpatch.pl didn't complain but if you prefer.

>
>> +
>> +#define BM(lsb, msb)           ((BIT(msb) - BIT(lsb)) + BIT(msb))
>> +#define BMVAL(val, lsb, msb)   ((val & BM(lsb, msb)) >> lsb)
>> +#define BVAL(val, n)           ((val & BIT(n)) >> n)
>> +
>> +#define cs_writel(addr, val, off)      __raw_writel((val), addr + off)
>> +#define cs_readl(addr, off)            __raw_readl(addr + off)
>
> Remove these. They don't do anything, but make someone reading the
> code look up what exactly cs_writel/cs_readl do.
>
> [...]
>
>> +/* Returns the base address found in @node. Seriously
>> + * tailored on @of_device_make_bus_id().
>> + */
>> +static u32 of_get_coresight_id(struct device_node *node)
>> +{
>> +       u32 addr = 0;
>> +       const __be32 *reg, *addrp;
>> +
>> +       reg = of_get_property(node, "reg", NULL);
>> +       if (reg) {
>> +               if (of_can_translate_address(node)) {
>
> rebase to 3.16-rc, this is gone.

Ok, I'll look at it.

>
>> +                       addr = of_translate_address(node, reg);
>> +               } else {
>> +                       addrp = of_get_address(node, 0, NULL, NULL);
>> +                       if (addrp)
>> +                               addr = of_read_ulong(addrp, 1);
>> +                       else
>> +                               addr = 0;
>> +               }
>> +       }
>> +
>> +       return addr;
>> +}
>> +
>> +static struct device_node *of_get_coresight_endpoint(
>> +               const struct device_node *parent, struct device_node *prev)
>> +{
>> +       struct device_node *node = of_graph_get_next_endpoint(parent, prev);
>> +       of_node_put(prev);
>> +       return node;
>> +}
>> +
>> +static bool of_coresight_is_input_port(struct device_node *port)
>> +{
>> +       if (of_find_property(port, "slave-mode", NULL))
>
> return of_property_read_bool()

Yeah, probably a better coding style.

>
>> +               return true;
>> +       else
>> +               return false;
>> +}
>> +
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

I'll find out.

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

Is it purely a style thing or you see problems stemming up from this approach?

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

Very probable yes - I'll take another look.

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
>> +       const struct coresight_ops_source *source_ops;
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

ack

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
