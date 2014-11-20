Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbaKTLjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:39:20 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:34175 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaKTLjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:39:17 -0500
Message-ID: <546DD2DE.9080405@de.ibm.com>
Date: Thu, 20 Nov 2014 12:39:10 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Krebbel <Andreas.Krebbel@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: compiler bug gcc4.6/4.7 with ACCESS_ONCE and workarounds
References: <1415360716-9670-2-git-send-email-borntraeger@de.ibm.com> <54611D86.4040306@de.ibm.com> <CA+55aFyEigSL64RJH8AO86gFBBB84+dgk7eEUPx=CaLwJMcO_w@mail.gmail.com>
In-Reply-To: <CA+55aFyEigSL64RJH8AO86gFBBB84+dgk7eEUPx=CaLwJMcO_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112011-0025-0000-0000-0000027EA435
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.11.2014 um 22:07 schrieb Linus Torvalds:
[...]
> So before blacklisting any compilers, let's first see if
> 
>  (a) we can actually make it a real rule that we only use ACCESS_ONCE on scalars
>  (b) we can somehow enforce this with a compiler warning/error for mis-uses
> 
> For example, the attached patch works for some cases, but shows how we
> use ACCESS_ONCE() on pointers to pte_t's etc, so it doesn't come even
> close to compiling the whole kernel. But I wonder how painful that
> would be to change.. The places where it complains are actually
> somewhat debatable to begin with, like:
> 
>  - handle_pte_fault(.. pte_t *pte ..):
> 
>         entry = ACCESS_ONCE(*pte);
> 
> and the thing is, "pte" is actually possibly an 8-byte entity on
> x86-32, and that ACCESS_ONCE() fundamentally will be two 32-byte
> reads.
> 
> So there is a very valid argument for saying "well, you shouldn't do
> that, then", and that we might be better off cleaning up our
> ACCESS_ONCE() uses, than to just blindly blacklist compilers.
> 
> NOTE! I'm not at all advocating the attached patch. I'm sending it out
> white-space damaged on purpose, it's more of a "hey, something like
> this might be the direction we want to go in", with the spinlock.h
> part of the patch also acting as an example of the kind of changes the
> "ACCESS_ONCE() only works on scalars" rule would require.

So I tried to see if I can come up with some results on how often this problem happens...

[...]


> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index d5ad7b1118fc..63e82f1dfc1a 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -378,7 +378,11 @@ void ftrace_likely_update(struct
> ftrace_branch_data *f, int val, int expect);
>   * use is to mediate communication between process-level code and irq/NMI
>   * handlers, all running on the same CPU.
>   */
> -#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
> +#define get_scalar_volatile_pointer(x) ({ \
> +       typeof(x) *__p = &(x); \
> +       volatile typeof(x) *__vp = __p; \
> +       (void)(long)*__p; __vp; })
> +#define ACCESS_ONCE(x) (*get_scalar_volatile_pointer(x))

..and just took this patch. On s390 is pretty much clean with allyesconfig
In fact with the siif lock changed only the pte/pmd cases you mentioned trigger a compile error:

mm/memory.c: In function 'handle_pte_fault':
mm/memory.c:3203:2: error: aggregate value used where an integer was expected
  entry = ACCESS_ONCE(*pte);

mm/rmap.c: In function 'mm_find_pmd':
mm/rmap.c:584:2: error: aggregate value used where an integer was expected
  pmde = ACCESS_ONCE(*pmd);


Here a barrier() might be a good solution as well, I guess.
On x86 allyesconfig its almost the same.
- we need your spinlock changes (well, something different to make it compile)
- we need to fix pmd and pte
- we have gup_get_pte in arch/x86/mm/gup.c getting a ptep

So It looks like we could make a change to ACCESS_ONCE. Would something like

CONFIG_ARCH_SCALAR_ACCESS_ONCE be a good start?

This would boil down to
Patch1: Provide stricter ACCESS_ONCE if CONFIG_ARCH_SCALAR_ACCESS_ONCE is set + docu update + comments
Patch2: Change mm/* to barriers
Patch3: Change x86 locks
Patch4: Change x86 gup
Patch4: Enable CONFIG_ARCH_SCALAR_ACCESS_ONCE for s390x and x86

Makes sense?

Christian

