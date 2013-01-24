Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3AXXVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 18:21:51 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:54775
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754818Ab3AXXVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 18:21:45 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I4015Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1155h)
X-WSS-ID: 0MH5KVZ-01-0VM-02
X-M-MSG: 
Date: Thu, 24 Jan 2013 17:21:33 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Borislav Petkov <bp@alien8.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/35] x86: Clean up e820 add kernel range
Message-ID: <20130124232133.GA25969@jshin-Toonie>
References: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
 <1359058816-7615-5-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1359058816-7615-5-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 12:19:45PM -0800, Yinghai Lu wrote:
> Separate it out to another function instead.
> 
> Also add support for case when memmap=xxM$yyM is used without exactmap.
> Need to remove reserved range at first before we add E820_RAM
> range, otherwise added E820_RAM range will be ignored.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Jacob Shin <jacob.shin@amd.com>

Acked-by: Jacob Shin <jacob.shin@amd.com>

Thanks,

> ---
>  arch/x86/kernel/setup.c |   36 ++++++++++++++++++++++--------------
>  1 file changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index b23362f..2242356 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -702,6 +702,27 @@ static void __init trim_bios_range(void)
>  	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
>  }
>  
> +/* called before trim_bios_range() to spare extra sanitize */
> +static void __init e820_add_kernel_range(void)
> +{
> +	u64 start = __pa_symbol(_text);
> +	u64 size = __pa_symbol(_end) - start;
> +
> +	/*
> +	 * Complain if .text .data and .bss are not marked as E820_RAM and
> +	 * attempt to fix it by adding the range. We may have a confused BIOS,
> +	 * or the user may have used memmap=exactmap or memmap=xxM$yyM to
> +	 * exclude kernel range. If we really are running on top non-RAM,
> +	 * we will crash later anyways.
> +	 */
> +	if (e820_all_mapped(start, start + size, E820_RAM))
> +		return;
> +
> +	pr_warn(".text .data .bss are not marked as E820_RAM!\n");
> +	e820_remove_range(start, size, E820_RAM, 0);
> +	e820_add_region(start, size, E820_RAM);
> +}
> +
>  static int __init parse_reservelow(char *p)
>  {
>  	unsigned long long size;
> @@ -897,20 +918,7 @@ void __init setup_arch(char **cmdline_p)
>  	insert_resource(&iomem_resource, &data_resource);
>  	insert_resource(&iomem_resource, &bss_resource);
>  
> -	/*
> -	 * Complain if .text .data and .bss are not marked as E820_RAM and
> -	 * attempt to fix it by adding the range. We may have a confused BIOS,
> -	 * or the user may have incorrectly supplied it via memmap=exactmap. If
> -	 * we really are running on top non-RAM, we will crash later anyways.
> -	 */
> -	if (!e820_all_mapped(code_resource.start, __pa(__brk_limit), E820_RAM)) {
> -		pr_warn(".text .data .bss are not marked as E820_RAM!\n");
> -
> -		e820_add_region(code_resource.start,
> -				__pa(__brk_limit) - code_resource.start + 1,
> -				E820_RAM);
> -	}
> -
> +	e820_add_kernel_range();
>  	trim_bios_range();
>  #ifdef CONFIG_X86_32
>  	if (ppro_with_ram_bug()) {
> -- 
> 1.7.10.4
> 
> 

