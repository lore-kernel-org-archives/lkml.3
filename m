Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaAJKUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:20:42 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:58859 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaAJKUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:20:38 -0500
Message-ID: <52CFCB2D.7080104@linux.vnet.ibm.com>
Date: Fri, 10 Jan 2014 15:57:57 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V4] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
References: <1389295490-28707-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140110083656.GC26378@quack.suse.cz> <20140110095222.GE26378@quack.suse.cz>
In-Reply-To: <20140110095222.GE26378@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011010-1396-0000-0000-00000420442C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 03:22 PM, Jan Kara wrote:
> On Fri 10-01-14 09:36:56, Jan Kara wrote:
>> On Fri 10-01-14 00:54:50, Raghavendra K T wrote:
>>> We limit the number of readahead pages to 4k.
>>>
>>> max_sane_readahead returns zero on the cpu having no local memory
>>> node. Fix that by returning a sanitized number of pages viz.,
>>> minimum of (requested pages, 4k, number of local free pages)
>>>
>>> Result:
>>> fadvise experiment with FADV_WILLNEED on a x240 machine with 1GB testfile
>>> 32GB* 4G RAM  numa machine ( 12 iterations) yielded
>>>
>>> kernel       Avg        Stddev
>>> base         7.264      0.56%
>>> patched      7.285      1.14%
>>    OK, looks good to me. You can add:
>> Reviewed-by: Jan Kara <jack@suse.cz>
>    Hum, while doing some other work I've realized there may be still a
> problem hiding with the 16 MB limitation. E.g. the dynamic linker is
> doing MADV_WILLNEED on the shared libraries. If the library (or executable)
> is larger than 16 MB, then it may cause performance problems since access
> is random in nature and we don't really know which part of the file do we
> need first.
>
> I'm not sure what others think about this but I'm now more inclined to a
> bit more careful and introduce the 16 MB limit only for the NUMA case. I.e.
> something like:

Your suggestion makes sense. I do not have any strong preference.
may be we shall wait for Linus/Andrew's comments (if any) since Linus
suggested the 16MB idea.

>
> 	unsigned long local_free_page;
> 	int nid;
>
> 	nid = numa_node_id();
> 	if (node_present_pages(nid)) {
> 		/*
> 		 * We sanitize readahead size depending on free memory in
> 		 * the local node.
> 		 */
> 		local_free_page = node_page_state(nid, NR_INACTIVE_FILE)
> 				  + node_page_state(nid, NR_FREE_PAGES);
> 		return min(nr, local_free_page / 2);
> 	}
> 	/*
> 	 * Readahead onto remote memory is better than no readahead when local
> 	 * numa node does not have memory. We limit the readahead to 4k
> 	 * pages though to avoid trashing page cache.
> 	 */
> 	return min(nr, MAX_REMOTE_READAHEAD);
>

