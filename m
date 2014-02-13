Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaBMHB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 02:01:29 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:38936 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbaBMHB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 02:01:27 -0500
Message-ID: <52FC6F2A.30905@linux.vnet.ibm.com>
Date: Thu, 13 Feb 2014 12:37:22 +0530
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
References: <1390388025-1418-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140206145105.27dec37b16f24e4ac5fd90ce@linux-foundation.org> <alpine.DEB.2.02.1402061456290.31828@chino.kir.corp.google.com> <20140206152219.45c2039e5092c8ea1c31fd38@linux-foundation.org> <alpine.DEB.2.02.1402061537180.3441@chino.kir.corp.google.com> <alpine.DEB.2.02.1402061557210.5061@chino.kir.corp.google.com> <52F4B8A4.70405@linux.vnet.ibm.com> <alpine.DEB.2.02.1402071239301.4212@chino.kir.corp.google.com> <52F88C16.70204@linux.vnet.ibm.com> <alpine.DEB.2.02.1402100200420.30650@chino.kir.corp.google.com> <52F8C556.6090006@linux.vnet.ibm.com> <alpine.DEB.2.02.1402101333160.15624@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402101333160.15624@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021307-1396-0000-0000-00000448E0B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 03:05 AM, David Rientjes wrote:
> On Mon, 10 Feb 2014, Raghavendra K T wrote:
>
>> So I understood that you are suggesting implementations like below
>>
>> 1) I do not have problem with the below approach, I could post this in
>> next version.
>> ( But this did not include 4k limit Linus mentioned to apply)
>>
>> unsigned long max_sane_readahead(unsigned long nr)
>> {
>>          unsigned long local_free_page;
>>          int nid;
>>
>>          nid = numa_mem_id();
>>
>>          /*
>>           * We sanitize readahead size depending on free memory in
>>           * the local node.
>>           */
>>          local_free_page = node_page_state(nid, NR_INACTIVE_FILE)
>>                            + node_page_state(nid, NR_FREE_PAGES);
>>          return min(nr, local_free_page / 2);
>> }
>>
>> 2) I did not go for below because Honza (Jan Kara) had some
>> concerns for 4k limit for normal case, and since I am not
>> the expert, I was waiting for opinions.
>>
>> unsigned long max_sane_readahead(unsigned long nr)
>> {
>>          unsigned long local_free_page, sane_nr;
>>          int nid;
>>
>>          nid = numa_mem_id();
>> 	/* limit the max readahead to 4k pages */
>> 	sane_nr = min(nr, MAX_REMOTE_READAHEAD);
>>
>>          /*
>>           * We sanitize readahead size depending on free memory in
>>           * the local node.
>>           */
>>          local_free_page = node_page_state(nid, NR_INACTIVE_FILE)
>>                            + node_page_state(nid, NR_FREE_PAGES);
>>          return min(sane_nr, local_free_page / 2);
>> }
>>
>
> I have no opinion on the 4KB pages, either of the above is just fine.
>

I was able to test (1) implementation on the system where readahead 
problem occurred. Unfortunately it did not help.

Reason seem to be that CONFIG_HAVE_MEMORYLESS_NODES dependency of
numa_mem_id(). The PPC machine I am facing problem has topology like
this:

numactl -H
---------
available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3 4 5 6 7 12 13 14 15 16 17 18 19 20 21 22 23 24 25
...
node 0 size: 0 MB
node 0 free: 0 MB
node 1 cpus: 8 9 10 11 32 33 34 35 ...
node 1 size: 8071 MB
node 1 free: 2479 MB
node distances:
node   0   1
   0:  10  20
   1:  20  10

So it seems numa_mem_id() does not help for all the configs..
Am I missing something ?

