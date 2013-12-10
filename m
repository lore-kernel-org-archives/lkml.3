Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab3LJUQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:16:20 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:35516 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3LJUQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:16:19 -0500
MIME-Version: 1.0
In-Reply-To: <20131210200426.GA31862@redhat.com>
References: <20131209211824.GA15006@redhat.com>
	<CA+55aFxkW2cFB3us0_A+Nq04UYOq4H_ta5rNYyuYyZd=YOuk2w@mail.gmail.com>
	<20131210191837.GA30680@redhat.com>
	<CA+55aFxng2sriDQzt4w_=+ihUWms6jToXzDPymDRuowN8hCFKw@mail.gmail.com>
	<20131210200426.GA31862@redhat.com>
Date: Tue, 10 Dec 2013 12:16:18 -0800
X-Google-Sender-Auth: EN3Bc-lnxR88dC4Wx19oPI20zXQ
Message-ID: <CA+55aFyWtF762kRv4FyYS7E9sKtuFiEJZ87JudN55xHaBvwAQg@mail.gmail.com>
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

On Tue, Dec 10, 2013 at 12:04 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> We'd be *much* better off using get_user_pages_fast() if possible -
>> and I bet _is_ possible in 99% of all cases.
>
> We can't. get_user_pages_fast() takes mmap_sem.

Yeah, and we need to look up the page table entry anyway, so what we
actually want here is just the page table walker, none of the "get
page" crap at all.

So the core function should (I think) just do something like:

 - new_page = NULL
 - get page table lock
 - look up page tables
 - if it's dirty and private, or we have a new page for it, replace
the instruction
 - drop page table lock
 - we're done, free the new page if we didn't use it.

with a retry for the "uhhuh, it's not dirty and private, and we don't
have a new page", so we do
 - drop the lock
 - use a "get_user()" or something to page it in.
 - allocate a new page if necessary
 - goto retry

which gets us a single page table walk for the common case, and a
retry for the "uhhuh, we needed to page it in or allocate a new page"
condition.

Put another way: I actually think the existing "__replace_page()" code
is closer to being good than that disgusting uprobe_write_opcode()
function. I think you may be getting rid of the wrong ugly function.

                Linus
