Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3HFW1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:27:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43907 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756397Ab3HFW1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:27:35 -0400
Message-ID: <52017845.5000205@zytor.com>
Date: Tue, 06 Aug 2013 15:27:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Gang Wei <gang.wei@intel.com>
Subject: Re: [PATCH v5] x86, tboot: iomem fixes
References: <1374337612-6899-1-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1374337612-6899-1-git-send-email-qiaowei.ren@intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2013 09:26 AM, Qiaowei Ren wrote:
>  
>  	/* now map TXT heap */
> -	heap_base = ioremap(*(u64 *)(config + TXTCR_HEAP_BASE),
> -			    *(u64 *)(config + TXTCR_HEAP_SIZE));
> +	heap_base = ioremap(readl(config + TXTCR_HEAP_BASE),
> +			    readl(config + TXTCR_HEAP_SIZE));

You are changing u64 references to readl()... this means you are doing
only 32-bit reads.

>  	iounmap(config);
>  	if (!heap_base)
>  		return NULL;
>  
>  	/* walk heap to SinitMleData */
>  	/* skip BiosData */
> -	heap_ptr = heap_base + *(u64 *)heap_base;
> +	heap_ptr = heap_base + readq(heap_base);
>  	/* skip OsMleData */
> -	heap_ptr += *(u64 *)heap_ptr;
> +	heap_ptr += readq(heap_ptr);
>  	/* skip OsSinitData */
> -	heap_ptr += *(u64 *)heap_ptr;
> +	heap_ptr += readq(heap_ptr);

As I believe Ingo already commented on, readq() only exists on 64 bits.

You can #include <asm-generic/io-64-nonatomic-lo-hi.h> to remedy that.

>  	/* now points to SinitMleDataSize; set to SinitMleData */
>  	heap_ptr += sizeof(u64);
>  	/* get addr of DMAR table */
> +	dmar_tbl_off = readl(heap_ptr +
> +			offsetof(struct sinit_mle_data, vtd_dmars_off));
>  	dmar_tbl = (struct acpi_table_header *)(heap_ptr +
> -		   ((struct sinit_mle_data *)heap_ptr)->vtd_dmars_off -
> -		   sizeof(u64));
> +			dmar_tbl_off - sizeof(u64));
>  
>  	/* don't unmap heap because dmar.c needs access to this */
>  

If you are using accessors here, what about dmar_tbl itself?

	-hpa



