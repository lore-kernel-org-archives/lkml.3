Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab3GXIBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:01:37 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:35477 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3GXIBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:01:36 -0400
MIME-Version: 1.0
In-Reply-To: <51EF4969.4050807@linux.vnet.ibm.com>
References: <1374601332.9192.0.camel@localhost.localdomain>
	<51EF4969.4050807@linux.vnet.ibm.com>
Date: Wed, 24 Jul 2013 14:01:35 +0600
Message-ID: <CADZ9YHiJ4MYFkWqikKu0qHOsBYGEPYvC2JL5wE3iCUH6vTMKcA@mail.gmail.com>
Subject: Re: [PATCH v2] sched: update_top_cache_domain only at the times of
 building sched domain.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 9:26 AM, Michael Wang
<wangyun@linux.vnet.ibm.com> wrote:
> Hi, Rakib
>
> On 07/24/2013 01:42 AM, Rakib Mullick wrote:
>> Currently, update_top_cache_domain() is called whenever schedule domain is built or destroyed. But, the following
>> callpath shows that they're at the same callpath and can be avoided update_top_cache_domain() while destroying schedule
>> domain and update only at the times of building schedule domains.
>>
>>       partition_sched_domains()
>>               detach_destroy_domain()
>>                       cpu_attach_domain()
>>                               update_top_cache_domain()
>
> IMHO, cpu_attach_domain() and update_top_cache_domain() should be
> paired, below patch will open a window which 'rq->sd == NULL' while
> 'sd_llc != NULL', isn't it?
>
> I don't think we have the promise that before we rebuild the stuff
> correctly, no one will utilize 'sd_llc'...
>
I never said it. My point is different.  partition_sched_domain works as -

	- destroying existing schedule domain (if previous domain and new
domain aren't same)
	- building new partition

while doing the first it needs to detach all the cpus on that domain.
By detaching what it does,
it fall backs to it's root default domain. In this context (which i've
proposed to skip), by means
of updating top cache domain it takes the highest flag domain to setup
it's sd_llc_id or cpu itself.

Whatever done above gets overwritten (updating top cache domain),
while building new partition.
Then, why we did that before? Hope you understand my point.

Thanks,
Rakib.
