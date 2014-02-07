Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaBGKgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:36:35 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:57109 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaBGKgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:36:32 -0500
Message-ID: <52F4B8A4.70405@linux.vnet.ibm.com>
Date: Fri, 07 Feb 2014 16:12:44 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        Linus <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
References: <1390388025-1418-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140206145105.27dec37b16f24e4ac5fd90ce@linux-foundation.org> <alpine.DEB.2.02.1402061456290.31828@chino.kir.corp.google.com> <20140206152219.45c2039e5092c8ea1c31fd38@linux-foundation.org> <alpine.DEB.2.02.1402061537180.3441@chino.kir.corp.google.com> <alpine.DEB.2.02.1402061557210.5061@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402061557210.5061@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020710-9574-0000-0000-00000BD5158A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 05:28 AM, David Rientjes wrote:
> On Thu, 6 Feb 2014, David Rientjes wrote:
>
>>>>>> +#define MAX_REMOTE_READAHEAD   4096UL
>
>> Normally it wouldn't matter because there's no significant downside to it
>> racing, things like mempolicies which use numa_node_id() extensively would
>> result in, oops, a page allocation on the wrong node.
>>
>> This stands out to me, though, because you're expecting the calculation to
>> be correct for a specific node.
>>
>> The patch is still wrong, though, it should just do
>>
>> 	int node = ACCESS_ONCE(numa_mem_id());
>> 	return min(nr, (node_page_state(node, NR_INACTIVE_FILE) +
>> 		        node_page_state(node, NR_FREE_PAGES)) / 2);
>>
>> since we want to readahead based on the cpu's local node, the comment
>> saying we're reading ahead onto "remote memory" is wrong since a
>> memoryless node has local affinity to numa_mem_id().
>>
>
> Oops, forgot about the MAX_REMOTE_READAHEAD which needs to be factored in
> as well, but this handles the bound on local node's statistics.
>

So following discussion TODO for my patch is:

1) Update the changelog with user visible impact of the patch.
(Andrew's suggestion)
2) Add ACCESS_ONCE to numa_node_id().
3) Change the "readahead into remote memory" part of the documentation
which is misleading.

( I feel no need to add numa_mem_id() since we would specifically limit
the readahead with MAX_REMOTE_READAHEAD in memoryless cpu cases).

