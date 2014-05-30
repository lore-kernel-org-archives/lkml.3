Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934273AbaE3RZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:25:44 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:43564 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239AbaE3RZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:25:43 -0400
MIME-Version: 1.0
In-Reply-To: <1401457391-12242-2-git-send-email-mathieu.poirier@linaro.org>
References: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
	<1401457391-12242-2-git-send-email-mathieu.poirier@linaro.org>
Date: Fri, 30 May 2014 12:25:42 -0500
Message-ID: <CAL_Jsq+U+H7cPDALQHzLV0aT7EQjKcR74eoFWFP_HuLePi73Ag@mail.gmail.com>
Subject: Re: [RFC PATCH 01/11] coresight: add CoreSight core layer framework
From: Rob Herring <robherring2@gmail.com>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Daniel Thompson <daniel.thompson@linaro.org>, robbelibobban@gmail.com,
        Al.Grant@arm.com, Linaro Patches <patches@linaro.org>,
        marcin.jabrzyk@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        arnd@linaro.org, panchaxari.prasannamurthy@linaro.org,
        r.sengupta@samsung.com, arve@android.com,
        John Stultz <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        james.king@linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        pratikp@codeaurora.org, varshney@ti.com,
        jonas.svennebring@avagotech.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 8:43 AM,  <mathieu.poirier@linaro.org> wrote:
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
> currently selected sink and enables all of them.
>
> Framework also supports switching between available sinks and
> also provides status information to user space applications
> through sysfs interface.
>
> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
> Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>  .../devicetree/bindings/arm/coresight.txt          | 138 ++++
>  drivers/Kconfig                                    |   2 +
>  drivers/Makefile                                   |   1 +
>  drivers/coresight/Kconfig                          |   9 +
>  drivers/coresight/Makefile                         |   5 +
>  drivers/coresight/coresight-priv.h                 |  46 ++
>  drivers/coresight/coresight.c                      | 739 +++++++++++++++++++++
>  drivers/coresight/of_coresight.c                   | 124 ++++
>  include/linux/coresight.h                          | 181 +++++
>  include/linux/of_coresight.h                       |  27 +
>  10 files changed, 1272 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/coresight.txt
>  create mode 100644 drivers/coresight/Kconfig
>  create mode 100644 drivers/coresight/Makefile
>  create mode 100644 drivers/coresight/coresight-priv.h
>  create mode 100644 drivers/coresight/coresight.c
>  create mode 100644 drivers/coresight/of_coresight.c
>  create mode 100644 include/linux/coresight.h
>  create mode 100644 include/linux/of_coresight.h
>
> diff --git a/Documentation/devicetree/bindings/arm/coresight.txt b/Documentation/devicetree/bindings/arm/coresight.txt
> new file mode 100644
> index 0000000..3e21665
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/coresight.txt
> @@ -0,0 +1,138 @@
> +* CoreSight Components
> +
> +CoreSight components are compliant with the ARM CoreSight architecture
> +specification and can be connected in various topologies to suite a particular
> +SoCs tracing needs. These trace components can generally be classified as sinks,
> +links and sources. Trace data produced by one or more sources flows through the
> +intermediate links connecting the source to the currently selected sink. Each
> +CoreSight component device should use these properties to describe its hardware
> +characteristcs.
> +
> +Required properties:
> +
> +- compatible : name of the component used for driver matching

Where are the specific strings for components?

> +- reg : physical base address and length of the register set(s) of the component
> +- coresight-id : unique integer identifier for the component

compatible + reg is a unique id.

> +- coresight-name : unique descriptive name of the component

compatible is a descriptive name.

> +- coresight-nr-inports : number of input ports on the component
> +
> +coresight-outports, coresight-child-list and coresight-child-ports lists will
> +be of the same length and will have a one to one correspondence among the
> +elements at the same list index.
> +
> +coresight-default-sink must be specified for one of the sink devices that is
> +intended to be made the default sink. Other sink devices must not have this
> +specified. Not specifying this property on any of the sinks is invalid.

