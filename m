Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab3JXTEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:04:07 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:46266 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab3JXTEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:04:06 -0400
MIME-Version: 1.0
In-Reply-To: <1381751200-27376-1-git-send-email-chaowang@redhat.com>
References: <1381751200-27376-1-git-send-email-chaowang@redhat.com>
Date: Thu, 24 Oct 2013 12:04:04 -0700
X-Google-Sender-Auth: Dm_kK82zv9wXGiRxaRks-qiso7M
Message-ID: <CAE9FiQWC43b9ptv3=9cth_cPWYaCZ8aCuTdO5is_ESpiFajQTw@mail.gmail.com>
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

Another problem, it would allocate range in [0,4g) for 32bit,
if the user have crashkernel=512M or plus.

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


Yinghai
