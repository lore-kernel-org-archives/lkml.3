Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab3LJCIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:08:46 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:63408 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab3LJCIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:08:44 -0500
MIME-Version: 1.0
In-Reply-To: <20131209211824.GA15006@redhat.com>
References: <20131209211824.GA15006@redhat.com>
Date: Mon, 9 Dec 2013 18:08:43 -0800
X-Google-Sender-Auth: ZutTRREhiTYSkvCphIrL4UGQ43o
Message-ID: <CA+55aFxkW2cFB3us0_A+Nq04UYOq4H_ta5rNYyuYyZd=YOuk2w@mail.gmail.com>
Subject: Re: [PATCH 0/1] uprobes: Kill __replace_page(), change
 uprobe_write_opcode() to rely on gup(WRITE)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@alien8.de>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 1:18 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> It is not clear to me if Linus still dislikes this change or not.
> Let me send the patch "officially" so that it can be nacked if I
> misunderstood the result of discussion.

So quite frankly, if the caller guarantees that it has looked up the
vma, and verified it, then I'm ok with it.

But in that case, I think you should pass in the vma as an argument,
and verify it for now.  Because quite frankly, the reason I reacted to
this all is that it is NOT AT ALL obvious that the callers actually do
that.

That uprobe_write_opcode() also only works if the instruction is
within a single page, another thing that it doesn't actually check.
And again, it is not at all obvious by looking at the callers that
that check has ever been done. The interface looks like you can just
rewrite an arbitrary byte range using that function.

In other words: looking at that function, my immediate reaction is
still "it's buggy". Why? Because it seems to make assumptions about
the callers that are never checked and are not at all obvious that
they have ever *been* checked. In fact, callers can clearly call that
thing without ever even looking up the vma (which it must to do check
that it's not shared), and we look it up *again* by using that slow
nasty get_user_pages() thing.

Also, quite frankly, I think the routine is still just horrible. If I
read it right, even after that cleanup you do a page table walk
*THREE* times:

 - 2x get_user_pages()
 - page_check_address()

and that's without the whole "retry" thing. It all seems pretty damn
pointless. Wouldn't it be better to do it *once*, and then the retry
logic is for "oops, we need to cow the page we looked up, so we need
to drop the page table lock and allocate a new page".

So I'd actually prefer this to (a) pass in the vma (to make it obvious
that the caller must look it up!) (b) add a few sanity checks (not
page-crossing) and I think possibly (c) make it a bit smarter still.

              Linus
