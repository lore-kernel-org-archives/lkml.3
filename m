Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab3E3VBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 17:01:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36237 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690Ab3E3VBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 17:01:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130524140114.GK23650@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu>
 <20130523044803.GA25399@ZenIV.linux.org.uk> <20130523104154.GA23650@twins.programming.kicks-ass.net>
 <0000013ed1b8d0cc-ad2bb878-51bd-430c-8159-629b23ed1b44-000000@email.amazonses.com>
 <20130523152458.GD23650@twins.programming.kicks-ass.net> <0000013ed2297ba8-467d474a-7068-45b3-9fa3-82641e6aa363-000000@email.amazonses.com>
 <20130523163901.GG23650@twins.programming.kicks-ass.net> <0000013ed28b638a-066d7dc7-b590-49f8-9423-badb9537b8b6-000000@email.amazonses.com>
 <20130524140114.GK23650@twins.programming.kicks-ass.net>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 30 May 2013 17:00:55 -0400
Message-ID: <CAHGf_=oL+8n1aFx1T-7iH0gw9f95yY9doAdE+PZd4biSUTzstw@mail.gmail.com>
Subject: Re: [RFC][PATCH] mm: Fix RLIMIT_MEMLOCK
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland Dreier <roland@kernel.org>, infinipath@qlogic.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index a841123..f8f47dc 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -137,17 +137,22 @@ struct ib_umem *ib_umem_get (struct ib_ucontext *context, unsigned long addr,
>
>         down_write(&current->mm->mmap_sem);
>
> -       locked     = npages + current->mm->pinned_vm;
> +       locked     = npages + mm_locked_pages(current->mm);
>         lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>
>         if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
>                 ret = -ENOMEM;
> -               goto out;
> +               goto err;
>         }
>
>         cur_base = addr & PAGE_MASK;
> +       umem->start_addr = cur_base;
> +       umem->end_addr   = cur_base + npages;
> +
> +       ret = mm_mpin(umem->start_addr, umem->end_addr);
> +       if (ret)
> +               goto err;

I believe RLIMIT_MEMLOCK should be checked within mm_mpin().


> +static inline unsigned long mm_locked_pages(struct mm_struct *mm)
> +{
> +       return mm->pinned_vm + mm->locked_vm;
> +}

This is acceptable. but if we create mm_locked_pages(), /proc should
also use this.
Otherwise pinning operation magically decrease VmLck field in
/proc/pid/status and people
get a confusion.



> @@ -310,9 +309,49 @@ static int mlock_fixup(struct vm_area_struct *vma, struct vm_area_struct **prev,
>          * Keep track of amount of locked VM.
>          */
>         nr_pages = (end - start) >> PAGE_SHIFT;
> -       if (!lock)
> -               nr_pages = -nr_pages;
> -       mm->locked_vm += nr_pages;
> +
> +       /*
> +        * We should only account pages once, if VM_PINNED is set pages are
> +        * accounted in mm_struct::pinned_vm, otherwise if VM_LOCKED is set,
> +        * we'll account them in mm_struct::locked_vm.
> +        *
> +        * PL  := vma->vm_flags
> +        * PL' := newflags
> +        * PLd := {pinned,locked}_vm delta
> +        *
> +        * PL->PL' PLd
> +        * -----------
> +        * 00  01  0+
> +        * 00  10  +0
> +        * 01  11  +-
> +        * 01  00  0-
> +        * 10  00  -0
> +        * 10  11  00
> +        * 11  01  -+
> +        * 11  10  00
> +        */

This comment is too cryptic. :-)
