Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaEVHWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:22:54 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62167 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaEVHWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:22:52 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <537DA5C0.2070609@roeck-us.net>
Date: Thu, 22 May 2014 00:22:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartmann <gregkh@linuxfoundation.org>
CC: Francesco Ruggeri <fruggeri@arista.com>, Hannes Reinecke <hare@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: pci: kernel crash in bus_find_device
References: <CA+HUmGjvHgWB3vcPnXAEVFdFuy9sOaB1BjaDW1-7ai933XEGWQ@mail.gmail.com> <20140520195041.GA28913@roeck-us.net> <CA+HUmGg4mE5RDxShNCK78yLi9gdX_FnHtWPKfGD4LaEqrCdj2Q@mail.gmail.com> <20140520233812.GA15640@roeck-us.net> <CA+HUmGge7AEpAnwAG_VJD2CKTtRBoC2bCGVU_t4qm-x6+OCr-g@mail.gmail.com> <20140521193010.GA1721@roeck-us.net> <CA+HUmGhm1VLTvMKW1TUUPqStUhD11M5u0VyTZyXyWz_ZS8uSVw@mail.gmail.com> <20140521225958.GB2467@roeck-us.net> <20140522071427.GA21230@kroah.com>
In-Reply-To: <20140522071427.GA21230@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 12:14 AM, Greg Kroah-Hartmann wrote:
> On Wed, May 21, 2014 at 03:59:58PM -0700, Guenter Roeck wrote:
>> On Wed, May 21, 2014 at 01:04:04PM -0700, Francesco Ruggeri wrote:
>>> I have been using an x86 platform.
>>> When I started working on it I got early crashes until I added the
>>> check for p not NULL in
>>>
>>> +void bus_release_device(struct device *dev)
>>> +{
>>> + struct device_private *p = dev->p;
>>> +
>>> + if (p && klist_node_attached(&p->knode_bus))
>>> + klist_put_last(&p->knode_bus);
>>> +}
>>> +
>>>
>>> Maybe on powerpc *p is overriden between device_del and device_release?
>>>
>>> Or maybe some of the BUG_ONs in the patch? The ones on knode_dead are
>>> treated as WARN_ONs in the current klist code.
>>> The one in BUG_ON(!klist_dec_and_del(n)); is new, and in my tests I
>>> ran into it without the second patch (but only when I ran my module
>>> and tests).
>>>
>> Hi Francesco,
>>
>> I replaced the BUG_ON with WARN_ON; still crashes.
>>
>> Anyway, the problem seems to be known. I found two related exchanges.
>>
>> [1] describes pretty much the same problem. I don't see if/where it was
>> ever fixed, though.
>>
>> [2] is a patch to fix the problem. It did not apply cleanly to 3.14,
>> so I had to make some adjustments in klist_iter_init_node. Resulting
>> patch is below. With this patch, the problem is gone. It is not perfect,
>> as it aborts the loop if it encounters a deleted kobject, but it is better
>> than nothing. Unfortunately, the patch never made it upstream; no idea why.
>> Copying the author and Greg to get additional feedback.
>>
>> Guenter
>>
>> [1] https://lkml.org/lkml/2008/10/26/79
>> [2] https://lkml.org/lkml/2012/4/16/218
>
> 2 years ago?  I have no idea what was up with that, sorry...
>

Ok, but do you have comments on the patch itself in its current version ?

Guenter

