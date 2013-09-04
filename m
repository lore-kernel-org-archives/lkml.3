Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858Ab3IDUEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:04:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54599 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab3IDUEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:04:47 -0400
Message-ID: <52279253.6080603@ti.com>
Date: Wed, 4 Sep 2013 15:04:35 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2] hwspinlock/omap: add support for dt nodes
References: <1378230767-54931-1-git-send-email-s-anna@ti.com> <43798031-2D57-44F0-A19C-FD80DB9E9794@codeaurora.org> <52263413.1050108@ti.com> <8E84282E-BAD1-4A2B-849A-167C32F629DA@codeaurora.org> <52266409.90908@ti.com> <71570936-39F5-4AE1-AD05-163EA3179271@codeaurora.org> <52275F7D.4030305@ti.com> <9BE41927-7C6C-4E62-860B-0288627E9421@codeaurora.org> <522767E5.9080302@ti.com> <F363B498-5648-4C19-BC16-096EE12C29CE@codeaurora.org>
In-Reply-To: <F363B498-5648-4C19-BC16-096EE12C29CE@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 12:51 PM, Kumar Gala wrote:
> 
> On Sep 4, 2013, at 12:03 PM, Suman Anna wrote:
> 
>>>>>>>>>
>>>>>>>>>> HwSpinlock IP is present only on OMAP4 and other newer SoCs,
>>>>>>>>>> which are all device-tree boot only. This patch adds the
>>>>>>>>>> base support for parsing the DT nodes, and removes the code
>>>>>>>>>> dealing with the traditional platform device instantiation.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>>>>>>>>> ---
>>>>>>>>>> .../devicetree/bindings/hwlock/omap-hwspinlock.txt | 28 ++++++++++
>>>>>>>>>> arch/arm/mach-omap2/Makefile                       |  3 --
>>>>>>>>>> arch/arm/mach-omap2/hwspinlock.c                   | 60 ----------------------
>>>>>>>>>> drivers/hwspinlock/omap_hwspinlock.c               | 21 ++++++--
>>>>>>>>>> 4 files changed, 45 insertions(+), 67 deletions(-)
>>>>>>>>>> create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
>>>>>>>>>> delete mode 100644 arch/arm/mach-omap2/hwspinlock.c
>>>>>>>>>>
>>>>>>>>>> diff --git a/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
>>>>>>>>>> new file mode 100644
>>>>>>>>>> index 0000000..adfb8ad
>>>>>>>>>> --- /dev/null
>>>>>>>>>> +++ b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
>>>>>>>>>> @@ -0,0 +1,28 @@
>>>>>>>>>> +OMAP4+ HwSpinlock Driver
>>>>>>>>>> +
>>>>>>>>>> +Required properties:
>>>>>>>>>> +- compatible:		Currently supports only "ti,omap4-hwspinlock" for
>>>>>>>>>> +				OMAP44xx, OMAP54xx, AM33xx, AM43xx, DRA7xx SoCs
>>>>>>>>>> +- reg:			Contains the hwspinlock register address range (base
>>>>>>>>>> +			address and length)
>>>>>>>>>> +- ti,hwmods:		Name of the hwmod associated with the hwspinlock device
>>>>>>>>>> +
>>>>>>>>>> +Optional properties:
>>>>>>>>>> +- base_id:		Base Id for the locks for a particular hwspinlock
>>>>>>>>>> +			device. If not mentioned, a default value of 0 is used.
>>>>>>>>>> +			This property is mandatory ONLY if a SoC has several
>>>>>>>>>> +			hwspinlock devices. There are currently no such OMAP
>>>>>>>>>> +			SoCs.
>>>>>>>>>
>>>>>>>>> Should this be ti,base_id ? [ I know its kinda generic in its intent for any SoC w/multiple blocks ]
>>>>>>>>
>>>>>>>> I didn't add the "ti," prefix exactly for the same reason - it is
>>>>>>>> generic w.r.t the hwspinlock core irrespective of the SoC family, and
>>>>>>>> there is nothing ti or OMAP specific about it. I have added it to keep
>>>>>>>> the DT node definition in sync with the driver code. If it is too
>>>>>>>> generic a name, it can always be renamed as hwlock_base_id. This will be
>>>>>>>> SoC agnostic property for the hwspinlock driver. What do you think?
>>>>>>>
>>>>>>> I'm wondering if we should use cell-index for this purpose.
>>>>>>
>>>>>> I didn't get you completely. Do you intend to compute the base_id using
>>>>>> cell-index and number of locks (which may be a separate field altogether
>>>>>> if this information cannot be read from the h/w)? My understanding is
>>>>>> that cell-index is primarily used for identifying the h/w instance number.
>>>>>
>>>>> I was suggesting using cell-index instead of base_id.  What we should probably due is have a devicetree/bindings/hwlock/hwlock.txt that would describe generic properties like this and just reference that in the omap binding spec.
>>>>
>>>> Common hwlock.txt sounds good. Will make the change.
>>>>
>>>>>
>>>>> I'm thinking if we dont use cell-index, that it should probably be hwlock-base-id
>>>>>
>>>>
>>>> I prefer to use hwlock-base-id. I think we should also be defining a
>>>> common property name for number of locks, say hwlock-num-locks.
>>>
>>> I'm good with that, cell-index is always funny so might as well be explicit.
>>>
>>> I'm also good with hwlock-num-locks, I'll update the msm spinlock driver to use this.
>>>
>>> Can you also maybe add some helper functions into the hwspinlock core to return these values so we both don't duplicate code in drivers and maintain consistency.
>>
>> I am trying to understand what you would need these for. Your driver
>> would already know the base_id and num_locks, since these are used in
>> the registration function.
> 
> 
> It would be something simple like:
> 
> static inline int of_get_hwlock_base_id (struct device_node *dn) {
> #ifdef CONFIG_OF
> 	u32 val;
> 
> 	if (of_property_read_u32(dn, "hwlock-base-id", &val)
> 		return val;
> #endif
> 	return 0;
> }
> 

Sorry I misinterpreted, thought you were asking for accessor functions
after, and not of_ helpers. Yes, will add these as well.

regards
Suman

