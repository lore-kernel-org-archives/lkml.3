Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab3FLV7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 17:59:50 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45472 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3FLV7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 17:59:49 -0400
Message-ID: <51B8EC10.6070304@linux.vnet.ibm.com>
Date: Wed, 12 Jun 2013 14:45:52 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] mm/page_alloc: don't re-init pageset in zone_pcp_update()
References: <1370988779-7586-1-git-send-email-cody@linux.vnet.ibm.com> <20130612142032.882a28b7911ed24ca19e282e@linux-foundation.org>
In-Reply-To: <20130612142032.882a28b7911ed24ca19e282e@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
x-cbid: 13061221-3620-0000-0000-000003149903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 02:20 PM, Andrew Morton wrote:
> On Tue, 11 Jun 2013 15:12:59 -0700 Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
>
>> Factor pageset_set_high_and_batch() (which contains all needed logic too
>> set a pageset's ->high and ->batch inrespective of system state) out of
>> zone_pageset_init(), which avoids us calling pageset_init(), and
>> unsafely blowing away a pageset at runtime (leaked pages and
>> potentially some funky allocations would be the result) when memory
>> hotplug is triggered.
>
> This changelog is pretty screwed up :( It tells us what the patch does
> but not why it does it.
>

It says why it does it, though perhaps a bit hidden:
 >  avoids us calling pageset_init(), and unsafely blowing away a pageset

>> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
>> ---
>>
>> Unless memory hotplug is being triggered on boot, this should *not* be cause of Valdis
>> Kletnieks' reported bug in -next:
>>           "next-20130607 BUG: Bad page state in process systemd pfn:127643"
>
> And this addendum appears to hint at the info we need.

Note the *not*. I included this note only because I expected there would 
be a question of whether Valdis's reported bug was caused by this. It 
_isn't_. The bug this fix fixes is only triggered by memory_hotplug, and 
Valdis's bug occurred on boot.

> Please, send a new changelog?  That should include a description of the
> user-visible effects of the bug which is being fixed,  a description of
> why it occurs and a description of how it was fixed.It would also be
> helpful if you can identify which kernel version(s) need the fix.

It's just a -mm issue. It was introduced by my patchset starting with 
"mm/page_alloc: factor out setting of pcp->high and pcp->batch", where 
the actual place the bug snuck in was "mm/page_alloc: in 
zone_pcp_update(), uze zone_pageset_init()".

>
> Also, a Reported-by:Valdis would be appropriate.
>
I'm fine with adding it (I did take a look at my page_alloc.c changes 
because he reported that bug), but as mentioned before, this fixes a 
different bug.

Anyhow, a reorganized (and clearer) changelog with the same content follows:
---
mm/page_alloc: don't re-init pageset in zone_pcp_update()

When memory hotplug is triggered, we call pageset_init() on a 
per-cpu-pageset which both contains pages and is in use, causing both 
the leakage of those pages and (potentially) bad behaviour if a page is 
allocated from the pageset while it is being cleared.

Avoid this by factoring pageset_set_high_and_batch() (which contains all 
needed logic too set a pageset's ->high and ->batch inrespective of 
system state), and using that instead of zone_pageset_init() in 
zone_pcp_update().

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>



