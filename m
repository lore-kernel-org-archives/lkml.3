Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaGNIGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:06:31 -0400
Received: from relay.parallels.com ([195.214.232.42]:48289 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaGNIGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:06:15 -0400
Message-ID: <53C38F69.4070304@parallels.com>
Date: Mon, 14 Jul 2014 12:06:01 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <riel@redhat.com>, <linux-kernel@vger.kernel.org>, <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <kosaki.motohiro@jp.fujitsu.com>,
        <fengguang.wu@intel.com>, <jweiner@redhat.com>
Subject: Re: [PATCH] mm/page-writeback.c: fix divide by zero in bdi_dirty_limits
References: <20140711081656.15654.19946.stgit@localhost.localdomain> <20140711152732.de78603744cd861497eca5dc@linux-foundation.org>
In-Reply-To: <20140711152732.de78603744cd861497eca5dc@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 07/12/2014 02:27 AM, Andrew Morton wrote:
> On Fri, 11 Jul 2014 12:18:27 +0400 Maxim Patlasov <MPatlasov@parallels.com> wrote:
>
>> Under memory pressure, it is possible for dirty_thresh, calculated by
>> global_dirty_limits() in balance_dirty_pages(), to equal zero.
> Under what circumstances?  Really small values of vm_dirty_bytes?

No, I used default settings:

vm_dirty_bytes = 0;
dirty_background_bytes = 0;
vm_dirty_ratio = 20;
dirty_background_ratio = 10;

and a simple program like main() { while(1) { p = malloc(4096); mlock(p, 
4096); } }. Of course, this triggers oom eventually, but immediately 
before oom, the system is under hard memory pressure.

>
>> Then, if
>> strictlimit is true, bdi_dirty_limits() tries to resolve the proportion:
>>
>>    bdi_bg_thresh : bdi_thresh = background_thresh : dirty_thresh
>>
>> by dividing by zero.
>>
>> ...
>>
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -1306,9 +1306,9 @@ static inline void bdi_dirty_limits(struct backing_dev_info *bdi,
>>   	*bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
>>   
>>   	if (bdi_bg_thresh)
>> -		*bdi_bg_thresh = div_u64((u64)*bdi_thresh *
>> -					 background_thresh,
>> -					 dirty_thresh);
>> +		*bdi_bg_thresh = dirty_thresh ? div_u64((u64)*bdi_thresh *
>> +							background_thresh,
>> +							dirty_thresh) : 0;
> This introduces a peculiar discontinuity:
>
> if dirty_thresh==3, treat it as 3
> if dirty_thresh==2, treat it as 2
> if dirty_thresh==1, treat it as 1
> if dirty_thresh==0, treat it as infinity

No, the patch doesn't treat dirty_thresh==0 as infinity. In fact, in 
that case we have equation: x : 0 = 0 : 0, and the patch resolves it as 
x=0. Here is the reasoning:

1. A bdi counter is always a fraction of global one. Hence bdi_thresh is 
always not greater than dirty_thresh. So far as dirty_thresh is equal to 
zero, bdi_thresh is equal to zero too.
2. bdi_bg_thresh must be not greater than bdi_thresh because we want to 
start background process earlier than throttling it. So far as 
bdi_thresh is equal to zero, bdi_bg_thresh must be zero too.


>
> Would it not make more sense to change global_dirty_limits() to convert
> 0 to 1?  With an appropriate comment, obviously.
>
>
> Or maybe the fix lies elsewhere.  Please do tell us how this zero comes
> about.
>

Firstly let me explain where available_memory equal to one came from. 
global_dirty_limits() calculates it by calling 
global_dirtyable_memory(). The latter takes into consideration three 
global counters and a global reserve. In my case corresponding values were:

NR_INACTIVE_FILE = 0
NR_ACTIVE_FILE = 0
NR_FREE_PAGES = 7006
dirty_balance_reserve = 7959.

Consequently, "x" in global_dirtyable_memory() was equal to zero, and 
the function returned one. Now global_dirty_limits() assigns 
available_memory to one and calculates "dirty" as a fraction of 
available_memory:

     dirty = (vm_dirty_ratio * available_memory) / 100;

So far as vm_drity_ratio is lesser than 100 (it is 20 by default), dirty 
is calculated as zero.

As for your question about conversion 0 to 1, I think that bdi_thresh = 
dirty_thresh = 0 makes natural sense: we are under strong memory 
pressure, please always start background writeback and throttle process 
(even if actual number of dirty pages is low). So other parts of 
balance_dirty_pages machinery must handle zero thresholds properly.

Thanks,
Maxim
