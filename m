Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3LZRpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 12:45:54 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53283 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab3LZRpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 12:45:52 -0500
Message-ID: <52BC6B16.80507@ti.com>
Date: Thu, 26 Dec 2013 12:44:54 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sricharan R <r.sricharan@ti.com>, <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <rnayak@ti.com>, <marc.zyngier@arm.com>,
        <grant.likely@linaro.org>, <mark.rutland@arm.com>,
        <robherring2@gmail.com>, <tglx@linutronix.de>, <galak@codeaurora.org>,
        <rob.herring@calxeda.com>, <nm@ti.com>, <bcousson@baylibre.com>
Subject: Re: [PATCH V5 0/4] DRIVERS: IRQCHIP: Add support for crossbar IP
References: <1386066445-28245-1-git-send-email-r.sricharan@ti.com> <52B168A5.4010202@ti.com> <52BBB614.5010707@ti.com>
In-Reply-To: <52BBB614.5010707@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sricharan,

On Wednesday 25 December 2013 11:52 PM, Sricharan R wrote:
> Hi Thomas,
> On Wednesday 18 December 2013 02:49 PM, Sricharan R wrote:
>> Hi Thomas,
>>
>> On Tuesday 03 December 2013 03:57 PM, Sricharan R wrote:
>>> Some socs have a large number of interrupts requests to service
>>> the needs of its many peripherals and subsystems. All of the interrupt
>>> requests lines from the subsystems are not needed at the same
>>> time, so they have to be muxed to the controllers appropriately.
>>> In such places a interrupt controllers are preceded by an
>>> IRQ CROSSBAR that provides flexibility in muxing the device interrupt
>>> requests to the controller inputs.
>>>
>>> This series models the peripheral interrupts that can be routed through
>>> the crossbar to the GIC as 'routable-irqs'. The routable irqs are added
>>> in a separate linear domain inside the GIC. The registered routable domain's
>>> callback are invoked as a part of the GIC's callback, which in turn should
>>> allocate a free irq line and configure the IP accordingly. So every peripheral
>>> in the dts files mentions the fixed crossbar number as its interrupt. A free
>>> gic line for that gets allocated and configured when the peripheral interrupts
>>> are mapped.
>>>
>>> The minimal crossbar driver to track and allocate free GIC lines and configure the
>>> crossbar is added here, along with the DT bindings.
>>>
>>> V5:
>>>    Addressed a comment from Mark Rutland <mark.rutland@arm.com>,
>>>    updated tags and rebased on 3.13-rc2
>>>
>>> V4:
>>>    Addressed a couple of comments and split the DTS file updates in to
>>>    a separate series.
>>>
>>> V3:
>>>    Addressed few more comments from Thomas Gleixner <tglx@linutronix.de>
>>>
>>>    Rebased patches 3,4,5,7 which updates the DTS file on top of below branch
>>> 	   git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git
>>> 	   for_3.13/dts
>>>
>>>    Rebased patches 1,2,6 on top of 3.12 mainline
>>>    Updated Commit tags
>>>
>>> V2:
>>>    Addressed Thomas Gleixner <tglx@linutronix.de> comments and
>>>    Kumar Gala <galak@codeaurora.org>
>>>
>>>    Split updating the DRA7.dtsi file for adding the routable-irqs
>>>
>>> Previous discussions that led to this is at
>>> 	https://lkml.org/lkml/2013/9/18/540
>>>
>>> The V1,V2,V3,V4 post of these patches is at
>>>       [V1]  https://lkml.org/lkml/2013/9/30/283
>>>       [V2]  http://www.spinics.net/lists/linux-omap/msg99540.html
>>>       [V3]  http://www.kernelhub.org/?msg=356470&p=2
>>>       [V4]  http://www.spinics.net/lists/linux-doc/msg16726.html
>>>
>>> Sricharan R (4):
>>>   DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable irqs
>>>   DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar IP
>>>   ARM: OMAP4+: Correct Wakeup-gen code to use physical irq number
>>>   ARM: DRA: Enable Crossbar IP support for DRA7XX
>>>
>>>  Documentation/devicetree/bindings/arm/gic.txt      |    6 +
>>>  .../devicetree/bindings/arm/omap/crossbar.txt      |   27 +++
>>>  arch/arm/mach-omap2/Kconfig                        |    1 +
>>>  arch/arm/mach-omap2/omap-wakeupgen.c               |    4 +-
>>>  arch/arm/mach-omap2/omap4-common.c                 |    2 +
>>>  drivers/irqchip/Kconfig                            |    8 +
>>>  drivers/irqchip/Makefile                           |    1 +
>>>  drivers/irqchip/irq-crossbar.c                     |  208 ++++++++++++++++++++
>>>  drivers/irqchip/irq-gic.c                          |   81 +++++++-
>>>  include/linux/irqchip/arm-gic.h                    |    7 +-
>>>  include/linux/irqchip/irq-crossbar.h               |   11 ++
>>>  11 files changed, 343 insertions(+), 13 deletions(-)
>>>  create mode 100644 Documentation/devicetree/bindings/arm/omap/crossbar.txt
>>>  create mode 100644 drivers/irqchip/irq-crossbar.c
>>>  create mode 100644 include/linux/irqchip/irq-crossbar.h
>>>
>>
>> I have addressed all the comments on this series, can this be merged now ?
>>
>   Ping..
> 
Thomas has already given his reviewed-by tag so the patches can be
taken via arm-soc tree considering OMAP and GIC changes. Can you
create a branch with all these patches applied and send it
to Tony ?

Tony, Will you able to pull this and send it up to arm-soc ?

Regards,
Santosh



