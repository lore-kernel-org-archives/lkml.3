Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbaIZRSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:18:35 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:54568 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbaIZRSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:18:33 -0400
MIME-Version: 1.0
In-Reply-To: <1411562649-28231-14-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com> <1411562649-28231-14-git-send-email-a.ryabinin@samsung.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 26 Sep 2014 10:18:12 -0700
Message-ID: <CACT4Y+bTXPzYH+TMjM9-NyVajZms8zKdEMMLDPvOKvRSoD8tog@mail.gmail.com>
Subject: Re: [RFC PATCH v3 13/13] kasan: introduce inline instrumentation
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 5:44 AM, Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
> This patch only demonstration how easy this could be achieved.
> GCC doesn't support this feature yet. Two patches required for this:
>     https://gcc.gnu.org/ml/gcc-patches/2014-09/msg00452.html
>     https://gcc.gnu.org/ml/gcc-patches/2014-09/msg00605.html
>
> In inline instrumentation mode compiler directly inserts code
> checking shadow memory instead of __asan_load/__asan_store
> calls.
> This is usually faster than outline. In some workloads inline is
> 2 times faster than outline instrumentation.
>
> The downside of inline instrumentation is bloated kernel's .text size:
>
> size noasan/vmlinux
>    text     data     bss      dec     hex    filename
> 11759720  1566560  946176  14272456  d9c7c8  noasan/vmlinux
>
> size outline/vmlinux
>    text    data     bss      dec      hex    filename
> 16553474  1602592  950272  19106338  1238a22 outline/vmlinux
>
> size inline/vmlinux
>    text    data     bss      dec      hex    filename
> 32064759  1598688  946176  34609623  21019d7 inline/vmlinux
>
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>  Makefile          |  5 +++++
>  lib/Kconfig.kasan | 24 ++++++++++++++++++++++++
>  mm/kasan/report.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 74 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index 6cefe5e..fe7c534 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -773,6 +773,11 @@ KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
>  endif
>
>  ifdef CONFIG_KASAN
> +ifdef CONFIG_KASAN_INLINE
> +CFLAGS_KASAN += $(call cc-option, -fasan-shadow-offset=$(CONFIG_KASAN_SHADOW_OFFSET)) \
> +                $(call cc-option, --param asan-instrumentation-with-call-threshold=10000)
> +endif
> +
>    ifeq ($(CFLAGS_KASAN),)
>      $(warning Cannot use CONFIG_KASAN: \
>               -fsanitize=kernel-address not supported by compiler)
> diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
> index faddb0e..c4ac040 100644
> --- a/lib/Kconfig.kasan
> +++ b/lib/Kconfig.kasan
> @@ -27,4 +27,28 @@ config TEST_KASAN
>           out of bounds accesses, use after free. It is usefull for testing
>           kernel debugging features like kernel address sanitizer.
>
> +choice
> +       prompt "Instrumentation type"
> +       depends on KASAN
> +       default KASAN_INLINE if X86_64
> +
> +config KASAN_OUTLINE
> +       bool "Outline instrumentation"
> +       help
> +         Before every memory access compiler insert function call
> +         __asan_load*/__asan_store*. These functions performs check
> +         of shadow memory. This is slower than inline instrumentation,
> +         however it doesn't bloat size of kernel's .text section so
> +         much as inline does.
> +
> +config KASAN_INLINE
> +       bool "Inline instrumentation"
> +       help
> +         Compiler directly inserts code checking shadow memory before
> +         memory accesses. This is faster than outline (in some workloads
> +         it gives about x2 boost over outline instrumentation), but
> +         make kernel's .text size much bigger.
> +
> +endchoice
> +
>  endif
> diff --git a/mm/kasan/report.c b/mm/kasan/report.c
> index c42f6ba..a9262f8 100644
> --- a/mm/kasan/report.c
> +++ b/mm/kasan/report.c
> @@ -212,3 +212,48 @@ void kasan_report_user_access(struct access_info *info)
>                 "=================================\n");
>         spin_unlock_irqrestore(&report_lock, flags);
>  }
> +
> +#define CALL_KASAN_REPORT(__addr, __size, __is_write) \
> +       struct access_info info;                      \
> +       info.access_addr = __addr;                    \
> +       info.access_size = __size;                    \
> +       info.is_write = __is_write;                   \
> +       info.ip = _RET_IP_;                           \
> +       kasan_report_error(&info)
> +
> +#define DEFINE_ASAN_REPORT_LOAD(size)                     \
> +void __asan_report_recover_load##size(unsigned long addr) \
> +{                                                         \
> +       CALL_KASAN_REPORT(addr, size, false);             \
> +}                                                         \
> +EXPORT_SYMBOL(__asan_report_recover_load##size)
> +
> +#define DEFINE_ASAN_REPORT_STORE(size)                     \
> +void __asan_report_recover_store##size(unsigned long addr) \
> +{                                                          \
> +       CALL_KASAN_REPORT(addr, size, true);               \
> +}                                                          \
> +EXPORT_SYMBOL(__asan_report_recover_store##size)
> +
> +DEFINE_ASAN_REPORT_LOAD(1);
> +DEFINE_ASAN_REPORT_LOAD(2);
> +DEFINE_ASAN_REPORT_LOAD(4);
> +DEFINE_ASAN_REPORT_LOAD(8);
> +DEFINE_ASAN_REPORT_LOAD(16);
> +DEFINE_ASAN_REPORT_STORE(1);
> +DEFINE_ASAN_REPORT_STORE(2);
> +DEFINE_ASAN_REPORT_STORE(4);
> +DEFINE_ASAN_REPORT_STORE(8);
> +DEFINE_ASAN_REPORT_STORE(16);
> +
> +void __asan_report_recover_load_n(unsigned long addr, size_t size)
> +{
> +       CALL_KASAN_REPORT(addr, size, false);
> +}
> +EXPORT_SYMBOL(__asan_report_recover_load_n);
> +
> +void __asan_report_recover_store_n(unsigned long addr, size_t size)
> +{
> +       CALL_KASAN_REPORT(addr, size, true);
> +}
> +EXPORT_SYMBOL(__asan_report_recover_store_n);
> --
> 2.1.1
>



Yikes!
So this works during bootstrap, for user memory accesses, valloc
memory, etc, right?
