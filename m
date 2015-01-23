Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbbAWIqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:46:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbbAWIqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:46:53 -0500
Date: Fri, 23 Jan 2015 16:44:53 +0800
From: Baoquan He <bhe@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 3/3] x86, crash: Allocate enough low-mem when
 crashkernel=high
Message-ID: <20150123084453.GL2461@dhcp-16-105.nay.redhat.com>
References: <1420555874-11506-1-git-send-email-joro@8bytes.org>
 <1420555874-11506-4-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420555874-11506-4-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

Yeah, it does happen if too many devices. I guess the reason no reports
come to us on rhel is we always use a auto mechsanism. We always try to
allocate from below 896M, if failed try below 4G, if failed try above
4G.

This could be solved in 2 ways:

1) We could optimize the distro shell scripts which build the initramfs
for kdump. Only include those devices which are necessary in kdump
kernel. E.g for net dump only that NIC which connect to dump target will
be brought up, this can decrease the dma memory requirement.

2) increase low-mem when crashkernel=high. But we have to be careful to
do this. We implement crashkernel=high not only for the unhappiness
crashkernel reservation is limited below 4G, but dma/dma32 memory space
is precious on some systems. If set crashkernel=high still too much low
memory has to be reserved by default, it's important to find the
balance. So if we have to increase the default low-mem, how much memory
is enough, why 256M?  why not 128M/192M/320M/384M?  And if 256M works
on your system, what if another person say it does't work because there
are more devices on his system?

Anyway, I understand the requirement, but we need find out how much
memory can satisfy most of systems.


Thanks
Baoquan

On 01/06/15 at 03:51pm, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> When the crashkernel is loaded above 4GiB in memory the
> first kernel only allocates 72MiB of low-memory for the DMA
> requirements of the second kernel. On systems with many
> devices this is not enough and causes device driver
> initialization errors and failed crash dumps. Set this
> default value to 256MiB to make sure there is enough memory
> available for DMA.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/setup.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index ab4734e..d6e6a6d 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -536,8 +536,11 @@ static void __init reserve_crashkernel_low(void)
>  		 *	swiotlb overflow buffer: now is hardcoded to 32k.
>  		 *		We round it to 8M for other buffers that
>  		 *		may need to stay low too.
> +		 *		Also make sure we allocate enough extra memory
> +		 *		low memory so that we don't run out of DMA
> +		 *		buffers for 32bit devices.
>  		 */
> -		low_size = swiotlb_size_or_default() + (8UL<<20);
> +		low_size = max(swiotlb_size_or_default() + (8UL<<20), 256UL<<20);
>  		auto_set = true;
>  	} else {
>  		/* passed with crashkernel=0,low ? */
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
