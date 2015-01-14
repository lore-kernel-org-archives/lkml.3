Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbbANOV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:21:57 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24884 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbbANOVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:21:52 -0500
Message-ID: <54B67B5E.9030002@oracle.com>
Date: Wed, 14 Jan 2015 09:21:18 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, Imre Palik <imrep.amz@gmail.com>,
        xen-devel@lists.xenproject.org
CC: "Palik, Imre" <imrep@amazon.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Anthony Liguori <aliguori@amazon.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] xen-time: decreasing the rating of the xen
 clocksource below that of the tsc clocksource for dom0's
References: <1421136862-15083-1-git-send-email-imrep.amz@gmail.com> <54B4EAC7.2080105@citrix.com> <54B53CDD.7070400@oracle.com> <54B542C0.4070701@citrix.com> <54B54513.8060604@oracle.com> <54B548DA.60402@oracle.com>
In-Reply-To: <54B548DA.60402@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 11:33 AM, Boris Ostrovsky wrote:
> On 01/13/2015 11:17 AM, Boris Ostrovsky wrote:
>> On 01/13/2015 11:07 AM, David Vrabel wrote:
>>> On 13/01/15 15:42, Boris Ostrovsky wrote:
>>>> On 01/13/2015 04:52 AM, David Vrabel wrote:
>>>>> On 13/01/15 08:14, Imre Palik wrote:
>>>>>> From: "Palik, Imre" <imrep@amazon.de>
>>>>>>
>>>>>> In Dom0's the use of the TSC clocksource (whenever it is stable
>>>>>> enough to
>>>>>> be used) instead of the Xen clocksource should not cause any 
>>>>>> issues, as
>>>>>> Dom0 VMs never live-migrated.  The TSC clocksource is somewhat more
>>>>>> efficient than the Xen paravirtualised clocksource, thus it 
>>>>>> should have
>>>>>> higher rating.
>>>>>>
>>>>>> This patch decreases the rating of the Xen clocksource in Dom0s 
>>>>>> to 275.
>>>>>> Which is half-way between the rating of the TSC clocksource (300) 
>>>>>> and
>>>>>> the
>>>>>> hpet clocksource (250).
>>>>> I'm happy with this but would like to see acks from those who 
>>>>> objected
>>>>> to v1.
>>>>>
>>>>> David
>>>>>
>>>>>> --- a/arch/x86/xen/time.c
>>>>>> +++ b/arch/x86/xen/time.c
>>>>>> @@ -487,6 +487,10 @@ static void __init xen_time_init(void)
>>>>>>        int cpu = smp_processor_id();
>>>>>>        struct timespec tp;
>>>>>>    +    /* As Dom0 is never moved, no penalty on using TSC there */
>>>> Again, why not any PV guest with TSC_MODE_NEVER_EMULATE?
>>> Surely if TSC_MODE_NEVER_EMULATE is set then the TSC is /not/ stable
>>> across a guest save/restore thus the PV clocksource must be used?
>>
>> TSC is declared stable when !d->disable_migrate && !d->arch.vtsc, 
>> with vtsc being 0 with TSC_MODE_NEVER_EMULATE (per domain_cpuid()).
>
> I think I inverted domain_cpuid's logic here but my point was that we 
> use'd use combination of TSC_MODE_NEVER_EMULATE and CPUID flag 
> indicating TSC stability to pick the clocksource.
>
>
> -boris
>
>>
>> And if TSC is not stable as seen by CPUID (which would be the case if 
>> disable_migrate is not set) then kernel won't use TSC as clocksource 
>> anyway, regardless of rating value, won't it?


So this is not going to work because early_init_intel() may set 
X86_FEATURE_CONSTANT_TSC unconditionally, without consulting CPUID.

Imre, you can ignore my question about non-dom0 guests then.

-boris


