Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbaIDCS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 22:18:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22641 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbaIDCSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 22:18:54 -0400
Message-ID: <5407CBEA.9090909@oracle.com>
Date: Thu, 04 Sep 2014 10:18:18 +0800
From: Junxiao Bi <junxiao.bi@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@primarydata.com>
CC: david@fromorbit.com, akpm@linux-foundation.org, xuejiufei@huawei.com,
        ming.lei@canonical.com,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Devel FS Linux <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set
References: <1409723694-16047-1-git-send-email-junxiao.bi@oracle.com> <CAHQdGtTWjD5szmwtcv0fXxgmhdYea1h9wYddwhhPxnP5wBaToA@mail.gmail.com>
In-Reply-To: <CAHQdGtTWjD5szmwtcv0fXxgmhdYea1h9wYddwhhPxnP5wBaToA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 08:20 PM, Trond Myklebust wrote:
> On Wed, Sep 3, 2014 at 1:54 AM, Junxiao Bi <junxiao.bi@oracle.com> wrote:
>> commit 21caf2fc1931 ("mm: teach mm by current context info to not do I/O during memory allocation")
>> introduces PF_MEMALLOC_NOIO flag to avoid doing I/O inside memory allocation, __GFP_IO is cleared
>> when this flag is set, but __GFP_FS implies __GFP_IO, it should also be cleared. Or it may still
>> run into I/O, like in superblock shrinker.
>>
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> Cc: joyce.xue <xuejiufei@huawei.com>
>> Cc: Ming Lei <ming.lei@canonical.com>
>> ---
>>  include/linux/sched.h |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 5c2c885..2fb2c47 100644
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
>>         if (unlikely(current->flags & PF_MEMALLOC_NOIO))
>> -               flags &= ~__GFP_IO;
>> +               flags &= ~(__GFP_IO | __GFP_FS);
>>         return flags;
>>  }
>>
> 
> Shouldn't this be a stable fix? If it is needed, then it will affect
> all kernels that define PF_MEMALLOC_NOIO.
Yes, should be. An ocfs2 deadlock bug related to this.

Thanks,
Junxiao.
> 

