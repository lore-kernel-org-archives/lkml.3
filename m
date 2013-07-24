Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab3GXIew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:34:52 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44648 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3GXIes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:34:48 -0400
Message-ID: <51EF919F.2000706@linux.vnet.ibm.com>
Date: Wed, 24 Jul 2013 16:34:39 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched: update_top_cache_domain only at the times of
 building sched domain.
References: <1374601332.9192.0.camel@localhost.localdomain> <51EF4969.4050807@linux.vnet.ibm.com> <CADZ9YHiJ4MYFkWqikKu0qHOsBYGEPYvC2JL5wE3iCUH6vTMKcA@mail.gmail.com>
In-Reply-To: <CADZ9YHiJ4MYFkWqikKu0qHOsBYGEPYvC2JL5wE3iCUH6vTMKcA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072408-5140-0000-0000-00000391C788
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 04:01 PM, Rakib Mullick wrote:
> On Wed, Jul 24, 2013 at 9:26 AM, Michael Wang
> <wangyun@linux.vnet.ibm.com> wrote:
>> Hi, Rakib
>>
>> On 07/24/2013 01:42 AM, Rakib Mullick wrote:
>>> Currently, update_top_cache_domain() is called whenever schedule domain is built or destroyed. But, the following
>>> callpath shows that they're at the same callpath and can be avoided update_top_cache_domain() while destroying schedule
>>> domain and update only at the times of building schedule domains.
>>>
>>>       partition_sched_domains()
>>>               detach_destroy_domain()
>>>                       cpu_attach_domain()
>>>                               update_top_cache_domain()
>>
>> IMHO, cpu_attach_domain() and update_top_cache_domain() should be
>> paired, below patch will open a window which 'rq->sd == NULL' while
>> 'sd_llc != NULL', isn't it?
>>
>> I don't think we have the promise that before we rebuild the stuff
>> correctly, no one will utilize 'sd_llc'...
>>
> I never said it. My point is different.  partition_sched_domain works as -
> 
> 	- destroying existing schedule domain (if previous domain and new
> domain aren't same)
> 	- building new partition
> 
> while doing the first it needs to detach all the cpus on that domain.
> By detaching what it does,
> it fall backs to it's root default domain. In this context (which i've
> proposed to skip), by means
> of updating top cache domain it takes the highest flag domain to setup
> it's sd_llc_id or cpu itself.
> 
> Whatever done above gets overwritten (updating top cache domain),
> while building new partition.
> Then, why we did that before? Hope you understand my point.

I think you missed this in PeterZ's suggestion:

-               cpu_attach_domain(NULL, &def_root_domain, i);

With this change, it will be safe since you will still get an un-freed
sd, although it's an old one.

But your patch will run the risk to get a freed sd, since you make
'sd_llc' wrong for a period of time (between destroy and rebuild) IMO.

I guess I get you point, you are trying to save one time update since
you think this will be done twice, but actually the result of this two
time update was different, it's not redo and it's in order to sync
'sd_llc' with 'rq->sd'.

Regards,
Michael Wang


> 
> Thanks,
> Rakib.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

