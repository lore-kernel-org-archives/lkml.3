Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbaIDCIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 22:08:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49980 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbaIDCIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 22:08:42 -0400
Message-ID: <5407C989.50605@oracle.com>
Date: Thu, 04 Sep 2014 10:08:09 +0800
From: Junxiao Bi <junxiao.bi@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: david@fromorbit.com, xuejiufei@huawei.com, ming.lei@canonical.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set
References: <1409723694-16047-1-git-send-email-junxiao.bi@oracle.com> <20140903161000.f383fa4c1a4086de054cb6a0@linux-foundation.org>
In-Reply-To: <20140903161000.f383fa4c1a4086de054cb6a0@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 07:10 AM, Andrew Morton wrote:
> On Wed,  3 Sep 2014 13:54:54 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:
> 
>> commit 21caf2fc1931 ("mm: teach mm by current context info to not do I/O during memory allocation")
>> introduces PF_MEMALLOC_NOIO flag to avoid doing I/O inside memory allocation, __GFP_IO is cleared
>> when this flag is set, but __GFP_FS implies __GFP_IO, it should also be cleared. Or it may still
>> run into I/O, like in superblock shrinker.
> 
> Is there an actual bug which inspired this fix?  If so, please describe
> it.
> 
Yes, an ocfs2 deadlock bug is related to this, there is a workqueue in
ocfs2 who is for building tcp connections and processing ocfs2 message.
Like when an new node is up in ocfs2 cluster, the workqueue will try to
build the connections to it, since there are some common code in
networking like sock_alloc() using GFP_KERNEL to allocate memory, direct
reclaim will be triggered and call into superblock shrinker if available
memory is not enough even set PF_MEMALLOC_NOIO for the workqueue. To
shrink the inode cache, ocfs2 needs release cluster lock and this
depends on workqueue to do it, so cause the deadlock. Not sure whether
there are similar issue for other cluster fs, like nfs, it is possible
rpciod hung like the ocfs2 workqueue?


> I don't think it's accurate to say that __GFP_FS implies __GFP_IO. 
> Where did that info come from?
__GFP_FS allowed callback into fs during memory allocation, and fs may
do io whatever __GFP_IO is set?
> 
> And the superblock shrinker is a good example of why this shouldn't be
> the case.  The main thing that code does is to reclaim clean fs objects
> without performing IO.  AFAICT the proposed patch will significantly
> weaken PF_MEMALLOC_NOIO allocation attempts by needlessly preventing
> the kernel from reclaiming such objects?
Even fs didn't do io in superblock shrinker, it is possible for a fs
process who is not convenient to set GFP_NOFS holding some fs lock and
call back fs again?

PF_MEMALLOC_NOIO is only set for some special processes. I think it
won't affect much.

Thanks,
Junxiao.
> 
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1936,11 +1936,13 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
>>  #define tsk_used_math(p) ((p)->flags & PF_USED_MATH)
>>  #define used_math() tsk_used_math(current)
>>  
>> -/* __GFP_IO isn't allowed if PF_MEMALLOC_NOIO is set in current->flags */
>> +/* __GFP_IO isn't allowed if PF_MEMALLOC_NOIO is set in current->flags
>> + * __GFP_FS is also cleared as it implies __GFP_IO.
>> + */
>>  static inline gfp_t memalloc_noio_flags(gfp_t flags)
>>  {
>>  	if (unlikely(current->flags & PF_MEMALLOC_NOIO))
>> -		flags &= ~__GFP_IO;
>> +		flags &= ~(__GFP_IO | __GFP_FS);
>>  	return flags;
>>  }
> 

