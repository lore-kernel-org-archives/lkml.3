Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbaCKUNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:13:06 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47607 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531AbaCKUNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:13:04 -0400
Message-ID: <531F6E43.40901@oracle.com>
Date: Tue, 11 Mar 2014 16:12:51 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: mmap_sem lock assertion failure in __mlock_vma_pages_range
References: <531F6689.60307@oracle.com> <1394568453.2786.28.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1394568453.2786.28.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 04:07 PM, Davidlohr Bueso wrote:
> On Tue, 2014-03-11 at 15:39 -0400, Sasha Levin wrote:
>> Hi all,
>>
>> I've ended up deleting the log file by mistake, but this bug does seem to be important
>> so I'd rather not wait before the same issue is triggered again.
>>
>> The call chain is:
>>
>> 	mlock (mm/mlock.c:745)
>> 		__mm_populate (mm/mlock.c:700)
>> 			__mlock_vma_pages_range (mm/mlock.c:229)
>> 				VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
>
> So __mm_populate() is only called by mlock(2) and this VM_BUG_ON seems
> wrong as we call it without the lock held:
>
> 	up_write(&current->mm->mmap_sem);
> 	if (!error)
> 		error = __mm_populate(start, len, 0);
> 	return error;
> }
>
>>
>> It seems to be a rather simple trace triggered from userspace. The only recent patch
>> in the area (that I've noticed) was "mm/mlock: prepare params outside critical region".
>> I've reverted it and trying to testing without it.
>
> Odd, this patch should definitely *not* cause this. In any case every
> operation removed from the critical region is local to the function:
>
> 	lock_limit = rlimit(RLIMIT_MEMLOCK);
> 	lock_limit >>= PAGE_SHIFT;
> 	locked = len >> PAGE_SHIFT;
>
> 	down_write(&current->mm->mmap_sem);

Yeah, this patch doesn't look like it's causing it, I guess it was more of a "you touched this
code last - do you still remember what's going on here?" :).

It's semi-odd because it seems like an obvious issue to hit with trinity but it's the first time
I've seen it and it's probably been there for a while (that BUG_ON is there from 2009).


Thanks,
Sasha
