Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3KKLQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:16:29 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:33700 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab3KKLQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:16:22 -0500
Date: Mon, 11 Nov 2013 12:16:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: x86@kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip RFC 0/2] kprobes: introduce NOKPROBE_SYMBOL() and
 prohibit probing on .entry.text
Message-ID: <20131111111618.GA15810@gmail.com>
References: <20131108125213.19972.49271.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108125213.19972.49271.stgit@kbuild-fedora.novalocal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Currently the blacklist is maintained by hand in kprobes.c 
> which is separated from the function definition and is hard
> to catch up the kernel update.
> To solve this issue, I've tried to implement new
> NOKPROBE_SYMBOL() macro for making kprobe blacklist at 
> build time. Since the NOKPROBE_SYMBOL() macros can be placed
> right after the function is defined, it is easy to maintain.
> At this moment, I applied the macro only for the symbols
> which is listed in kprobes.c. As we discussed in previous
> thread, if the gcc accepts to introduce new annotation to
> store the function address (and size) at somewhere, we can
> easily move onto that by replacing NOKPROBE_SYMBOL() with
> nokprobe annotation (and just modifying the
> populate_kprobe_blacklist() a bit).
> 
> This series also includes a change which prohibits probing
> on the address in .entry.text because the code is used for
> very low-level sensitive interrupt/syscall entries. Probing
> such code may cause unexpected result (actually most of
> that area is already in the kprobe blacklist).
> So I've decide to prohibit probing all of them.
> 
> Since Ingo wasn't convinced about the idea in the previous
> discussion, I just make this series as RFC series.
> I'd like to ask again with actual implementation and plan.
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (2):
>       kprobes: Prohibit probing on .entry.text code
>       kprobes: Introduce NOKPROBE_SYMBOL() macro for blacklist
> 
> 
>  arch/x86/kernel/entry_32.S        |   33 ------------
>  arch/x86/kernel/entry_64.S        |   20 --------
>  arch/x86/kernel/paravirt.c        |    4 ++
>  include/asm-generic/vmlinux.lds.h |    9 +++
>  include/linux/kprobes.h           |   19 +++++++
>  kernel/kprobes.c                  |   98 ++++++++++++++++++-------------------
>  kernel/sched/core.c               |    1 
>  7 files changed, 80 insertions(+), 104 deletions(-)

Ok, I like it after all.

Mind changing over arch/x86/kprobes/* to use this new facility? There's no 
sense in kprobes internals using two types

After that we can convert all the rest, probably as part of this series.

There's a good reason now to do it: it's not just about cleanliness, it 
will also impact generated code less.

Thanks,

	Ingo
