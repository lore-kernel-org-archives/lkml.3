Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab3EGR61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 13:58:27 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:6459
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753154Ab3EGR60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 13:58:26 -0400
X-Forefront-Antispam-Report: CIP:157.56.238.53;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0712HT004.namprd07.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Message-ID: <518940BB.3080307@caviumnetworks.com>
Date: Tue, 7 May 2013 10:58:19 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: <linux-mips@linux-mips.org>, <ralf@linux-mips.org>,
        Jiang Liu <liuj97@gmail.com>, <eunb.song@samsung.com>,
        <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] MIPS: Make virt_to_phys() work for all unmapped addresses.
References: <1367947427-21649-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1367947427-21649-1-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't apply anymore.  It was against v3.4.

I will send one against Linus' tree soon.

David Daney


On 05/07/2013 10:23 AM, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
>
> As reported:
>    This problem was discovered when doing BGP traffic with the TCP MD5 option
>    activated, where the following call chain caused a crash:
>
>     * tcp_v4_rcv
>     *  tcp_v4_timewait_ack
>     *   tcp_v4_send_ack -> follow stack variable rep.th
>     *    tcp_v4_md5_hash_hdr
>     *     tcp_md5_hash_header
>     *      sg_init_one
>     *       sg_set_buf
>     *        virt_to_page
>
>    I noticed that tcp_v4_send_reset uses a similar stack variable and
>    also calls tcp_v4_md5_hash_hdr, so it has the same problem.
>
> The networking core can indirectly call virt_to_phys() on stack
> addresses, if this is done from PID 0, the stack will usually be in
> CKSEG0, so virt_to_phys() needs to work there as well
>
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>
> Not tested against kernel.org kernel, but it may still apply
>
> This could also fix problems noted by Eunbong Song with the
> free_initmem_default() call.
>
>   arch/mips/include/asm/io.h   | 2 +-
>   arch/mips/include/asm/page.h | 5 +++--
>   2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/mips/include/asm/io.h b/arch/mips/include/asm/io.h
> index a58f229..37fa957 100644
> --- a/arch/mips/include/asm/io.h
> +++ b/arch/mips/include/asm/io.h
> @@ -116,7 +116,7 @@ static inline void set_io_port_base(unsigned long base)
>    */
>   static inline unsigned long virt_to_phys(volatile const void *address)
>   {
> -	return (unsigned long)address - PAGE_OFFSET + PHYS_OFFSET;
> +	return __pa(address);
>   }
>
>   /*
> diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
> index cee3893..e09bff9 100644
> --- a/arch/mips/include/asm/page.h
> +++ b/arch/mips/include/asm/page.h
> @@ -48,7 +48,6 @@
>   #ifndef __ASSEMBLY__
>
>   #include <linux/pfn.h>
> -#include <asm/io.h>
>
>   extern void build_clear_page(void);
>   extern void build_copy_page(void);
> @@ -139,7 +138,6 @@ typedef struct { unsigned long pgprot; } pgprot_t;
>    */
>   #define ptep_buddy(x)	((pte_t *)((unsigned long)(x) ^ sizeof(pte_t)))
>
> -#endif /* !__ASSEMBLY__ */
>
>   /*
>    * __pa()/__va() should be used only during mem init.
> @@ -156,6 +154,9 @@ typedef struct { unsigned long pgprot; } pgprot_t;
>   #endif
>   #define __va(x)		((void *)((unsigned long)(x) + PAGE_OFFSET - PHYS_OFFSET))
>
> +#include <asm/io.h>
> +#endif /* !__ASSEMBLY__ */
> +
>   /*
>    * RELOC_HIDE was originally added by 6007b903dfe5f1d13e0c711ac2894bdd4a61b1ad
>    * (lmo) rsp. 8431fd094d625b94d364fe393076ccef88e6ce18 (kernel.org).  The
>


