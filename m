Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab3LJVG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:06:57 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44678 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3LJVG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:06:56 -0500
MIME-Version: 1.0
In-Reply-To: <52A6D9B0.7040506@huawei.com>
References: <52A6D9B0.7040506@huawei.com>
Date: Tue, 10 Dec 2013 13:06:53 -0800
X-Google-Sender-Auth: dI3-aF0KV-7Y_HUUhFKgbQMTghI
Message-ID: <CAE9FiQUd+sU4GEq0687u8+26jXJiJVboN90+L7svyosmm+V1Rg@mail.gmail.com>
Subject: Re: [PATCH] mm,x86: fix span coverage in e820_all_mapped()
From: Yinghai Lu <yinghai@kernel.org>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linn Crosetto <linn@hp.com>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 1:06 AM, Xishi Qiu <qiuxishi@huawei.com> wrote:
> In the following case, e820_all_mapped() will return 1.
> A < start < B-1 and B < end < C, it means <start, end> spans two regions.
> <start, end>:           [start - end]
> e820 addr:          ...[A - B-1][B - C]...

should be [start, end) right?
and
[A, B),[B, C)

>
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---
>  arch/x86/kernel/e820.c |   15 +++------------
>  1 files changed, 3 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 174da5f..31ecab2 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -85,20 +85,11 @@ int __init e820_all_mapped(u64 start, u64 end, unsigned type)
>
>                 if (type && ei->type != type)
>                         continue;
> -               /* is the region (part) in overlap with the current region ?*/
> +               /* is the region (part) in overlap with the current region ? */
>                 if (ei->addr >= end || ei->addr + ei->size <= start)
>                         continue;
> -
> -               /* if the region is at the beginning of <start,end> we move
> -                * start to the end of the region since it's ok until there
> -                */
> -               if (ei->addr <= start)
> -                       start = ei->addr + ei->size;

so in your case new start will be B ?

next run will be C

> -               /*
> -                * if start is now at or beyond end, we're done, full
> -                * coverage
> -                */
> -               if (start >= end)


> +               /* is the region full coverage of <start, end> ? */
> +               if (ei->addr <= start && ei->addr + ei->size >= end)
>                         return 1;
>         }
>         return 0;

also e820 should be sanitized already to have [A,C).

or you are talking about [A,B), [B+1, C)
first run start will be B,  and next run with [B+1, ...), that will be
skipped...
will not return 1.

so old code should be ok.

Thanks

Yinghai
