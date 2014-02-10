Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaBJMTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:19:52 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:53534 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaBJMTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:19:48 -0500
Message-ID: <52F8C556.6090006@linux.vnet.ibm.com>
Date: Mon, 10 Feb 2014 17:55:58 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
References: <1390388025-1418-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140206145105.27dec37b16f24e4ac5fd90ce@linux-foundation.org> <alpine.DEB.2.02.1402061456290.31828@chino.kir.corp.google.com> <20140206152219.45c2039e5092c8ea1c31fd38@linux-foundation.org> <alpine.DEB.2.02.1402061537180.3441@chino.kir.corp.google.com> <alpine.DEB.2.02.1402061557210.5061@chino.kir.corp.google.com> <52F4B8A4.70405@linux.vnet.ibm.com> <alpine.DEB.2.02.1402071239301.4212@chino.kir.corp.google.com> <52F88C16.70204@linux.vnet.ibm.com> <alpine.DEB.2.02.1402100200420.30650@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402100200420.30650@chino.kir.corp.google.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021012-5140-0000-0000-00000488C8CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 03:35 PM, David Rientjes wrote:
> On Mon, 10 Feb 2014, Raghavendra K T wrote:
>
>> As you rightly pointed , I 'll drop remote memory term and use
>> something like  :
>>
>> "* Ensure readahead success on a memoryless node cpu. But we limit
>>   * the readahead to 4k pages to avoid trashing page cache." ..
>>
>
> I don't know how to proceed here after pointing it out twice, I'm afraid.
>
> numa_mem_id() is local memory for a memoryless node.  node_present_pages()
> has no place in your patch.

Hi David,  I am happy to see your pointer reg. numa_mem_id(). I did not
meant to be ignoring/offensive .. sorry if conversation thought to be so.

So I understood that you are suggesting implementations like below

1) I do not have problem with the below approach, I could post this in
next version.
( But this did not include 4k limit Linus mentioned to apply)

unsigned long max_sane_readahead(unsigned long nr)
{
         unsigned long local_free_page;
         int nid;

         nid = numa_mem_id();

         /*
          * We sanitize readahead size depending on free memory in
          * the local node.
          */
         local_free_page = node_page_state(nid, NR_INACTIVE_FILE)
                           + node_page_state(nid, NR_FREE_PAGES);
         return min(nr, local_free_page / 2);
}

2) I did not go for below because Honza (Jan Kara) had some
concerns for 4k limit for normal case, and since I am not
the expert, I was waiting for opinions.

unsigned long max_sane_readahead(unsigned long nr)
{
         unsigned long local_free_page, sane_nr;
         int nid;

         nid = numa_mem_id();
	/* limit the max readahead to 4k pages */
	sane_nr = min(nr, MAX_REMOTE_READAHEAD);

         /*
          * We sanitize readahead size depending on free memory in
          * the local node.
          */
         local_free_page = node_page_state(nid, NR_INACTIVE_FILE)
                           + node_page_state(nid, NR_FREE_PAGES);
         return min(sane_nr, local_free_page / 2);
}

>
>> Regarding ACCESS_ONCE, since we will have to add
>> inside the function and still there is nothing that could prevent us
>> getting run on different cpu with a different node (as Andrew ponted), I have
>> not included in current patch that I am posting.
>> Moreover this case is hopefully not fatal since it is just a hint for
>> readahead we can do.
>>
>
> I have no idea why you think the ACCESS_ONCE() is a problem.  It's relying
> on gcc's implementation to ensure that the equation is done only for one
> node.  It has absolutely nothing to do with the fact that the process may
> be moved to another cpu upon returning or even immediately after the
> calculation is done.  Is it possible that node0 has 80% of memory free and
> node1 has 80% of memory inactive?  Well, then your equation doesn't work
> quite so well if the process moves.
>
> There is no downside whatsoever to using it, I have no idea why you think
> it's better without it.

I have no problem introducing ACESSS_ONCE too. But I skipped only
after I got the below error.

mm/readahead.c: In function ‘max_sane_readahead’:
mm/readahead.c:246: error: lvalue required as unary ‘&’ operand

>
>> So there are many possible implementation:
>> (1) use numa_mem_id(), apply freepage limit  and use 4k page limit for all
>> case
>> (Jan had reservation about this case)
>>
>> (2)for normal case:    use free memory calculation and do not apply 4k
>>      limit (no change).
>>     for memoryless cpu case:  use numa_mem_id for more accurate
>>      calculation of limit and also apply 4k limit.
>>
>> (3) for normal case:   use free memory calculation and do not apply 4k
>>      limit (no change).
>>      for memoryless case: apply 4k page limit
>>
>> (4) use numa_mem_id() and apply only free page limit..
>>
>> So, I ll be resending the patch with changelog and comment changes
>> based on your and Andrew's feedback (type (3) implementation).
>>
>
> It's frustrating to have to say something three times.  Ask yourself what
> happens if ALL NODES WITH CPUS DO NOT HAVE MEMORY?
>

True, this is the reason why we could go for implementation (1) I posted
above. It was just that I did not want to float a new version without
knowing whether Andrew was expecting new patch or change log updates.

