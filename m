Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbbAOURK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 15:17:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48406 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbbAOURI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 15:17:08 -0500
Message-ID: <54B8201F.3080802@ti.com>
Date: Thu, 15 Jan 2015 14:16:31 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
CC: Kumar Gala <galak@codeaurora.org>, Bjorn Andersson <bjorn@kryo.se>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v7 1/4] Documentation: dt: add common bindings for hwspinlock
References: <1421269101-51105-1-git-send-email-s-anna@ti.com> <1421269101-51105-2-git-send-email-s-anna@ti.com> <20150115135201.GG16217@leverpostej> <20150115135556.GH16217@leverpostej> <CAL_JsqL2LZAooMk-V8+xeF2g6acZE21M+-OBRw8aEVa-5wVHuQ@mail.gmail.com>
In-Reply-To: <CAL_JsqL2LZAooMk-V8+xeF2g6acZE21M+-OBRw8aEVa-5wVHuQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 08:42 AM, Rob Herring wrote:
> On Thu, Jan 15, 2015 at 7:55 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>> On Thu, Jan 15, 2015 at 01:52:01PM +0000, Mark Rutland wrote:
>>> On Wed, Jan 14, 2015 at 08:58:18PM +0000, Suman Anna wrote:
>>>> This patch adds the generic common bindings used to represent
>>>> a hwlock device and use/request locks in a device-tree build.
>>>>
>>>> All the platform-specific hwlock driver implementations need the
>>>> number of locks and associated base id for registering the locks
>>>> present within the device with the driver core. This base id
>>>> needs to be unique across multiple IP instances of a hwspinlock
>>>> device, so that each hwlock can be represented uniquely in a
>>>> system.
>>>>
>>>> The number of locks is represented by 'hwlock-num-locks' property,
>>>> and the base id is represented by the 'hwlock-base-id' property.
>>>> The args specifier length is dependent on each vendor-specific
>>>> implementation and is represented through the '#hwlock-cells'
>>>> property. Client users need to use the property 'hwlocks' for
>>>> requesting specific lock(s).
>>>>
>>>> Note that the document is named hwlock.txt deliberately to keep
>>>> it a bit more generic.
>>>>
>>>> Cc: Rob Herring <robh+dt@kernel.org>
>>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>>> ---
>>>> v7: Revised binding info for hwlock-base-id, it is mandatory now
>>>>
>>>>  .../devicetree/bindings/hwlock/hwlock.txt          | 55 ++++++++++++++++++++++
>>>>  1 file changed, 55 insertions(+)
>>>>  create mode 100644 Documentation/devicetree/bindings/hwlock/hwlock.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/hwlock/hwlock.txt b/Documentation/devicetree/bindings/hwlock/hwlock.txt
>>>> new file mode 100644
>>>> index 000000000000..8de7aaf878f9
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/hwlock/hwlock.txt
>>>> @@ -0,0 +1,55 @@
>>>> +Generic hwlock bindings
>>>> +=======================
>>>> +
>>>> +Generic bindings that are common to all the hwlock platform specific driver
>>>> +implementations.
>>>> +
>>>> +The validity and need of these common properties may vary from one platform
>>>> +implementation to another. The platform specific bindings should explicitly
>>>> +state if an optional property is used. Please also look through the individual
>>>> +platform specific hwlock binding documentations for identifying the applicable
>>>> +properties.
>>>> +
>>>> +Common properties:
>>>> +- #hwlock-cells:   Specifies the number of cells needed to represent a
>>>> +                   specific lock. This property is mandatory for all
>>>> +                   platform implementations.
>>>> +- hwlock-num-locks:        Number of locks present in a hwlock device. This
>>>> +                   property is needed on hwlock devices, where the number
>>>> +                   of supported locks within a hwlock device cannot be
>>>> +                   read from a register.
>>>> +- hwlock-base-id:  An unique base Id for the locks for a particular hwlock
>>>> +                   device. This property is mandatory for all platform
>>>> +                   implementations.
>>>
>>> This property makes no sense. The ID encoded in the hwlock cells is
>>> relative to the instance (identified by phandle), not global. So the DT
>>> has no global ID space.
>>>
>>> Why do you think you need this?
>>
>> Having looked at the way this proeprty is used, NAK.
>>
>> If you need to carve up a Linux-internal ID space, do that dynamically.
>> There is no need for this property.
> 
> Better yet, don't create a Linux ID space for this. Everywhere we have
> one, we want to get rid of it.

Hi Mark, Rob,

Thank you for your comments. The id space is not limited to Linux, as
this is indeed a global id space for all the processors in an SoC, as
that is the primary usage of the individual locks in these IP blocks. It
needs to be static across the SoC irrespective of whether a node was
enabled or not. Now, it is debatable whether we do this in DT or do this
in each individual implementation. This is something that the hwspinlock
core cannot do, and probably would have to be done as static
driver match data.

I have gone from having this as an optional property, to not having it,
and now back to having it as mandatory - because of the different
perspectives from bindings vs driver subsystem maintainers. I brought
this back mainly based on the reasonings in [1]

Ohad,
Do you have any comments or suggestions here? It looks like I have no
choice but to bring back "hwspinlock/core: maintain a list of registered
hwspinlock banks", if we were to have the bindings without a
hwlock-base-id property.

regards
Suman

[1] http://marc.info/?l=linux-omap&m=139510004009415&w=2

