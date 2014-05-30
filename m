Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776AbaE3SCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 14:02:43 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:45043 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556AbaE3SCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 14:02:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+U+H7cPDALQHzLV0aT7EQjKcR74eoFWFP_HuLePi73Ag@mail.gmail.com>
References: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
	<1401457391-12242-2-git-send-email-mathieu.poirier@linaro.org>
	<CAL_Jsq+U+H7cPDALQHzLV0aT7EQjKcR74eoFWFP_HuLePi73Ag@mail.gmail.com>
Date: Fri, 30 May 2014 12:02:40 -0600
Message-ID: <CANLsYkxnJKB=uFwQDW4Ec3nMfOtnh3f1QQGKf=adH1jUxfsrng@mail.gmail.com>
Subject: Re: [RFC PATCH 01/11] coresight: add CoreSight core layer framework
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Robert Marklund <robbelibobban@gmail.com>, Al Grant <Al.Grant@arm.com>,
        Linaro Patches <patches@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        r.sengupta@samsung.com,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        James King <james.king@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 May 2014 11:25, Rob Herring <robherring2@gmail.com> wrote:
> On Fri, May 30, 2014 at 8:43 AM,  <mathieu.poirier@linaro.org> wrote:
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
>> through sysfs interface.
>>
>> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
>> Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>> ---
>>  .../devicetree/bindings/arm/coresight.txt          | 138 ++++
>>  drivers/Kconfig                                    |   2 +
>>  drivers/Makefile                                   |   1 +
>>  drivers/coresight/Kconfig                          |   9 +
>>  drivers/coresight/Makefile                         |   5 +
>>  drivers/coresight/coresight-priv.h                 |  46 ++
>>  drivers/coresight/coresight.c                      | 739 +++++++++++++++++++++
>>  drivers/coresight/of_coresight.c                   | 124 ++++
>>  include/linux/coresight.h                          | 181 +++++
>>  include/linux/of_coresight.h                       |  27 +
>>  10 files changed, 1272 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/arm/coresight.txt
>>  create mode 100644 drivers/coresight/Kconfig
>>  create mode 100644 drivers/coresight/Makefile
>>  create mode 100644 drivers/coresight/coresight-priv.h
>>  create mode 100644 drivers/coresight/coresight.c
>>  create mode 100644 drivers/coresight/of_coresight.c
>>  create mode 100644 include/linux/coresight.h
>>  create mode 100644 include/linux/of_coresight.h
>>
>> diff --git a/Documentation/devicetree/bindings/arm/coresight.txt b/Documentation/devicetree/bindings/arm/coresight.txt
>> new file mode 100644
>> index 0000000..3e21665
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/coresight.txt
>> @@ -0,0 +1,138 @@
>> +* CoreSight Components
>> +
>> +CoreSight components are compliant with the ARM CoreSight architecture
>> +specification and can be connected in various topologies to suite a particular
>> +SoCs tracing needs. These trace components can generally be classified as sinks,
>> +links and sources. Trace data produced by one or more sources flows through the
>> +intermediate links connecting the source to the currently selected sink. Each
>> +CoreSight component device should use these properties to describe its hardware
>> +characteristcs.
>> +
>> +Required properties:
>> +
>> +- compatible : name of the component used for driver matching
>
> Where are the specific strings for components?

"Coresight" is made of multiple components with each component needing
a different driver.
>
>> +- reg : physical base address and length of the register set(s) of the component
>> +- coresight-id : unique integer identifier for the component
>
> compatible + reg is a unique id.

Some coresight IP blocks like the replicator don't have a reg property
- the "coresight-id" and "coresight-name" are the only way to identify
them properly.

>
>> +- coresight-name : unique descriptive name of the component
>
> compatible is a descriptive name.

That is what ends up under /sys/kernel/debug/coresight/.  Since there
can be multiple entity of the same type it is easier and more
convivial for users.  For instance: "coresight-etb-replicator" and
"coresight-tpiu-replicator" are easier to identify than
"coresight-replicator0" and "coresight-replicator1".

We need to keep "coresight-id" or "coresight-name" - I prefer the
former.  What is your take on this?

>
>> +- coresight-nr-inports : number of input ports on the component
>> +
>> +coresight-outports, coresight-child-list and coresight-child-ports lists will
>> +be of the same length and will have a one to one correspondence among the
>> +elements at the same list index.
>> +
>> +coresight-default-sink must be specified for one of the sink devices that is
>> +intended to be made the default sink. Other sink devices must not have this
>> +specified. Not specifying this property on any of the sinks is invalid.
>
> Why do you need the default-sink in DT? Isn't the configuration going
> to depend on the user?

Users can change this at will via debugfs.  It's a default boot time
configuration and can be removed if you're absolutely keen on it.
Please advise.

