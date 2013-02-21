Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020Ab3BUUbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:31:45 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:57536 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758919Ab3BUUbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:31:35 -0500
MIME-Version: 1.0
In-Reply-To: <1361477421-3964-1-git-send-email-vgupta@synopsys.com>
References: <20130221193639.GN3570@htj.dyndns.org>
	<1361477421-3964-1-git-send-email-vgupta@synopsys.com>
Date: Thu, 21 Feb 2013 12:31:34 -0800
X-Google-Sender-Auth: 7ySUd6O5TO3sddPVDxGspE2Y_kI
Message-ID: <CAE9FiQV20uj_kOViCOd4gdPFuAf28fEbjhGCrzNogQWx5T3+zg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] memblock: add assertion for zero allocation alignment
From: Yinghai Lu <yinghai@kernel.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 12:10 PM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> This came to light when calling memblock allocator from arc port (for
> copying flattended DT). If a "0" alignment is passed, the allocator
> round_up() call incorrectly rounds up the size to 0.
>
> round_up(num, alignto) => ((num - 1) | (alignto -1)) + 1
>
> While the obvious allocation failure causes kernel to panic, it is
> better to warn the caller to fix the code.
>
> Tejun suggested that instead of BUG_ON(!align) - which might be
> ineffective due to pending console init and such, it is better to
> WARN_ON, and continue the boot with a reasonable default align.
>
> Caller passing @size need not be handled similarly as the subsequent
> panic will indicate that anyhow.
>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  mm/memblock.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 1bcd9b9..f3804bd 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -824,6 +824,9 @@ static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
>         /* align @size to avoid excessive fragmentation on reserved array */
>         size = round_up(size, align);
>
> +       if (WARN_ON(!align))
> +               align = __alignof__(long long);
> +

the checking should be put before round_up?

>         found = memblock_find_in_range_node(0, max_addr, size, align, nid);
>         if (found && !memblock_reserve(found, size))
>                 return found;
> --
> 1.7.4.1
>