Why do you need the default-sink in DT? Isn't the configuration going
to depend on the user?

> +
> +Optional properties:
> +
> +- coresight-outports : list of output port numbers of this component
> +- coresight-child-list : list of phandles pointing to the children of this
> +                        component
> +- coresight-child-ports : list of input port numbers of the children
> +- coresight-default-sink : represents the default compile time CoreSight sink

Seems like the OF graph helpers being defined for V4L2 could be useful
here to describe the connections. We should not invent something new
to describe arbitrary connections.

> +- arm,buffer-size : size of contiguous buffer space for TMC ETR

TMC ETR?

> +- arm,cp14 : cp14 access to ETM registers is implemented and should be used
> +- clocks : the clock associated to the coresight entity.
> +- cpu: only valid for ETM/PTMs - the cpu this ETM/PTM is affined to.

I think you need some separation of bindings by component rather than
saying which components certain properties apply to.

> +
> +Example:
> +
> +1. Bus declaration:
> +       coresight {
> +               compatible = "arm,coresight";
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               ranges;
> +               ...
> +               ...
> +               ...
> +        };
> +
> +        coresight {
> +               compatible = "arm,coresight";
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               ranges = <0x20010000 0 0x20010000 0x1000
> +                         0x20030000 0 0x20030000 0x1000
> +                         0x20040000 0 0x20040000 0x1000
> +                         0x2201c000 0 0x2201c000 0x1000
> +                         0x2201d000 0 0x2201d000 0x1000
> +                         0x2203c000 0 0x2203c000 0x1000
> +                         0x2203d000 0 0x2203d000 0x1000
> +                         0x2203e000 0 0x2203e000 0x1000>;

This is not how ranges generally work. For no translation, use just
"ranges;". Otherwise you should have base address and reg properties
are just offsets from the base. Anyway, it's not really pertinent to
your example.

> +               ...
> +               ...
> +               ...
> +       };
> +
> +2. Sinks
> +       etb: etb@20010000 {
> +               compatible = "arm,coresight-etb";
> +               reg = <0x20010000 0x1000>;
> +
> +               coresight-id = <0>;
> +               coresight-name = "coresight-etb";
> +               coresight-nr-inports = <1>;
> +               coresight-default-sink;
> +       };
> +
> +       tpiu: tpiu@20030000 {
> +               compatible = "arm,coresight-tpiu";
> +               reg = <0x20030000 0x1000>;
> +
> +               coresight-id = <1>;
> +               coresight-name = "coresight-tpiu";
> +               coresight-nr-inports = <1>;
> +       };
> +
> +3. Links
> +       replicator: replicator {
> +               compatible = "arm,coresight-replicator";
> +
> +               coresight-id = <2>;
> +               coresight-name = "coresight-replicator";
> +               coresight-nr-inports = <1>;
> +               coresight-outports = <0 1>;
> +               coresight-child-list = <&etb &tpiu>;
> +               coresight-child-ports = <0 0>;

This could be one property instead of 2: <&etb 0>, <&tpiu 0>;

Then add a #coresight-cells.

> +       };
> +
> +       funnel: funnel@20040000 {
> +               compatible = "arm,coresight-funnel";
> +               reg = <0x20040000 0x1000>;
> +
> +               coresight-id = <3>;
> +               coresight-name = "coresight-funnel";
> +               coresight-nr-inports = <8>;
> +               coresight-outports = <0>;
> +               coresight-child-list = <&replicator>;
> +               coresight-child-ports = <0>;
> +       };
> +
> +4. Sources
> +       ptm0: ptm@2201c000 {
> +               compatible = "arm,coresight-etm";
> +               reg = <0x2201c000 0x1000>;
> +
> +               coresight-id = <9>;
> +               coresight-name = "coresight-ptm0";
> +               cpu = <&cpu0>;
> +               coresight-nr-inports = <0>;

A source can be implied by no inports property. Likewise for a sink.
