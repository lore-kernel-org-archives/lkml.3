Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab3LDIWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:22:21 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41438 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab3LDIWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:22:18 -0500
Message-ID: <529EE811.5050306@linux.vnet.ibm.com>
Date: Wed, 04 Dec 2013 14:00:09 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] mm readahead: Fix the readahead fail in case of empty
 numa node
References: <1386066977-17368-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20131203143841.11b71e387dc1db3a8ab0974c@linux-foundation.org>
In-Reply-To: <20131203143841.11b71e387dc1db3a8ab0974c@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120408-0260-0000-0000-0000040B5723
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you Andrew.

On 12/04/2013 04:08 AM, Andrew Morton wrote:
> On Tue,  3 Dec 2013 16:06:17 +0530 Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:
>
>> On a cpu with an empty numa node,
>
> This makes no sense - numa nodes don't reside on CPUs.
>
> I think you mean "on a CPU which resides on a memoryless NUMA node"?

You are right. I was not precise there.
I had this example in mind while talking.

IBM P730
----------------------------------
# numactl -H
available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 
23 24 25 26 27 28 29 30 31
node 0 size: 0 MB
node 0 free: 0 MB
node 1 cpus:
node 1 size: 12288 MB
node 1 free: 10440 MB
node distances:
node   0   1
0:  10  40
1:  40  10

>
>> readahead fails because max_sane_readahead
>> returns zero. The reason is we look into number of inactive + free pages
>> available on the current node.
>>
>> The following patch tries to fix the behaviour by checking for potential
>> empty numa node cases.
>> The rationale for the patch is, readahead may be worth doing on a remote
>> node instead of incuring costly disk faults later.
>>
>> I still feel we may have to sanitize the nr below, (for e.g., nr/8)
>> to avoid serious consequences of malicious application trying to do
>> a big readahead on a empty numa node causing unnecessary load on remote nodes.
>> ( or it may even be that current behaviour is right in not going ahead with
>> readahead to avoid the memory load on remote nodes).
>>
>
> I don't recall the rationale for the current code and of course we
> didn't document it.  It might be in the changelogs somewhere - could
> you please do the git digging and see if you can find out?

Unfaortunately, from my search, I saw that the code belonged to pre git
time, so could not get much information on that.

>
> I don't immediately see why readahead into a different node is
> considered a bad thing.
>

Ok.

>> --- a/mm/readahead.c
>> +++ b/mm/readahead.c
>> @@ -243,8 +243,11 @@ int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
>>    */
>>   unsigned long max_sane_readahead(unsigned long nr)
>>   {
>> -	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
>> -		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
>> +	unsigned long numa_free_page;
>> +	numa_free_page = (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
>> +			   + node_page_state(numa_node_id(), NR_FREE_PAGES));
>> +
>> +	return numa_free_page ? min(nr, numa_free_page / 2) : nr;
>
> Well even if this CPU's node has very little pagecache at all, what's
> wrong with permitting readahead?  We don't know that the new pagecache
> will be allocated exclusively from this CPU's node anyway.  All very
> odd.
>

true we do not know from where it gets allocated and also I completely 
agree that I could not think why we  should not think
of entire memory rather than sticking our decision to one node.

Or is this  one of proactive case to stop worsening situation when 
system is really short of memory?

Do let me know if you have any idea to handle 'little cache case'
or do you think the current one is simple enough for now to live with.

> Whatever we do, we should leave behind some good code comments which
> explain the rationale(s), please.  Right now it's rather opaque.
>

Yes. For the current code may be we have to have comment some thing
like ?

/*
  * Sanitize readahead when we have less memory on the current node.
  * We do not want to load remote memory with readahead case.
  */

and if this patch is okay then some thing like.

/*
  * Sanitized readahead onto remote memory is better than no readahead
  * when local numa node does not have memory. If local numa has less
  * memory we trim readahead size depending on potential free memory
  * available.
  */

