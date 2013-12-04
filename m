Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab3LDCyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:54:43 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:62294 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab3LDCym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:54:42 -0500
MIME-Version: 1.0
In-Reply-To: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
Date: Wed, 4 Dec 2013 08:24:40 +0530
Message-ID: <CA+b37P3R7r6DoJCX7GQD+BREGsb+s2WBc71c03TVFCPi6=-mkw@mail.gmail.com>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and
 fixes crash bugs
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 December 2013 06:58, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> Hi,
> Here is the version 4 of NOKPORBE_SYMBOL series.
>
> In this version, I removed the cleanup patches and
> add bugfixes I've found, since those bugs will be
> critical.
> Rest of the cleanup and visible blacklists will be
> proposed later in another series.
>
> Oh, just one new thing, I added a new RFC patch which
> removes the dependency of notify_die() from kprobes
> miss-hit/recovery path. Since the notify_die() involves
> locking and lockdep code which invokes a lot of heavy
> printk functions etc. This helped me to minimize the
> blacklist and provides more stability for kprobes.
> Actually, most of int3 handlers are already called
> from do_int3 directly, I think this change is acceptable
> too.
>
> Here is the updates about NOKPROBE_SYMBOL().
>  - Now _ASM_NOKPROBE() macro is introduced for assembly
>    symbols on x86.
>  - Rename kprobe_blackpoint to kprobe_blacklist_entry
>    and simplify it. Also NOKPROBE_SYMBOL() macro just
>    saves the address of non-probe-able symbols.
>
> ---
>
> Masami Hiramatsu (6):

>       kprobes: Prohibit probing on .entry.text code
>       kprobes: Introduce NOKPROBE_SYMBOL() macro for blacklist
Hi Masami,
Is it good idea to split  "arch/x86" code from generic kernel changes?
Then we just need to take above two patches for verifying it on arm64
or other platforms.

Thanks,
Sandeepa
>       [BUGFIX] kprobes/x86: Prohibit probing on debug_stack_*
>       [BUGFIX] x86: Prohibit probing on native_set_debugreg
>       [BUGFIX] x86: Prohibit probing on thunk functions and restore
>       [RFC] kprobes/x86: Call exception handlers directly from do_int3/do_debug
>
>
>  Documentation/kprobes.txt         |   16 +++++
>  arch/x86/include/asm/asm.h        |    7 ++
>  arch/x86/include/asm/kprobes.h    |    2 +
>  arch/x86/kernel/cpu/common.c      |    4 +
>  arch/x86/kernel/entry_32.S        |   33 -----------
>  arch/x86/kernel/entry_64.S        |   20 -------
>  arch/x86/kernel/kprobes/core.c    |   32 ++++------
>  arch/x86/kernel/paravirt.c        |    5 ++
>  arch/x86/kernel/traps.c           |   10 +++
>  arch/x86/lib/thunk_32.S           |    3 +
>  arch/x86/lib/thunk_64.S           |    3 +
>  include/asm-generic/vmlinux.lds.h |    9 +++
>  include/linux/kprobes.h           |   21 ++++++-
>  kernel/kprobes.c                  |  113 ++++++++++++++++++++-----------------
>  kernel/sched/core.c               |    1
>  15 files changed, 147 insertions(+), 132 deletions(-)
>
> --
> Masami HIRAMATSU
> IT Management Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
>
