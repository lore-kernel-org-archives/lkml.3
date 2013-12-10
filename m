Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3LJTSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:18:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab3LJTSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:18:36 -0500
Date: Tue, 10 Dec 2013 20:18:37 +0100
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
Message-ID: <20131210191837.GA30680@redhat.com>
References: <20131209211824.GA15006@redhat.com> <CA+55aFxkW2cFB3us0_A+Nq04UYOq4H_ta5rNYyuYyZd=YOuk2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxkW2cFB3us0_A+Nq04UYOq4H_ta5rNYyuYyZd=YOuk2w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09, Linus Torvalds wrote:
>
> On Mon, Dec 9, 2013 at 1:18 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > It is not clear to me if Linus still dislikes this change or not.
> > Let me send the patch "officially" so that it can be nacked if I
> > misunderstood the result of discussion.
>
> So quite frankly, if the caller guarantees that it has looked up the
> vma, and verified it, then I'm ok with it.
>
> But in that case, I think you should pass in the vma as an argument,
> and verify it for now.  Because quite frankly, the reason I reacted to
> this all is that it is NOT AT ALL obvious that the callers actually do
> that.
>
> That uprobe_write_opcode() also only works if the instruction is
> within a single page, another thing that it doesn't actually check.
> And again, it is not at all obvious by looking at the callers that
> that check has ever been done. The interface looks like you can just
> rewrite an arbitrary byte range using that function.

OK. I'll update the comment above uprobe_write_opcode() to make this
all clear. It is wrong anyway, ->mmap_sem is held for writing.

> In fact, callers can clearly call that
> thing without ever even looking up the vma (which it must to do check
> that it's not shared), and we look it up *again* by using that slow
> nasty get_user_pages() thing.

Well, if we use get_user_pages() we have vma for free. And this is the
same vma which was verified by the caller who must check valid_vma(),
the caller doesn't drop mmap_sem.

I agree, this should be documented. And yes, we can pass vma instead
of mm, but this needs a separate change. We need to change the signature
of set_swbp() and set_orig_insn(). And the current code also relies on
get_user_pages(&vma) in this sense.

But I am not sure about "and verify it for now" above. Do you mean
that uprobe_write_opcode() should do another valid_vma() ? I don't
think this will look good, unless we put this check into WARN_ON().
Or just verify that the argument matches the vma found by gup() ?

And perhaps we can do this later? This change will conflict with
the pending arm patches (arm reimplements set_swbp() because it
uses another insn != UPROBE_SWBP_INSN depending on original insn).
This doesn't look like a serious problem to me.

> Also, quite frankly, I think the routine is still just horrible.

I agree. I do think it becomes better (if the patch is correct),
just because we do not play with vm internals, at least that much.

> If I
> read it right, even after that cleanup you do a page table walk
> *THREE* times:
>
>  - 2x get_user_pages()

Yes. The 1st get_user_pages() + verify_opcode() is only needed to
avoid the unnecessary write (and cow). Without this check, say,
uprobe_unregister() can create the anonymous cow'ed page even if
this task was not probed.

This makes sense, but perhaps we can optimize this somehow, not sure.
But this was not added by the patch.

>  - page_check_address()

Yes. The patch adds another page table walk, this is unfortunate.

> and that's without the whole "retry" thing. It all seems pretty damn
> pointless. Wouldn't it be better to do it *once*, and then the retry
> logic is for "oops, we need to cow the page we looked up, so we need
> to drop the page table lock and allocate a new page".

Hmm, OK. I guess we can rely on the same PageAnon() + page_mapcount()
check, just we should not WARN() the first time. Plus we should probably
also check page_swapcount(). But I need to recheck.

Thanks. I'll try to make v2.

Oleg.

