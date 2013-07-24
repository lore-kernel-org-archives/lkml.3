Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab3GXN5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:57:22 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:64652 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3GXN5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:57:20 -0400
MIME-Version: 1.0
In-Reply-To: <51EF919F.2000706@linux.vnet.ibm.com>
References: <1374601332.9192.0.camel@localhost.localdomain>
	<51EF4969.4050807@linux.vnet.ibm.com>
	<CADZ9YHiJ4MYFkWqikKu0qHOsBYGEPYvC2JL5wE3iCUH6vTMKcA@mail.gmail.com>
	<51EF919F.2000706@linux.vnet.ibm.com>
Date: Wed, 24 Jul 2013 19:57:19 +0600
Message-ID: <CADZ9YHiQO7ynz+4KK73N+wpEvgcQDaHJ9cOn5fHaw0uGnVBtnQ@mail.gmail.com>
Subject: Re: [PATCH v2] sched: update_top_cache_domain only at the times of
 building sched domain.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 2:34 PM, Michael Wang
<wangyun@linux.vnet.ibm.com> wrote:
> On 07/24/2013 04:01 PM, Rakib Mullick wrote:
>> On Wed, Jul 24, 2013 at 9:26 AM, Michael Wang
>> <wangyun@linux.vnet.ibm.com> wrote:
>>> Hi, Rakib
>>>
>>> On 07/24/2013 01:42 AM, Rakib Mullick wrote:
>>>> Currently, update_top_cache_domain() is called whenever schedule domain is built or destroyed. But, the following
>>>> callpath shows that they're at the same callpath and can be avoided update_top_cache_domain() while destroying schedule
>>>> domain and update only at the times of building schedule domains.
>>>>
>>>>       partition_sched_domains()
>>>>               detach_destroy_domain()
>>>>                       cpu_attach_domain()
>>>>                               update_top_cache_domain()
>>>
>>> IMHO, cpu_attach_domain() and update_top_cache_domain() should be
>>> paired, below patch will open a window which 'rq->sd == NULL' while
>>> 'sd_llc != NULL', isn't it?
>>>
>>> I don't think we have the promise that before we rebuild the stuff
>>> correctly, no one will utilize 'sd_llc'...
>>>
>> I never said it. My point is different.  partition_sched_domain works as -
>>
>>       - destroying existing schedule domain (if previous domain and new
>> domain aren't same)
>>       - building new partition
>>
>> while doing the first it needs to detach all the cpus on that domain.
>> By detaching what it does,
>> it fall backs to it's root default domain. In this context (which i've
>> proposed to skip), by means
>> of updating top cache domain it takes the highest flag domain to setup
>> it's sd_llc_id or cpu itself.
>>
>> Whatever done above gets overwritten (updating top cache domain),
>> while building new partition.
>> Then, why we did that before? Hope you understand my point.
>
> I think you missed this in PeterZ's suggestion:
>
> -               cpu_attach_domain(NULL, &def_root_domain, i);
>
> With this change, it will be safe since you will still get an un-freed
> sd, although it's an old one.
>
I never meant it and clearly I missed it. If you remove
cpu_attach_domain(), then detach_destroy_domain() becomes meaningless.
And I don't have any intent to remove cpu_attach_domain from
detach_destroy_domain() at all.

> But your patch will run the risk to get a freed sd, since you make
> 'sd_llc' wrong for a period of time (between destroy and rebuild) IMO.
>
Building 'sd_llc' depends on schedule domain. If you don't have sd,
sd_llc will point to NULL and sd_llc_id is
the CPU itself. Since, we're  trying to re-construing so for this time
being it doesn't matter, cause we're building
it again. Now, please just note what you're saying, on last thread
you've said -

       "I don't think we have the promise that before we rebuild the stuff
        correctly, no one will utilize 'sd_llc'..."

If that is the case, then we shouldn't worry about it at all. And this
above comments (from previous thread I've quoted and this thread I'm
replying) they're just self contradictory.

> I guess I get you point, you are trying to save one time update since
> you think this will be done twice, but actually the result of this two
> time update was different, it's not redo and it's in order to sync
> 'sd_llc' with 'rq->sd'.
>
Yes, you got my point now, but I don't understand your points. Anyway,
I'm not going to argue with this
anymore, this stuff isn't much of an issue, but removing this sorts of
stuff is typical in kernel development.

Thanks,
Rakib.
