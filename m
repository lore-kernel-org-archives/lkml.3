Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab3JAOx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:53:56 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57002 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab3JAOxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:53:49 -0400
Message-ID: <524AE1FA.2050104@gmail.com>
Date: Tue, 01 Oct 2013 09:53:46 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: tglx@linutronix.de, Sricharan R <r.sricharan@ti.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        linux@arm.linux.org.uk, tony@atomide.com, rnayak@ti.com,
        marc.zyngier@arm.com, grant.likely@linaro.org, mark.rutland@arm.com
Subject: Re: [RFC PATCH 0/6] DRIVERS: IRQCHIP: Add support for crossbar IP
References: <1380549564-31045-1-git-send-email-r.sricharan@ti.com> <52499441.1030403@gmail.com> <524AAE69.8060703@ti.com> <524AD290.207@gmail.com> <524AD4B7.7040700@ti.com>
In-Reply-To: <524AD4B7.7040700@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 08:57 AM, Santosh Shilimkar wrote:
> On Tuesday 01 October 2013 09:48 AM, Rob Herring wrote:
>> On 10/01/2013 06:13 AM, Sricharan R wrote:
>>> Hi,
>>>
>>> On Monday 30 September 2013 08:39 PM, Rob Herring wrote:
>>>> On 09/30/2013 08:59 AM, Sricharan R wrote:
>>>>> Some socs have a large number of interrupts requests to service
>>>>> the needs of its many peripherals and subsystems. All of the interrupt
>>>>> requests lines from the subsystems are not needed at the same
>>>>> time, so they have to be muxed to the controllers appropriately.
>>>>> In such places a interrupt controllers are preceded by an
>>>>> IRQ CROSSBAR that provides flexibility in muxing the device interrupt
>>>>> requests to the controller inputs.
>>>>>
>>>>> This series models the peripheral interrupts that can be routed through
>>>>> the crossbar to the GIC as 'routable-irqs'. The routable irqs are added
>>>>> in a separate linear domain inside the GIC. The registered routable domain's
>>>>> callback are invoked as a part of the GIC's callback, which in turn should
>>>>> allocate a free irq line and configure the IP accordingly. So every peripheral
>>>>> in the dts files mentions the fixed crossbar number as its interrupt. A free
>>>>> gic line for that gets allocated and configured when the peripheral's interrupt
>>>>> is mapped.
>>>>>
>>>>> The minimal crossbar driver to track and allocate free GIC lines and configure the
>>>>> crossbar is added here, along with the DT bindings.
>>>> Seems like interrupt-map property is what you need here.
>>>>
>>>> http://devicetree.org/Device_Tree_Usage#Advanced_Interrupt_Mapping
>>>>
>>>> Versatile Express also has an example.
>>>    OK, but the idea was not to tie up the crossbar<->interrupt numbers at the
>>>    DTS level, but to assign it dynamically during runtime. This was one of the
>>>   comments that came up with first crossbar support patches, which was assigning a
>>>   interrupt line to crossbar number in the DTS and setting it up in crossbar probe.
>>
>> Is there an actual usecase on a single h/w design that you run out of
>> interrupts and it is a user decision which interrupts to use?
>>
> Yes. There are 240 peripheral interrupts connected out of which 160 can
> be used in this specific case. 

Yes, I understand the SOC connections. That does not answer my question.
The 240 interrupts are likely to be limited to fewer by board design,
pinmuxing, etc.

How do you handle the 161st interrupt request? Will never happen? Just
rely on the random driver probe ordering?

>> You could fill in the interrupt-map at run-time. It would have to be
>> early (bootloader or early kernel init) and can't be at request_irq time.
>>
> Well all options are tried before coming up to the $subject solution.
> It was suggested by Thomas in the last review.
>  
>>>     https://lkml.org/lkml/2013/7/18/416
>>>
>>>    Since this approach of assigning in DTS was opposed, we moved to IRQCHIP and
>>>    that did not go as well. Finally was asked to handle this as a part of GIC driver with
>>>    a separate domain.
>>>    
>>>   http://www.spinics.net/lists/linux-omap/msg97085.html
>>
>> This has nothing to do with the GIC, so it does not belong there.
>>
> Well the router makes connections from peripheral to GIC. Thomas can
> better explain it but I think since its doing irq routing for GIC on
> a given hardware, I don't see any issue having some generic map/unmap
> function in GIC. The actual implementation is still outside of GIC.

I read Thomas' reply as don't put this crap in his code.

You can call it generic, but it is not. It is specific to the GIC and
looks like an abuse of irqdomains to me. Look where the function
declaration for register_routable_domain_ops is.

Rob

