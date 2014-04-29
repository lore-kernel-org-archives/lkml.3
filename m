Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602AbaD2KEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:04:10 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41418 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933587AbaD2KEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:04:09 -0400
Message-ID: <535F78A8.80403@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 15:32:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [BUG] kernel BUG at mm/vmacache.c:85!
References: <535EA976.1080402@linux.vnet.ibm.com> <CA+55aFxgW0fS=6xJsKP-WiOUw=aiCEvydj+pc+zDF8Pvn4v+Jw@mail.gmail.com> <CA+55aFzXAnTzfNL-bfUFnu15=4Z9HNigoo-XyjmwRvAWX_xz0A@mail.gmail.com> <1398724754.25549.35.camel@buesod1.americas.hpqcorp.net> <CA+55aFz0jrk-O9gq9VQrFBeWTpLt_5zPt9RsJO9htrqh+nKTfA@mail.gmail.com> <20140428161120.4cad719dc321e3c837db3fd6@linux-foundation.org> <CA+55aFwLSW3V76Y_O37Y8r_yaKQ+y0VMk=6SEEBpeFfGzsJUKA@mail.gmail.com> <1398730319.25549.40.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1398730319.25549.40.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042910-3568-0000-0000-00000566843D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 05:41 AM, Davidlohr Bueso wrote:
> On Mon, 2014-04-28 at 16:57 -0700, Linus Torvalds wrote:
>> On Mon, Apr 28, 2014 at 4:11 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>>
>>> unuse_mm() leaves current->mm at NULL so we'd hear about it pretty
>>> quickly if a user task was running use_mm/unuse_mm.
>>
>> Yes.
>>
>>> I think so.  Maybe it's time to cook up a debug patch for Srivatsa to
>>> use?  Dump the vma cache when the bug hits, or wire up some trace
>>> points.  Or perhaps plain old printks - it seems to be happening pretty
>>> early in boot.
>>
>> Well, I think Srivatsa has only seen it once, and wasn't able to
>> reproduce it, so we'd have to make it happen more first.
>>
>>> Are there additional sanity checks we can perform at cache addition
>>> time?
>>
>> I wouldn't really expect it to happen at cache addition time, since
>> that's really quite simple. There's only one caller of
>> vmacache_update(), namely find_vma(). And vmacache_update() does the
>> same sanity check that vmacache lookup does (ie check that the
>> passed-on mm is the current thread mm, and that we're not a kernel
>> thread).
> 
> Agreed.
> 
>> I'd be more inclined to think it's a missing invalidate, but I can
>> only think of two reasons to invalidate:
>>
>>  - the vma itself went away from the mm, got free'd/reused, and so
>> vm_mm changes..
>>
>>    But then we'd have to remove it from the rb-tree, and both callers
>> of vma_rb_erase() do a vmacache_invalidate()
> 
> Right, if this were the case, -next never would have allowed it.
> 
>>  - the mm of a thread changed
>>
>>    This is exec, use_mm(), and fork() (and fork really only just
>> because we copy the vmacache).
>>
>>    exec and fork do that "vmacache_flush(tsk)", which is why I was
>> looking at use_mm().
> 
> Here's a patch to remove treating kthreads specially. Not sure how
> easily it would be to test since Srivatsa only ran into it once and I
> see no other users complaining.
>

I guess I'll hold off on testing this fix until I get to reproduce
the bug more reliably..

Regards,
Srivatsa S. Bhat

> diff --git a/mm/mmu_context.c b/mm/mmu_context.c
> index f802c2d..41445bb 100644
> --- a/mm/mmu_context.c
> +++ b/mm/mmu_context.c
> @@ -4,6 +4,7 @@
>   */
> 
>  #include <linux/mm.h>
> +#include <linux/vmacache.h>
>  #include <linux/mmu_context.h>
>  #include <linux/export.h>
>  #include <linux/sched.h>
> @@ -29,6 +30,7 @@ void use_mm(struct mm_struct *mm)
>                 tsk->active_mm = mm;
>         }
>         tsk->mm = mm;
> +       vmacache_flush(tsk);
>         switch_mm(active_mm, mm, tsk);
>         task_unlock(tsk);
>  #ifdef finish_arch_post_lock_switch
> diff --git a/mm/vmacache.c b/mm/vmacache.c
> index 1037a3ba..04009d3 100644
> --- a/mm/vmacache.c
> +++ b/mm/vmacache.c
> @@ -36,13 +36,10 @@ void vmacache_flush_all(struct mm_struct *mm)
>   * get_user_pages()->find_vma().  The vmacache is task-local and this
>   * task's vmacache pertains to a different mm (ie, its own).  There is
>   * nothing we can do here.
> - *
> - * Also handle the case where a kernel thread has adopted this mm via use_mm().
> - * That kernel thread's vmacache is not applicable to this mm.
>   */
>  static bool vmacache_valid_mm(struct mm_struct *mm)
>  {
> -       return current->mm == mm && !(current->flags & PF_KTHREAD);
> +       return current->mm == mm;
>  }
> 
>  void vmacache_update(unsigned long addr, struct vm_area_struct *newvma)
> 
> 

