Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab3HERwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:52:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab3HERwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:52:37 -0400
Date: Mon, 5 Aug 2013 19:47:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11-rc4
Message-ID: <20130805174712.GA8461@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com> <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com> <20130805132948.GA14942@redhat.com> <CA+55aFy61PbNZda8f+42T9e7TioWd+W1s70UA6h+xnARjX3usA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy61PbNZda8f+42T9e7TioWd+W1s70UA6h+xnARjX3usA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05, Linus Torvalds wrote:
>
> On Mon, Aug 5, 2013 at 6:29 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > I never used wine, but I am puzzled anyway. This patch really looks
> > like a simple and minor bugfix.
>
> The patch is indeed trivial, but.. What's the locking here?
>
> Afaik, ptrace_detach() by the parent can race with do_exit() by the
> child, and they now _both_ do flush_ptrace_hw_breakpoint().

That would be bad. And that is why exit_ptrace() doesn't do this.

But we rely on ptrace_freeze_traced(). If the child can exit (or
even run), we have other problems which were hopefully fixed by
9899d11f "ensure arch_ptrace/ptrace_request can never race with
SIGKILL"

> We have that whole "get tasklist_lock for writing and then
> check child->ptrace" logic there exactly due to that race, no?

Exactly. But note that this code is very old. We can remove the
"This child can be already killed" logic, and we can do more
simplifications in ptrace paths.

In fact, some recent changes already rely on the fact the tracee
can't go away, say ptrace_peek_siginfo()->spin_lock_irq(siglock)
is not safe without ptrace_freeze_traced().

Oleg.

