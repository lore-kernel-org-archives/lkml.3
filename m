Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaAPNAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:00:12 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:44725 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaAPNAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:00:09 -0500
Message-ID: <52D7D7AE.8070108@huawei.com>
Date: Thu, 16 Jan 2014 20:59:26 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Li Zefan <lizefan@huawei.com>, <robin.yb@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/fs: don't keep pages when receiving a pending SIGKILL
 in __get_user_pages()
References: <52D65568.6080106@huawei.com> <alpine.DEB.2.02.1401151508370.29404@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401151508370.29404@chino.kir.corp.google.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/16 7:15, David Rientjes wrote:

> On Wed, 15 Jan 2014, Xishi Qiu wrote:
> 
>> In the process IO direction, dio_refill_pages will call get_user_pages_fast 
>> to map the page from user space. If ret is less than 0 and IO is write, the 
>> function will create a zero page to fill data. This may work for some file 
>> system, but in some device operate we prefer whole write or fail, not half 
>> data half zero, e.g. fs metadata, like inode, identy.
>> This happens often when kill a process which is doing direct IO. Consider 
>> the following cases, the process A is doing IO process, may enter __get_user_pages 
>> function, if other processes send process A SIG_KILL, A will enter the 
>> following branches 
>> 		/*
>> 		 * If we have a pending SIGKILL, don't keep faulting
>> 		 * pages and potentially allocating memory.
>> 		 */
>> 		if (unlikely(fatal_signal_pending(current)))
>> 			return i ? i : -ERESTARTSYS;
>> Return current pages. direct IO will write the pages, the subsequent pages 
>> which can’t get will use zero page instead. 
>> This patch will modify this judgment, if receive SIG_KILL, release pages and 
>> return an error. Direct IO will find no blocks_available and return error 
>> direct, rather than half IO data and half zero page.
>>
>> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
>> Signed-off-by: Bin Yang <robin.yb@huawei.com>
> 
> It's scary to change the behavior of gup when some callers may want the 
> exact opposite of what you're intending here, which is sane fallback by 
> mapping the zero page.  In fact, gup never does put_page() itself and 
> __get_user_pages() always returns the number of pages pinned and may not 
> equal what is passed.
> 
> So, this definitely isn't the right solution for a special-case direct IO.  
> Instead, it would be better to code this directly in the caller and 
> compare the return value with nr_pages in dio_refill_pages() and then do 
> the put_page() itself before falling back to ZERO_PAGE().

Hi Rientjes,
You are right, we should not change the behavior of gup.
I have a question, if we only get a part of the pages from get_user_pages_fast(),
shall we write them to the disk? or add a check before write?
I'm not familiar with fs.

dio_refill_pages()
	get_user_pages_fast()

Thanks,
Xishi Qiu

