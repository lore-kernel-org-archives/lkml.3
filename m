Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab3CGAHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:07:48 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:58004 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab3CGAHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:07:20 -0500
MIME-Version: 1.0
In-Reply-To: <20130306224405.8160D5A4082@corp2gmr1-2.hot.corp.google.com>
References: <20130306224405.8160D5A4082@corp2gmr1-2.hot.corp.google.com>
Date: Wed, 6 Mar 2013 16:07:20 -0800
X-Google-Sender-Auth: mjwx3H1XRpsw6HLNukITIZ-X2OQ
Message-ID: <CAE9FiQVAnR08U=ywUzk_4fkSh_mz6sZqtwWg02YzzF_cbN45rQ@mail.gmail.com>
Subject: Re: + memblock-add-assertion-for-zero-allocation-alignment.patch
 added to -mm tree
From: Yinghai Lu <yinghai@kernel.org>
To: akpm@linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: mm-commits@vger.kernel.org, Vineet.Gupta1@synopsys.com,
        liwanp@linux.vnet.ibm.com, mingo@kernel.org, tj@kernel.org,
        vgupta@synopsys.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 2:44 PM,  <akpm@linux-foundation.org> wrote:
> ------------------------------------------------------
> From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> Subject: memblock: add assertion for zero allocation alignment
>
> This came to light when calling memblock allocator from arc port (for
> copying flattended DT).  If a "0" alignment is passed, the allocator
> round_up() call incorrectly rounds up the size to 0.
>
> round_up(num, alignto) => ((num - 1) | (alignto -1)) + 1
>
> While the obvious allocation failure causes kernel to panic, it is better
> to warn the caller to fix the code.
>
> Tejun suggested that instead of BUG_ON(!align) - which might be
> ineffective due to pending console init and such, it is better to WARN_ON,
> and continue the boot with a reasonable default align.
>
> Caller passing @size need not be handled similarly as the subsequent
> panic will indicate that anyhow.
>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/memblock.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff -puN mm/memblock.c~memblock-add-assertion-for-zero-allocation-alignment mm/memblock.c
> --- a/mm/memblock.c~memblock-add-assertion-for-zero-allocation-alignment
> +++ a/mm/memblock.c
> @@ -771,6 +771,9 @@ static phys_addr_t __init memblock_alloc
>  {
>         phys_addr_t found;
>
> +       if (WARN_ON(!align))
> +               align = __alignof__(long long);
> +
>         /* align @size to avoid excessive fragmentation on reserved array */
>         size = round_up(size, align);

Hi, Peter,

Do you agree that we should check align in round_up()?

Thanks

Yinghai
