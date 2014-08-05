Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaHENEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:04:42 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:51615 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaHENEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:04:40 -0400
MIME-Version: 1.0
In-Reply-To: <1404079773.2619.4.camel@buesod1.americas.hpqcorp.net>
References: <1403288473.10903.2.camel@buesod1.americas.hpqcorp.net>
	<20140623065835.GF19860@laptop.programming.kicks-ass.net>
	<1403622415.15523.4.camel@buesod1.americas.hpqcorp.net>
	<20140625062510.GB4260@osiris>
	<CA+55aFx3UQG42cYrUWrTDT9CnpnRwVta6C9N_0FH1wvyDMxPgw@mail.gmail.com>
	<1404079773.2619.4.camel@buesod1.americas.hpqcorp.net>
Date: Tue, 5 Aug 2014 15:04:38 +0200
X-Google-Sender-Auth: -120F7BprIHW_ix0z1W8fET73f8
Message-ID: <CAMuHMdX2ZCEd=J_Gpf-W+Zyqg27r4C6ULZgO=pg2houR-FXLvg@mail.gmail.com>
Subject: Re: [PATCH v2] arch,locking: Ciao arch_mutex_cpu_relax()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, Jun 30, 2014 at 12:09 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> From: Davidlohr Bueso <davidlohr@hp.com>
>
> The arch_mutex_cpu_relax() function, introduced by 34b133f, is
> hacky and ugly. It was added a few years ago to address the fact
> that common cpu_relax() calls include yielding on s390, and thus
> impact the optimistic spinning functionality of mutexes. Nowadays
> we use this function well beyond mutexes: rwsem, qrwlock, mcs and
> lockref. Since the macro that defines the call is in the mutex header,
> any users must include mutex.h and the naming is misleading as well.
>
> This patch (i) renames the call to cpu_relax_lowlatency  ("relax, but
> only if you can do it with very low latency") and (ii) defines it in
> each arch's asm/processor.h local header, just like for regular cpu_relax
> functions. On all archs, except s390, cpu_relax_lowlatency is simply cpu_relax,
> and thus we can take it out of mutex.h. While this can seem redundant,
> I believe it is a good choice as it allows us to move out arch specific
> logic from generic locking primitives and enables future(?) archs to
> transparently define it, similarly to System Z.
>
> Please note that these changes are only tested on x86-64.
>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
> Changes from v1: Rename arch_cpu_relax to cpu_relax_lowlatency,
> based on the purpose of the function, as suggested by Linus.
>
>  arch/alpha/include/asm/processor.h     | 1 +
>  arch/arc/include/asm/processor.h       | 2 ++
>  arch/arm/include/asm/processor.h       | 2 ++
>  arch/arm64/include/asm/processor.h     | 1 +
>  arch/avr32/include/asm/processor.h     | 1 +
>  arch/blackfin/include/asm/processor.h  | 2 +-
>  arch/c6x/include/asm/processor.h       | 1 +
>  arch/cris/include/asm/processor.h      | 1 +
>  arch/hexagon/include/asm/processor.h   | 1 +
>  arch/ia64/include/asm/processor.h      | 1 +
>  arch/m32r/include/asm/processor.h      | 1 +
>  arch/m68k/include/asm/processor.h      | 1 +
>  arch/metag/include/asm/processor.h     | 1 +
>  arch/mips/include/asm/processor.h      | 1 +
>  arch/mn10300/include/asm/processor.h   | 2 ++
>  arch/openrisc/include/asm/processor.h  | 1 +
>  arch/parisc/include/asm/processor.h    | 1 +
>  arch/powerpc/include/asm/processor.h   | 2 ++
>  arch/s390/include/asm/processor.h      | 2 +-
>  arch/score/include/asm/processor.h     | 1 +
>  arch/sh/include/asm/processor.h        | 1 +
>  arch/sparc/include/asm/processor_32.h  | 2 ++
>  arch/sparc/include/asm/processor_64.h  | 1 +
>  arch/tile/include/asm/processor.h      | 2 ++
>  arch/unicore32/include/asm/processor.h | 1 +
>  arch/x86/include/asm/processor.h       | 2 ++
>  arch/xtensa/include/asm/processor.h    | 1 +
>  include/linux/mutex.h                  | 4 ----
>  kernel/locking/mcs_spinlock.c          | 8 +++-----
>  kernel/locking/mcs_spinlock.h          | 4 ++--
>  kernel/locking/mutex.c                 | 4 ++--
>  kernel/locking/qrwlock.c               | 9 ++++-----
>  kernel/locking/rwsem-xadd.c            | 4 ++--
>  lib/lockref.c                          | 3 +--
>  34 files changed, 48 insertions(+), 24 deletions(-)

It looks like you forgot to update frv?  It's been failing on -next since a
few days:

kernel/locking/mcs_spinlock.h:87:2: error: implicit declaration of
function 'cpu_relax_lowlatency'
[-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
kernel/locking/mcs_spinlock.h:87:2: error: implicit declaration of
function 'cpu_relax_lowlatency'
[-Werror=implicit-function-declaration]
make[3]: *** [kernel/locking/mcs_spinlock.o] Error 1
cc1: some warnings being treated as errors
make[3]: *** [kernel/locking/mutex.o] Error 1

http://kisskb.ellerman.id.au/kisskb/buildresult/11616307/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
