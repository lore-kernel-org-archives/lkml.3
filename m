Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967404AbaFQWS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:18:28 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59853 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966711AbaFQWSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:18:24 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A0BEA7.1020602@roeck-us.net>
Date: Tue, 17 Jun 2014 15:18:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rob Herring <robh@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: Problems with commit 9ec36cafe4 (of/irq: do irq resolution in
 platform_get_irq) and mfd client devices
References: <20140617181034.GA25854@roeck-us.net> <CAL_Jsq+TFKJN_-PowcAyYztXzcomeAiT70xg7FxKgEQoG=7tAw@mail.gmail.com> <20140617202932.GA31414@roeck-us.net> <CAL_JsqK9bcb9LKRM_S8R0YqcNzuBnW1fhwEsAYYxfOEdmmhKtQ@mail.gmail.com>
In-Reply-To: <CAL_JsqK9bcb9LKRM_S8R0YqcNzuBnW1fhwEsAYYxfOEdmmhKtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 02:39 PM, Rob Herring wrote:
> On Tue, Jun 17, 2014 at 3:29 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On Tue, Jun 17, 2014 at 03:08:24PM -0500, Rob Herring wrote:
>>> On Tue, Jun 17, 2014 at 1:10 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>> Hi,
>>>>
>>>> I have an mfd master and client drivers on a system which has devicetree
>>>> enabled. The mfd master driver passes interrupts to the clients using
>>>> mfd cells and 'struct resource'. The client driver is a platform driver
>>>> which retrieves the irq using platform_get_irq().
>>>>
>>>> After commit 9ec36cafe (of/irq: do irq resolution in platform_get_irq),
>>>> this code no longer works. This is because platform_get_irq() does no
>>>> longer call platform_get_resource() if OF is enabled and if dev->of_node
>>>> is not NULL (it is not NULL because there is other [static] information
>>>> which is passed to the client with devicetree data).
>>>>
>>>> Any idea how to solve this problem ? How do I now pass a virtual interrupt
>>>> from an mfd master to its clients if devicetree is enabled ?
>>>
>>> The node ptr points to the MFD node or a child node? If there are
>>> child nodes in DT, then why not define interrupts there too? If there
>>> are not child nodes, then perhaps the child drivers should not have DT
>>> knowledge.
>>>
>> There is a whole bunch of secondary data in the child's dt node.
>> One of the child/client drivers is an i2c controller with attached
>> i2c muxes and several i2c devices, another is a gpio controller
>> with a large number of gpio pins which itself acts as interrupt
>> controller.
>
> Then why not put interrupt data into the child nodes?
>

Seems to me how interrupts are passed on between mfd master and child driver
(and the fact that there _is_ a mfd master and slave driver) is implementation
dependent. I thought that implementation dependencies are not supposed
to be expressed in devicetree data. Maybe that changed.

Even then it seems to me that if we can no longer rely on resource data
to pass information between mfd master and slaves under some circumstances,
this needs to be documented. Bold and underlined. Also, the new method
of passing such information needs to be described somewhere. Expecting
mfd driver implementers to figure this out on their own seems a bit
heavy handed - even more so since the patches are being backported
to older kernels (which is how I found out). Sure, the code I am dealing
with is (at least for now) not in the upstream kernel, but introducing
a subtle API change like this one as part of a stable release is really
not appropriate. Or at least I think so.

>>> Does it fail to get an interrupt or gets the parent interrupt instead?
>>>
>> It fails to get an interrupt and returns -EINVAL.
>>
>>> We could probably make an error fall-back to looking at resources. Or
>>> try to get irq from resources first, then call of_irq_get.
>>>
>> I submitted a patch implementing the first approach a few minutes ago.
>> That fixes the problem for me. Not sure if that is the right solution
>> though, as it doesn't handle -EPROBE_DEFER. Let me know when you see
>> the patch if there is a better way to handle it (maybe abort with
>> -EPROBE_DEFER if of_irq_get returns it would do).
>
> Humm, don't see it. In any case, you would need to fall back only if
> the error is not EPROBE_DEFER.
>
Weird, I don't see the patch on lkml either. I'll resend with the correction.

Guenter

