Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaCJRCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:02:15 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:64430 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbaCJRCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:02:13 -0400
MIME-Version: 1.0
In-Reply-To: <1393629520-12713-3-git-send-email-santosh.shilimkar@ti.com>
References: <1393629520-12713-1-git-send-email-santosh.shilimkar@ti.com>
	<1393629520-12713-3-git-send-email-santosh.shilimkar@ti.com>
Date: Mon, 10 Mar 2014 12:02:12 -0500
Message-ID: <CAL_Jsq+O660oV9FtthG3gTkVOhL0ku-UHSrkt-ROauu1iNpbaA@mail.gmail.com>
Subject: Re: [PATCH 2/3] soc: keystone: add QMSS driver
From: Rob Herring <robherring2@gmail.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sandeep Nair <sandeep_n@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 5:18 PM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> From: Sandeep Nair <sandeep_n@ti.com>
>
> The QMSS (Queue Manager Sub System) found on Keystone SOCs is one of
> the main hardware sub system which forms the backbone of the Keystone
> Multi-core Navigator. QMSS consist of queue managers, packed-data structure
> processors(PDSP), linking RAM, descriptor pools and infrastructure
> Packet DMA.
>
> The Queue Manager is a hardware module that is responsible for accelerating
> management of the packet queues. Packets are queued/de-queued by writing or
> reading descriptor address to a particular memory mapped location. The PDSPs
> perform QMSS related functions like accumulation, QoS, or event management.
> Linking RAM registers are used to link the descriptors which are stored in
> descriptor RAM. Descriptor RAM is configurable as internal or external memory.
>
> The QMSS driver manages the PDSP setups, linking RAM regions,
> queue pool management (allocation, push, pop and notify) and descriptor
> pool management. The specifics on the device tree bindings for
> QMSS can be found in:
>         Documentation/devicetree/bindings/soc/keystone-qmss.txt

You are telling me where I can find a file that is added in this commit?

All this description of what the h/w block does should go into the binding doc.

>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Sandeep Nair <sandeep_n@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  .../devicetree/bindings/soc/keystone-qmss.txt      |  209 +++
>  drivers/Kconfig                                    |    2 +
>  drivers/Makefile                                   |    3 +
>  drivers/soc/Kconfig                                |    2 +
>  drivers/soc/Makefile                               |    5 +
>  drivers/soc/keystone/Kconfig                       |   15 +
>  drivers/soc/keystone/Makefile                      |    5 +
>  drivers/soc/keystone/qmss_acc.c                    |  591 ++++++++
>  drivers/soc/keystone/qmss_queue.c                  | 1533 ++++++++++++++++++++
>  drivers/soc/keystone/qmss_queue.h                  |  236 +++
>  include/linux/soc/keystone_qmss.h                  |  390 +++++
>  11 files changed, 2991 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/soc/keystone-qmss.txt
>  create mode 100644 drivers/soc/Makefile
>  create mode 100644 drivers/soc/keystone/Kconfig
>  create mode 100644 drivers/soc/keystone/Makefile
>  create mode 100644 drivers/soc/keystone/qmss_acc.c
>  create mode 100644 drivers/soc/keystone/qmss_queue.c
>  create mode 100644 drivers/soc/keystone/qmss_queue.h
>  create mode 100644 include/linux/soc/keystone_qmss.h
>
> diff --git a/Documentation/devicetree/bindings/soc/keystone-qmss.txt b/Documentation/devicetree/bindings/soc/keystone-qmss.txt
> new file mode 100644
> index 0000000..f975207
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/soc/keystone-qmss.txt
> @@ -0,0 +1,209 @@
> +* Texas Instruments Keystone QMSS driver
> +
> +Required properties:
> +- compatible   : Must be "ti,keystone-qmss";
> +- clocks       : phandle to the reference clock for this device.
> +- queue-range  : <start number> total range of queue numbers for the device.
> +- linkram0     : <address size> for internal link ram, where size is the total
> +                 link ram entries.
> +- linkram1     : <address size> for external link ram, where size is the total
> +                 external link ram entries. If the address is specified as "0"
> +                 driver will allocate memory.
> +- qmgrs         : the number of individual queue managers in the device. On
> +                  keystone 1 range of devices there should be only one node.
> +                 On keystone 2 devices there can be more than 1 node.
> +  -- managed-queues    : the actual queues managed by each queue manager
> +                         instance, specified as <"base queue #" "# of queues">.
> +  -- reg               : Address and length of the register set for the device
> +                         for peek, status, config, region, push, pop regions.
> +  -- reg-names         : Names for the above register regions. The name to be
> +                         used is as follows:
> +                         - "config" : Queue configuration region.
> +                         - "status" : Queue status RAM.
> +                         - "region" : Descriptor memory setup region.
> +                         - "push"   : Queue Management/Queue Proxy region.
> +                         - "pop"    : Queue Management/Queue Proxy region.
> +                         - "peek"   : Queue Peek region.

