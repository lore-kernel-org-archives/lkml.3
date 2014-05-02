Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaEBWqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 18:46:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56925 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbaEBWqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 18:46:37 -0400
Message-ID: <53642028.2040308@ti.com>
Date: Fri, 2 May 2014 17:46:00 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCHv5 01/15] Documentation: dt: add common bindings for hwspinlock
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>	<1398904476-26200-2-git-send-email-s-anna@ti.com> <CAL_JsqJEVU7j0+biWuW2FiV-avu1_SO4w+OCdirAc6mw2OxrOA@mail.gmail.com>
In-Reply-To: <CAL_JsqJEVU7j0+biWuW2FiV-avu1_SO4w+OCdirAc6mw2OxrOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On 05/02/2014 09:58 AM, Rob Herring wrote:
> On Wed, Apr 30, 2014 at 7:34 PM, Suman Anna <s-anna@ti.com> wrote:
>> This patch adds the generic common bindings used to represent
>> a hwlock device and use/request locks in a device-tree build.
>>
>> All the platform-specific hwlock driver implementations need the
>> number of locks and associated base id for registering the locks
>> present within the device with the driver core. The number of locks
>> is represented by 'hwlock-num-locks' property in DT bindings. A
>> property for base id is not needed in DT binding, as it can be
>> satisfied using a phandle + args specifier. The args specifier
>> length is dependent on each vendor-specific implementation and
>> is represented through the '#hwlock-cells' property.
>>
>> Note that the document is named hwlock.txt deliberately to keep it
>> a bit more generic.
>>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
>> ---
>>  .../devicetree/bindings/hwlock/hwlock.txt          | 52 ++++++++++++++++++++++
>>  1 file changed, 52 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/hwlock/hwlock.txt
>>
>> diff --git a/Documentation/devicetree/bindings/hwlock/hwlock.txt b/Documentation/devicetree/bindings/hwlock/hwlock.txt
>> new file mode 100644
>> index 0000000..32381cc
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/hwlock/hwlock.txt
>> @@ -0,0 +1,52 @@
>> +Generic hwlock bindings
>> +=======================
>> +
>> +Generic bindings that are common to all the hwlock platform specific driver
>> +implementations, the retrieved values are used for registering the device
>> +specific parameters with the hwspinlock core.
>> +
>> +The validity and need of these common properties may vary from one platform
>> +implementation to another. The platform specific bindings should explicitly
>> +state if a property is mandatory or optional. Please look through the
>> +individual platform specific hwlock binding documentations for identifying
>> +the applicable properties.
>> +
>> +Common properties:
>> +- #hwlock-cells:       Specifies the number of cells needed to represent a
>> +                       specific lock.
> 
> This should never be optional.

Thanks for reviewing this. I can add a statement here to make this clear.

> 
>> +- hwlock-num-locks:    Number of locks present in a hwlock device. This
>> +                       property is needed on hwlock devices, where the number
>> +                       of supported locks within a hwlock device cannot be
>> +                       read from a register.
> 
> Do you have any users of this? The omap binding doesn't use it.
> Wouldn't you typically know this based on the IP block? Similarly you
> typically don't have to list how many irqs an interrupt controller
> has.

The MSM Spinlock driver [1] would be using this, it is waiting on this
series to get finalized. It currently defines a custom property, and the
number of locks is a generic property that the hwspinlock core uses and
is common to different platform implementations, so created the generic
property. OMAP doesn't use this because the number is read directly off
a IP register.

 can you also take a look at patches 8 and 12 as they add additional
properties based on discussion in [2]. The hwspinlocks are used for
arbitration between different initiators on an SoC, and typically would
need a SoC-level identifier for each lock. All these properties allow a
hwlock to be statically identified and be assigned to a user and its
peer user on a different initiator, and not allowing them to be run-time
assigned.

regards
Suman

[1] https://lkml.org/lkml/2013/8/14/528
[2] http://marc.info/?l=linux-omap&m=139510004009415&w=2

> 
> 
>> +
>> +Hwlock Users:
>> +=============
>> +
>> +Nodes that require specific hwlock(s) should specify them using one or more
>> +properties, each containing a phandle to the hwlock node and an args specifier
>> +value as indicated by #hwlock-cells. Multiple hwlocks can be requested using
>> +an array of the phandle and hwlock number specifier tuple.
>> +
>> +1. Example of a node using a single specific hwlock:
>> +
>> +The following example has a node requesting a hwlock in the bank defined by
>> +the node hwlock1. hwlock1 is a hwlock provider with an argument specifier
>> +of length 1.
>> +
>> +       node {
>> +               ...
>> +               hwlocks = <&hwlock1 2>;
>> +               ...
>> +       };
>> +
>> +2. Example of a node using multiple specific hwlocks:
>> +
>> +The following example has a node requesting two hwlocks, a hwlock within
>> +the hwlock device node 'hwlock1' with #hwlock-cells value of 1, and another
>> +hwlock within the hwlock device node 'hwlock2' with #hwlock-cells value of 2.
>> +
>> +       node {
>> +               ...
>> +               hwlocks = <&hwlock1 2>, <&hwlock2 0 3>;
>> +               ...
>> +       };
>> --
>> 1.9.2
>>

