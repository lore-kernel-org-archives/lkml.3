Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbaIEAhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 20:37:19 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50140 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaIEAhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 20:37:16 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <540905B1.1050200@lge.com>
Date: Fri, 05 Sep 2014 09:37:05 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jack@suse.cz, tytso@mit.edu, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, adilger.kernel@dilger.ca, minchan@kernel.org,
        js1304@gmail.com, gunho.lee@lge.com
Subject: Re: [PATCHv4 0/3] new APIs to allocate buffer-cache with user specific
 flag
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com> <20140904151612.7bf5b813069ff78973e01571@linux-foundation.org>
In-Reply-To: <20140904151612.7bf5b813069ff78973e01571@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-09-05 오전 7:16, Andrew Morton 쓴 글:
> On Thu,  4 Sep 2014 16:29:38 +0900 Gioh Kim <gioh.kim@lge.com> wrote:
>
>> This patch try to solve problem that a long-lasting page caches of
>> ext4 superblock and journaling of superblock disturb page migration.
>>
>> I've been testing CMA feature on my ARM-based platform
>> and found that two page caches cannot be migrated.
>> They are page caches of superblock of ext4 filesystem and its journaling data.
>>
>> Current ext4 reads superblock with sb_bread() that allocates page
>> from movable area. But the problem is that ext4 hold the page until
>> it is unmounted. If root filesystem is ext4 the page cannot be migrated
>> forever.
>> And also the journaling data for the superblock cannot be migreated.
>>
>> I introduce new APIs that allocates page cache with specific flag passed by an
>> argument.
>> *_gfp APIs are for user want to set page allocation flag for page cache
>> allocation.
>> And *_unmovable APIs are for the user wants to allocate page cache from
>> non-movable area.
>>
>> It is useful for ext4/ext3 and others that want to hold page cache for a long
>> time.
>
> Could we please have some detailed information about the real-world
> effect of this patchset?
>
> You earlier said "My test platform is currently selling item in the
> market.  And also I test my patch when my platform is working as if
> real user uses it.".

OK. I'm writing details as possible as I can.
Please feel free to request me more information.

My platform is TV and 1GB system memory and 256MB CMA memory.
I want to use full 256MB CMA memory.

>
> But what were the problems which were observed in standard kernels and
> what effect did this patchset have upon them?  Some quantitative
> measurements will really help here.

The problem is that I cannot allocate entire CMA memory.
Actually the problem is not found without Joonsoo's patch: https://lkml.org/lkml/2014/5/28/64.
Without it CMA memory is free and every CMA-memory allocation is successed.

If the Joonsoo's patch is applied, the CMA memory is allocated generally when system boots-up.
Therefore superblocks of mounted filesystem and buffer cache of it are allocation from CMA memory.

I have three ext4 partitions and one squash partition.
The squash filesystem has no problem. It holds buffer-cache temporarily.

But each ext4 partition holds 2 buffer-cache until unmounted (one for sb and one for journal)
so that I found 2 or 3 pages, the page are storing buffer-cache, are busy in my platform
when I try to allocate 256MB, entiry CMA memory.
So my allocation fails.

This patchset makes the long-lasting buffer-caches be allocated in non-CMA area.
Therefore I can success to allocate the entire CMA memory always.

Please tell me what I have to measure quantitatively?
What I know is every ext4 filesystem has 2 long-lasting buffer-cache
that are released when it is unmounted.

I applied this patch and try to allocate the entire CMA memory almost 100-times.
And I successed always.

>
> I'm trying to get an understanding of how effective and important the
> change is, whether others will see similar benefits.  I'd also like to
> understand how *complete* the fix is - were the problems which you
> observed completely fixed, or do outstanding problems remain?

I think this patch has benefits only for systems that use CMA or HOTPLUG feature.
As I mentioned above, the problem is not occured without Joonsoo's patch that allocates CMA area frequently.

If a system want to use CMA/HOTPLUG feature, I think, this patch is very important.
The problem is only several pages but several MB can be wasted considering an align of allocation size.
If allocation size align is 16MB and one page is busy, 16MB can be wasted.
For embedded system like TV 16MB is really big issue.

I beleive the problem is completely fixed with my patch.
I've tested many times for several days and reviewed ext4 code that deals with buffer-header.
I couldn't find any other problem.

I'm sorry to confuse you with my poor English.
Please reply me whatever you need.

Next week is Korean thanksgiving holidays.
I think I can reply on Fri.

>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
