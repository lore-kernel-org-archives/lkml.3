Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab3ESOBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 10:01:22 -0400
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:7098
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286Ab3ESOBM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 10:01:12 -0400
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 May 2013 10:01:11 EDT
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(z555ehzc89bh1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz17326ah8275bh8275dhz2dh668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MN1SUE-01-EBQ-02
X-M-MSG: 
Message-ID: <5198D73E.1010602@amd.com>
Date: Sun, 19 May 2013 15:44:30 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <mingo@kernel.org>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <yinghai@kernel.org>, <tglx@linutronix.de>, <hpa@linux.intel.com>,
        <christian.koenig@amd.com>
CC: tip-bot for Yinghai Lu <tipbot@zytor.com>,
        <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86, range: fix missing merge during add range
References: <CAE9FiQVofGoSk7q5-0irjkBxemqK729cND4hov-1QCBJDhxpgQ@mail.gmail.com> <tip-fbe06b7bae7c9cf6ab05168fce5ee93b2f4bae7c@git.kernel.org>
In-Reply-To: <tip-fbe06b7bae7c9cf6ab05168fce5ee93b2f4bae7c@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.05.2013 21:12, schrieb tip-bot for Yinghai Lu:
> Commit-ID:  fbe06b7bae7c9cf6ab05168fce5ee93b2f4bae7c
> Gitweb:     http://git.kernel.org/tip/fbe06b7bae7c9cf6ab05168fce5ee93b2f4bae7c
> Author:     Yinghai Lu <yinghai@kernel.org>
> AuthorDate: Fri, 17 May 2013 11:49:10 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Fri, 17 May 2013 11:49:10 -0700
>
> x86, range: fix missing merge during add range
>
> Christian found v3.9 does not work with E350 with EFI is enabled.
>
> [    1.658832] Trying to unpack rootfs image as initramfs...
> [    1.679935] BUG: unable to handle kernel paging request at ffff88006e3fd000
> [    1.686940] IP: [<ffffffff813661df>] memset+0x1f/0xb0
> [    1.692010] PGD 1f77067 PUD 1f7a067 PMD 61420067 PTE 0
>
> but early memtest report all memory could be accessed without problem.
>
> early page table is set in following sequence:
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000] init_memory_mapping: [mem 0x6e600000-0x6e7fffff]
> [    0.000000] init_memory_mapping: [mem 0x6c000000-0x6e5fffff]
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x6bffffff]
> [    0.000000] init_memory_mapping: [mem 0x6e800000-0x6ea07fff]
> but later efi_enter_virtual_mode try set mapping again wrongly.
> [    0.010644] pid_max: default: 32768 minimum: 301
> [    0.015302] init_memory_mapping: [mem 0x640c5000-0x6e3fcfff]
> that means it fails with pfn_range_is_mapped.
>
> It turns out that we have a bug in add_range_with_merge and it does not
> merge range properly when new add one fill the hole between two exsiting
> ranges. In the case when [mem 0x00100000-0x6bffffff] is the hole between
> [mem 0x00000000-0x000fffff] and [mem 0x6c000000-0x6e7fffff].
>
> Fix the add_range_with_merge by calling itself recursively.
>
> Reported-by: "Christian König" <christian.koenig@amd.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Link: http://lkml.kernel.org/r/CAE9FiQVofGoSk7q5-0irjkBxemqK729cND4hov-1QCBJDhxpgQ@mail.gmail.com
> Cc: <stable@vger.kernel.org> v3.9
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

Tested-by: Christian König <christian.koenig@amd.com>

> ---
>   kernel/range.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/range.c b/kernel/range.c
> index 071b0ab..eb911db 100644
> --- a/kernel/range.c
> +++ b/kernel/range.c
> @@ -48,9 +48,11 @@ int add_range_with_merge(struct range *range, int az, int nr_range,
>   		final_start = min(range[i].start, start);
>   		final_end = max(range[i].end, end);
>   
> -		range[i].start = final_start;
> -		range[i].end =  final_end;
> -		return nr_range;
> +		/* clear it and add it back for further merge */
> +		range[i].start = 0;
> +		range[i].end =  0;
> +		return add_range_with_merge(range, az, nr_range,
> +			final_start, final_end);
>   	}
>   
>   	/* Need to add it: */
>