>
>> +
>> +Optional properties:
>> +
>> +- coresight-outports : list of output port numbers of this component
>> +- coresight-child-list : list of phandles pointing to the children of this
>> +                        component
>> +- coresight-child-ports : list of input port numbers of the children
>> +- coresight-default-sink : represents the default compile time CoreSight sink
>
> Seems like the OF graph helpers being defined for V4L2 could be useful
> here to describe the connections. We should not invent something new
> to describe arbitrary connections.

Very well, I'll take a look.

>
>> +- arm,buffer-size : size of contiguous buffer space for TMC ETR
>
> TMC ETR?

Trace Memory Controller in Embedded Trace Router configuration.

>
>> +- arm,cp14 : cp14 access to ETM registers is implemented and should be used
>> +- clocks : the clock associated to the coresight entity.
>> +- cpu: only valid for ETM/PTMs - the cpu this ETM/PTM is affined to.
>
> I think you need some separation of bindings by component rather than
> saying which components certain properties apply to.

Ok.

>
>> +
>> +Example:
>> +
>> +1. Bus declaration:
>> +       coresight {
>> +               compatible = "arm,coresight";
>> +               #address-cells = <1>;
>> +               #size-cells = <1>;
>> +               ranges;
>> +               ...
>> +               ...
>> +               ...
>> +        };
>> +
>> +        coresight {
>> +               compatible = "arm,coresight";
>> +               #address-cells = <1>;
>> +               #size-cells = <1>;
>> +               ranges = <0x20010000 0 0x20010000 0x1000
>> +                         0x20030000 0 0x20030000 0x1000
>> +                         0x20040000 0 0x20040000 0x1000
>> +                         0x2201c000 0 0x2201c000 0x1000
>> +                         0x2201d000 0 0x2201d000 0x1000
>> +                         0x2203c000 0 0x2203c000 0x1000
>> +                         0x2203d000 0 0x2203d000 0x1000
>> +                         0x2203e000 0 0x2203e000 0x1000>;
>
> This is not how ranges generally work. For no translation, use just
> "ranges;". Otherwise you should have base address and reg properties
> are just offsets from the base. Anyway, it's not really pertinent to
> your example.

In the case of that specific board doing a one-to-one mapping in
"ranges" was mandatory.  Otherwise the mapping wasn't done at all.

>
>> +               ...
>> +               ...
>> +               ...
>> +       };
>> +
>> +2. Sinks
>> +       etb: etb@20010000 {
>> +               compatible = "arm,coresight-etb";
>> +               reg = <0x20010000 0x1000>;
>> +
>> +               coresight-id = <0>;
>> +               coresight-name = "coresight-etb";
>> +               coresight-nr-inports = <1>;
>> +               coresight-default-sink;
>> +       };
>> +
>> +       tpiu: tpiu@20030000 {
>> +               compatible = "arm,coresight-tpiu";
>> +               reg = <0x20030000 0x1000>;
>> +
>> +               coresight-id = <1>;
>> +               coresight-name = "coresight-tpiu";
>> +               coresight-nr-inports = <1>;
>> +       };
>> +
>> +3. Links
>> +       replicator: replicator {
>> +               compatible = "arm,coresight-replicator";
>> +
>> +               coresight-id = <2>;
>> +               coresight-name = "coresight-replicator";
>> +               coresight-nr-inports = <1>;
>> +               coresight-outports = <0 1>;
>> +               coresight-child-list = <&etb &tpiu>;
>> +               coresight-child-ports = <0 0>;
>
> This could be one property instead of 2: <&etb 0>, <&tpiu 0>;
>

But then we'd have to do the parsing of said property in the code -
isn't that less desirable?

> Then add a #coresight-cells
>
>> +       };
>> +
>> +       funnel: funnel@20040000 {
>> +               compatible = "arm,coresight-funnel";
>> +               reg = <0x20040000 0x1000>;
>> +
>> +               coresight-id = <3>;
>> +               coresight-name = "coresight-funnel";
>> +               coresight-nr-inports = <8>;
>> +               coresight-outports = <0>;
>> +               coresight-child-list = <&replicator>;
>> +               coresight-child-ports = <0>;
>> +       };
>> +
>> +4. Sources
>> +       ptm0: ptm@2201c000 {
>> +               compatible = "arm,coresight-etm";
>> +               reg = <0x2201c000 0x1000>;
>> +
>> +               coresight-id = <9>;
>> +               coresight-name = "coresight-ptm0";
>> +               cpu = <&cpu0>;
>> +               coresight-nr-inports = <0>;
>
> A source can be implied by no inports property. Likewise for a sink.

Sources have  a compatible property to identify them.  A sink has a
single input port.  Did I get your comment right?
