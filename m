Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab3LJUEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:04:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab3LJUEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:04:31 -0500
Date: Tue, 10 Dec 2013 21:04:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@alien8.de>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/1] uprobes: Kill __replace_page(), change
	uprobe_write_opcode() to rely on gup(WRITE)
Message-ID: <20131210200426.GA31862@redhat.com>
References: <20131209211824.GA15006@redhat.com> <CA+55aFxkW2cFB3us0_A+Nq04UYOq4H_ta5rNYyuYyZd=YOuk2w@mail.gmail.com> <20131210191837.GA30680@redhat.com> <CA+55aFxng2sriDQzt4w_=+ihUWms6jToXzDPymDRuowN8hCFKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxng2sriDQzt4w_=+ihUWms6jToXzDPymDRuowN8hCFKw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10, Linus Torvalds wrote:
>
> On Tue, Dec 10, 2013 at 11:18 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Well, if we use get_user_pages() we have vma for free.
>
> No we don't. get_user_pages() is expensive as hell.

I understand, I said "if we use get_user_pages()".

> We'd be *much* better off using get_user_pages_fast() if possible -
> and I bet _is_ possible in 99% of all cases.

We can't. get_user_pages_fast() takes mmap_sem.

Perhaps we can do something, say add FOLL_FAST_ONLY, but until then
we need the 1st get_user_pages(write => 0) anyway.

> > But I am not sure about "and verify it for now" above. Do you mean
> > that uprobe_write_opcode() should do another valid_vma() ?
>
> No. I think we should just do something like
>
>     if (vma->vm_flags & (VM_SHARED | VM_HUGETLB))
>         return -EINVAL;

OK, but WARN_ON(VM_SHARED | VM_HUGETLB) looks better imho. Because
this should not happen.

> then just looking up the page table _once_ - instead of
> three times - would make the code safer and faster.

Unlikely we can do this only once... At least I do not see how.

> It *may* be safe if callers do
> all the right black magic, but it's by no means obvious.

I agree, this needs more documentation in any case.

Oleg.

