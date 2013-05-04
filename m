Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3EDJsE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 05:48:04 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:2356 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab3EDJsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 05:48:01 -0400
Message-ID: <5184D93C.7000806@parallels.com>
Date: Sat, 04 May 2013 13:47:40 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Matt Helsley <matthltc@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] pagemap: Introduce the /proc/PID/pagemap2 file
References: <51669E5F.4000801@parallels.com> <51669EA5.20209@parallels.com> <20130502170857.GB24627@us.ibm.com>
In-Reply-To: <20130502170857.GB24627@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 09:08 PM, Matt Helsley wrote:
> On Thu, Apr 11, 2013 at 03:29:41PM +0400, Pavel Emelyanov wrote:
>> This file is the same as the pagemap one, but shows entries with bits
>> 55-60 being zero (reserved for future use). Next patch will occupy one
>> of them.
> 
> This approach doesn't scale as well as it could. As best I can see
> CRIU would do:
> 
> for each vma in /proc/<pid>/smaps
> 	for each page in /proc/<pid>/pagemap2
> 		if soft dirty bit
> 			copy page
> 
> (possibly with pfn checks to avoid copying the same page mapped in
> multiple locations..)

Comparing pfns got from two subsequent pagemap reads doesn't help at all.
If they are equal, this can mean that either page is shared or (less likely,
but still) that the page, that used to be at the 1st pagemap was reclaimed
and mapped to the 2nd between two reads. If they differ, it can again mean
either not-shared (most likely) or shared (pfns were equal, but got reclaimed
and swapped in back).

Some better API for pages sharing would be nice, probably such API could be
also re-used for the user-space KSM :)

> However, if soft dirty bit changes could be queued up (from say the
> fault handler and page table ops that map/unmap pages) and accumulated
> in something like an interval tree it could be something like:
> 
> for each range of changed pages
> 	for each page in range
> 		copy page
> 
> IOW something that scales with the number of changed pages rather
> than the number of mapped pages.
> 
> So I wonder if CRIU would abandon pagemap2 in the future for something
> like this.

We'd surely adopt such APIs is one exists. One thing to note about one is that
we'd also appreciate if this API would be able to batch "present" bits as well
as "swapped" and "page-file" ones. We use these three in CRIU as well, and
these bits scanning can also be optimized.

> Cheers,
> 	-Matt Helsley
> 

Thanks,
Pavel
