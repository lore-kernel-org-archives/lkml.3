Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab3GYG2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 02:28:22 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:40640 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3GYG2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 02:28:21 -0400
Message-ID: <51F0C47E.4000900@linux.vnet.ibm.com>
Date: Thu, 25 Jul 2013 11:53:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org, mgorman@suse.de, minchan@kernel.org,
        cody@linux.vnet.ibm.com, rostedt@goodmis.org, jiang.liu@huawei.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: Restructure free-page stealing code and fix a
 bug
References: <20130722184805.9573.78514.stgit@srivatsabhat.in.ibm.com> <20130725031040.GA29193@hacker.(null)>
In-Reply-To: <20130725031040.GA29193@hacker.(null)>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072506-1618-0000-0000-000004570E09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 08:40 AM, Wanpeng Li wrote:
> On Tue, Jul 23, 2013 at 12:18:06AM +0530, Srivatsa S. Bhat wrote:
>> The free-page stealing code in __rmqueue_fallback() is somewhat hard to
>> follow, and has an incredible amount of subtlety hidden inside!
>>
>> First off, there is a minor bug in the reporting of change-of-ownership of
>> pageblocks. Under some conditions, we try to move upto 'pageblock_nr_pages'
>> no. of pages to the preferred allocation list. But we change the ownership
>> of that pageblock to the preferred type only if we manage to successfully
>> move atleast half of that pageblock (or if page_group_by_mobility_disabled
>> is set).
>>
>> However, the current code ignores the latter part and sets the 'migratetype'
>> variable to the preferred type, irrespective of whether we actually changed
>> the pageblock migratetype of that block or not. So, the page_alloc_extfrag
>> tracepoint can end up printing incorrect info (i.e., 'change_ownership'
>> might be shown as 1 when it must have been 0).
>>
>> So fixing this involves moving the update of the 'migratetype' variable to
>> the right place. But looking closer, we observe that the 'migratetype' variable
>> is used subsequently for checks such as "is_migrate_cma()". Obviously the
>> intent there is to check if the *fallback* type is MIGRATE_CMA, but since we
>> already set the 'migratetype' variable to start_migratetype, we end up checking
>> if the *preferred* type is MIGRATE_CMA!!
>>
>> To make things more interesting, this actually doesn't cause a bug in practice,
>> because we never change *anything* if the fallback type is CMA.
>>
>> So, restructure the code in such a way that it is trivial to understand what
>> is going on, and also fix the above mentioned bug. And while at it, also add a
>> comment explaining the subtlety behind the migratetype used in the call to
>> expand().
>>
> 
> Greate catch!
> 

Thank you :-)

Regards,
Srivatsa S. Bhat

