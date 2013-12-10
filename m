Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab3LJVYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:24:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab3LJVYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:24:12 -0500
Date: Tue, 10 Dec 2013 22:24:09 +0100
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
Message-ID: <20131210212409.GA3179@redhat.com>
References: <20131209211824.GA15006@redhat.com> <CA+55aFxkW2cFB3us0_A+Nq04UYOq4H_ta5rNYyuYyZd=YOuk2w@mail.gmail.com> <20131210191837.GA30680@redhat.com> <CA+55aFxng2sriDQzt4w_=+ihUWms6jToXzDPymDRuowN8hCFKw@mail.gmail.com> <20131210200426.GA31862@redhat.com> <CA+55aFyWtF762kRv4FyYS7E9sKtuFiEJZ87JudN55xHaBvwAQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyWtF762kRv4FyYS7E9sKtuFiEJZ87JudN55xHaBvwAQg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10, Linus Torvalds wrote:
>
> On Tue, Dec 10, 2013 at 12:04 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> We'd be *much* better off using get_user_pages_fast() if possible -
> >> and I bet _is_ possible in 99% of all cases.
> >
> > We can't. get_user_pages_fast() takes mmap_sem.
>
> Yeah, and we need to look up the page table entry anyway, so what we
> actually want here is just the page table walker,

Yes, this is clear.

And damn, somehow I forgot that _fast() can (obviously) only use
current->mm.

> none of the "get
> page" crap at all.
>
> So the core function should (I think) just do something like:

I'll try to think, but this is what I actually tried to avoid.

I mean,

> Put another way: I actually think the existing "__replace_page()" code
> is closer to being good than that disgusting uprobe_write_opcode()
> function. I think you may be getting rid of the wrong ugly function.

And perhaps you are right.

But my only motivation was: rely on gup() to simplify this code. Yes,
gup() is slow, but it works and we can avoid the "nontrivial" things
like page_remove_rmap/munlock_vma_page.

If we want to optimize this code, then this patch obviously goes to
the wrong direction, I agree.

Oleg.

