Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3LSQoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:44:15 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:46701 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3LSQoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:44:14 -0500
MIME-Version: 1.0
In-Reply-To: <tip-f3d815cb854b2f6262ade56a4d91a1ed3f1e50c4@git.kernel.org>
References: <1386303510-18574-1-git-send-email-jia.zhang@windriver.com>
	<tip-f3d815cb854b2f6262ade56a4d91a1ed3f1e50c4@git.kernel.org>
Date: Thu, 19 Dec 2013 08:44:11 -0800
X-Google-Sender-Auth: SIso7Uik4tb9s0UQtF6Rawjhq_I
Message-ID: <CAE9FiQW38bei=x1LaSnh0FFe30YSc2YcMzdTZs-BYMrHLLcOpQ@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86/mm/numa: Fix 32-bit kernel NUMA boot
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yinghai@kernel.org>,
        jia.zhang@windriver.com, Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 7:42 AM, tip-bot for Lans Zhang
<tipbot@zytor.com> wrote:
> Commit-ID:  f3d815cb854b2f6262ade56a4d91a1ed3f1e50c4
> Gitweb:     http://git.kernel.org/tip/f3d815cb854b2f6262ade56a4d91a1ed3f1e50c4
> Author:     Lans Zhang <jia.zhang@windriver.com>
> AuthorDate: Fri, 6 Dec 2013 12:18:30 +0800
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Thu, 19 Dec 2013 13:58:36 +0100
>
> x86/mm/numa: Fix 32-bit kernel NUMA boot
>
> When booting a 32-bit x86 kernel on a NUMA machine, node data
> cannot be allocated from local node if the account of memory for
> node 0 covers the low memory space entirely:
>
>   [    0.000000] Initmem setup node 0 [mem 0x00000000-0x83fffffff]
>   [    0.000000]   NODE_DATA [mem 0x367ed000-0x367edfff]
>   [    0.000000] Initmem setup node 1 [mem 0x840000000-0xfffffffff]
>   [    0.000000] Cannot find 4096 bytes in node 1
>   [    0.000000] 64664MB HIGHMEM available.
>   [    0.000000] 871MB LOWMEM available.
>
> To fix this issue, node data is allowed to be allocated from
> other nodes if the memory of local node is still not mapped. The
> expected result looks like this:
>
>   [    0.000000] Initmem setup node 0 [mem 0x00000000-0x83fffffff]
>   [    0.000000]   NODE_DATA [mem 0x367ed000-0x367edfff]
>   [    0.000000] Initmem setup node 1 [mem 0x840000000-0xfffffffff]
>   [    0.000000]   NODE_DATA [mem 0x367ec000-0x367ecfff]
>   [    0.000000]     NODE_DATA(1) on node 0
>   [    0.000000] 64664MB HIGHMEM available.
>   [    0.000000] 871MB LOWMEM available.
>
> Signed-off-by: Lans Zhang <jia.zhang@windriver.com>
> Cc: <andi@firstfloor.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Link: http://lkml.kernel.org/r/1386303510-18574-1-git-send-email-jia.zhang@windriver.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/mm/numa.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index 24aec58..c85da7b 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -211,9 +211,13 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
>          */
>         nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
>         if (!nd_pa) {
> -               pr_err("Cannot find %zu bytes in node %d\n",
> -                      nd_size, nid);
> -               return;
> +               nd_pa = __memblock_alloc_base(nd_size, SMP_CACHE_BYTES,
> +                                             MEMBLOCK_ALLOC_ACCESSIBLE);
> +               if (!nd_pa) {
> +                       pr_err("Cannot find %zu bytes in node %d\n",
> +                              nd_size, nid);
> +                       return;
> +               }
>         }
>         nd = __va(nd_pa);
>

Can you just use memblock_alloc_try_nid instead memblock_alloc_nid?

Thanks

Yinghai
