Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaFCCNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 22:13:15 -0400
Received: from linuxhacker.ru ([217.76.32.60]:55871 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbaFCCNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 22:13:13 -0400
Subject: Re: [PATCH] sysctl: Fix division by zero in percpu_pagelist_fraction handler
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <alpine.DEB.2.02.1406021837490.13072@chino.kir.corp.google.com>
Date: Mon, 2 Jun 2014 22:12:57 -0400
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Rohit Seth <rohitseth@google.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <B549468A-10FC-4897-8720-7C9FEC6FD03A@linuxhacker.ru>
References: <1399166883-514-1-git-send-email-green@linuxhacker.ru> <alpine.DEB.2.02.1406021837490.13072@chino.kir.corp.google.com>
To: David Rientjes <rientjes@google.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Jun 2, 2014, at 9:40 PM, David Rientjes wrote:
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 5dba293..91d0265 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5854,7 +5854,7 @@ int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
>> 	int ret;
>> 
>> 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
>> -	if (!write || (ret < 0))
>> +	if (!write || (ret < 0) || !*length)
>> 		return ret;
>> 
>> 	mutex_lock(&pcp_batch_high_lock);
> This hasn't made it to linux-next yet (probably because you didn't cc 
> Andrew Morton, the mm maintainer), but I'm wondering why it's needed.  
> Shouldn't this value always be >= min_percpu_pagelist_fract?
> 
> If there's something going on in proc_dointvec_minmax() that disregards 
> that minimum then we need to fix it rather than the caller.

It's needed because at the very beginning of proc_dointvec_minmax it checks if the length is 0 and if it is, immediately returns success because there's nothing to be done
from it's perspective.
And since percpu_pagelist_fraction is 0 from the very beginning, next step is division by this value.

If length is not 0 on the other hand, then there's some value proc_dointvec_minmax can interpret and the min and max checks happen and everything works correctly.

This is kind of hard to fix in proc_dointvec_minmax because there's no passed in value to check against, I think. Sure, you can also check the passed in pointer to value
to make sure it's within range, but that goes beyond the scope of the function.
You might as well just assign a sane value to percpu_pagelist_fraction, which has an added benefit of when you cat that /proc file, you'll get real value of what the kernel uses instead of 0.

Bye,
    Oleg