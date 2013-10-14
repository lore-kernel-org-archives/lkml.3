Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab3JNSyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:54:24 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:64190 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3JNSyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:54:22 -0400
MIME-Version: 1.0
In-Reply-To: <1381751200-27376-1-git-send-email-chaowang@redhat.com>
References: <1381751200-27376-1-git-send-email-chaowang@redhat.com>
Date: Mon, 14 Oct 2013 11:54:22 -0700
X-Google-Sender-Auth: 0FaN0PzeNZ6tRDTI57hACaViqPs
Message-ID: <CAE9FiQUNMDuVZtqud3LBbAmE0SL8ZWLFnc+CSYZm4UfTvNUaOA@mail.gmail.com>
Subject: Re: [PATCH] x86, kdump: crashkernel=X try to reserve below 896M
 first, then try below 4G, then MAXMEM
From: Yinghai Lu <yinghai@kernel.org>
To: WANG Chao <chaowang@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 4:46 AM, WANG Chao <chaowang@redhat.com> wrote:
> Now crashkernel=X will fail out if there's not enough memory at
> low (below 896M). What makes sense for crashkernel=X would be:
>
>  - First try to reserve X below 896M (for being compatible with old
>    kexec-tools).
>  - If fails, try to reserve X below 4G (swiotlb need to stay below 4G).
>  - If fails, try to reserve X from MAXMEM top down.
>
> So that user can easily reserve large memory with crashkernel=X instead
> of crashkernel=X,high. It's more transparent and user-friendly.
>
> If crashkernel is large and the reserved is beyond 896M, old kexec-tools
> won't be compatible with new kernel for most of time.
>
> kexec will fail out immediately in this case. But the failure could be
> expected, because old kexec users should not try to reserve that large
> amount of memory at the first place.
>
> On the other hand, old kexec also will fail on old kernel when there's
> not enough low memory to reserve a large crash kernel area. So the
> failure of old kexec is consistent between old kernel and new kernel.
>
> Signed-off-by: WANG Chao <chaowang@redhat.com>
> ---
>  arch/x86/kernel/setup.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index f0de629..38e6c1f 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -593,6 +593,20 @@ static void __init reserve_crashkernel(void)
>                                         high ? CRASH_KERNEL_ADDR_HIGH_MAX :
>                                                CRASH_KERNEL_ADDR_LOW_MAX,
>                                         crash_size, alignment);
> +               /*
> +                * crashkernel=X reserve below 896M fails? Try below 4G
> +                */
> +               if (!high && !crash_base)
> +                       crash_base = memblock_find_in_range(alignment,
> +                                               (1ULL << 32),
> +                                               crash_size, alignment);
> +               /*
> +                * crashkernel=X reserve below 4G fails? Try MAXMEM
> +                */
> +               if (!high && !crash_base)
> +                       crash_base = memblock_find_in_range(alignment,
> +                                               CRASH_KERNEL_ADDR_HIGH_MAX,
> +                                               crash_size, alignment);
>
>                 if (!crash_base) {
>                         pr_info("crashkernel reservation failed - No suitable area found.\n");
> --

User should change crashkernel=X to crashkernel=X,high.

As user could forget to update kexec-tools to utilize ",high" feature, and get
kdump later fail later.

Yinghai
