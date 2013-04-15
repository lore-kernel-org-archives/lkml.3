Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3DOUrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 16:47:09 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59372 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3DOUrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 16:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130415080621.GA1994@udknight>
References: <20130415080621.GA1994@udknight>
Date: Mon, 15 Apr 2013 13:47:07 -0700
X-Google-Sender-Auth: UmYYWRzaYEkzfKzYth8Vzitaloc
Message-ID: <CAE9FiQWh_jFUDBHcQC=T_j+4Mneqb47kwpoLv7sBcv_o3HkqwA@mail.gmail.com>
Subject: Re: [PATCH 1/3] x86: reserve_crashkernel: use memblock_is_region_reserved
 to simplify code
From: Yinghai Lu <yinghai@kernel.org>
To: Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 1:06 AM, Wang YanQing <udknight@gmail.com> wrote:
> Use memblock_is_region_reserved instead of memblock_find_in_range
> to simplify the check codes, and gain a little speed benefit.
>
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  arch/x86/kernel/setup.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 90d8cc9..9d60c85 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -577,11 +577,7 @@ static void __init reserve_crashkernel(void)
>                 }
>
>         } else {
> -               unsigned long long start;
> -
> -               start = memblock_find_in_range(crash_base,
> -                                crash_base + crash_size, crash_size, 1<<20);
> -               if (start != crash_base) {
> +               if (memblock_is_region_reserved(crash_base, crash_size)) {
>                         pr_info("crashkernel reservation failed - memory is in use.\n");
>                         return;
>                 }

We need to use memblock_find_in_range here.

As the range [crash_base, crash_base+crash_size) could be not in
memblock.memory.

for example, if the ram only have 16G installed, and user just specify
crash_base to 64g.
and there is no [64g...) in memblock.reserved.
But that does not mean that we can use that range.

Thanks

Yinghai