reg-names should be optional. Also you have the order different from
reg. Be consistent as to what is the correct order.

> +- queue-pools  : Queue ranges are grouped into 3 type of pools:
> +                 - qpend           : pool of qpend(interruptible) queues
> +                 - general-purpose : pool of general queues, primarly used
> +                                     as free descriptor queues or the
> +                                     transmit DMA queues.
> +                 - accumulator     : pool of queues on accumulator channel
> +                 Each range can have the following properties:
> +  -- values            : number of queues to use per queue range, specified as
> +                         <"base queue #" "# of queues">.

values of what? This needs a better name.

> +  -- interrupts                : Optional property to specify the interrupt mapping
> +                         for interruptible queues. The driver additionaly sets
> +                         the interrupt affinity based on the cpu mask.
> +  -- reserved          : Optional property used to reserve the range. Queues
> +                         in a reserved range can only be allocated by id.

reserved what? This needs a better name and description.

> +  -- accumulator       : Accumulator channel property specified as:
> +                         <pdsp-id, channel, entries, pacing mode, latency>
> +                         pdsp-id     : QMSS PDSP running accumulator firmware
> +                                       on which the channel has to be
> +                                       configured
> +                         channel     : Accumulator channel number
> +                         entries     : Size of the accumulator descriptor list
> +                         pacing mode : Interrupt pacing mode
> +                                       0 : None, i.e interrupt on list full
> +                                       1 : Time delay since last interrupt
> +                                       2 : Time delay since first new packet
> +                                       3 : Time delay since last new packet
> +                         latency     : time to delay the interrupt, specified
> +                                       in microseconds.
> +  -- multi-queue       : Optional property to specify that the channel has to
> +                         monitor upto 32 queues starting at the base queue #.

What does the property contain? What's a channel in this context?

> +- descriptor-regions   : Descriptor memory region specification.

huh?

> +  -- id                                : region number.
> +  -- values                    : number of descriptors in the region,
> +                                 specified as
> +                                 <"# of descriptors" "descriptor size">.
> +  -- link-index                        : start index, i.e. index of the first
> +                                 descriptor in the region.
> +
> +Optional properties:
> +- dma-coherent : Present if DMA operations are coherent.
> +- pdsps                : PDSP configuration, if any.

This is a child node? Make that clear and separate the description for
each node.

> +  -- firmware          : firmware to be loaded on the PDSP.
> +  -- id                        : the qmss pdsp that will run the firmware.
> +  -- reg               : Address and length of the register set of the PDSP
> +                         for iram, intd, region, command regions.
> +  -- reg-names         : Names for the above register regions. The name to be
> +                         used is as follows:
> +                         - "iram"   : PDSP internal RAM region.
> +                         - "reg"    : PDSP control/status region registers.
> +                         - "intd"   : QMSS interrupt distributor registers.
> +                         - "cmd"    : PDSP command interface region.
> +
> +Example:

I probably have other comments, but address the above first.

Rob
