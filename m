Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155Ab3LJTiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:38:04 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:34028 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3LJTiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:38:01 -0500
MIME-Version: 1.0
In-Reply-To: <20131210191837.GA30680@redhat.com>
References: <20131209211824.GA15006@redhat.com>
	<CA+55aFxkW2cFB3us0_A+Nq04UYOq4H_ta5rNYyuYyZd=YOuk2w@mail.gmail.com>
	<20131210191837.GA30680@redhat.com>
Date: Tue, 10 Dec 2013 11:38:00 -0800
X-Google-Sender-Auth: A_ACubfPHnCfOxtHGmWXug7_nms
Message-ID: <CA+55aFxng2sriDQzt4w_=+ihUWms6jToXzDPymDRuowN8hCFKw@mail.gmail.com>
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

On Tue, Dec 10, 2013 at 11:18 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Well, if we use get_user_pages() we have vma for free.

No we don't. get_user_pages() is expensive as hell.

We'd be *much* better off using get_user_pages_fast() if possible -
and I bet _is_ possible in 99% of all cases.

So saying that we get vma "for free" is complete BS. We get it "for
very expensive."

> But I am not sure about "and verify it for now" above. Do you mean
> that uprobe_write_opcode() should do another valid_vma() ?

No. I think we should just do something like

    if (vma->vm_flags & (VM_SHARED | VM_HUGETLB))
        return -EINVAL;

and actually make the logic obvious. We should *also* make sure we do
the right thing for THP, because the VM_HUGETLB check isn't obviously
sufficient. Does the code really do the right thing for a writable
hugepage? I'd like that to be *obvious*.

Quite frankly, I think that adding a few of these kinds of *obvious*
checks and then just looking up the page table _once_ - instead of
three times - would make the code safer and faster.

As it is, it is neither safe nor fast. It *may* be safe if callers do
all the right black magic, but it's by no means obvious.

                   Linus
