Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbaKYMmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:42:43 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49100 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbaKYMmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:42:17 -0500
MIME-Version: 1.0
In-Reply-To: <1416852146-9781-3-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com> <1416852146-9781-3-git-send-email-a.ryabinin@samsung.com>
From: Dmitry Chernenkov <dmitryc@google.com>
Date: Tue, 25 Nov 2014 16:41:56 +0400
Message-ID: <CAA6XgkEzNYgRrUpDGwLeAMrjOotw9qPZbHdXkPX7E9xJ-v97-Q@mail.gmail.com>
Subject: Re: [PATCH v7 02/12] x86_64: load_percpu_segment: read
 irq_stack_union.gs_base before load_segment
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LGTM

On Mon, Nov 24, 2014 at 9:02 PM, Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
> Reading irq_stack_union.gs_base after load_segment creates troubles for kasan.
> Compiler inserts __asan_load in between load_segment and wrmsrl. If kernel
> built with stackprotector this will result in boot failure because __asan_load
> has stackprotector.
>
> To avoid this irq_stack_union.gs_base stored to temporary variable before
> load_segment, so __asan_load will be called before load_segment().
>
> There are two alternative ways to fix this:
>  a) Add __attribute__((no_sanitize_address)) to load_percpu_segment(),
>     which tells compiler to not instrument this function. However this
>     will result in build failure with CONFIG_KASAN=y and CONFIG_OPTIMIZE_INLINING=y.
>
>  b) Add -fno-stack-protector for mm/kasan/kasan.c
>
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>  arch/x86/kernel/cpu/common.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 8779d63..97f56f6 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -389,8 +389,10 @@ void load_percpu_segment(int cpu)
>  #ifdef CONFIG_X86_32
>         loadsegment(fs, __KERNEL_PERCPU);
>  #else
> +       void *gs_base = per_cpu(irq_stack_union.gs_base, cpu);
> +
>         loadsegment(gs, 0);
> -       wrmsrl(MSR_GS_BASE, (unsigned long)per_cpu(irq_stack_union.gs_base, cpu));
> +       wrmsrl(MSR_GS_BASE, (unsigned long)gs_base);
>  #endif
>         load_stack_canary_segment();
>  }
> --
> 2.1.3
>
