Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab3DBSsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:48:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56885 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977Ab3DBSsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:48:51 -0400
Message-ID: <515B2802.1050405@zytor.com>
Date: Tue, 02 Apr 2013 11:48:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Frantisek Hrbata <fhrbata@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, oleg@redhat.com,
        kamaleshb@in.ibm.com, hechjie@cn.ibm.com
Subject: Re: [PATCH] x86: add phys addr validity check for /dev/mem mmap
References: <1364905733-23937-1-git-send-email-fhrbata@redhat.com>
In-Reply-To: <1364905733-23937-1-git-send-email-fhrbata@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 05:28 AM, Frantisek Hrbata wrote:
> 
> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
> index d8e8eef..39607c6 100644
> --- a/arch/x86/include/asm/io.h
> +++ b/arch/x86/include/asm/io.h
> @@ -242,6 +242,10 @@ static inline void flush_write_buffers(void)
>  #endif
>  }
>  
> +#define ARCH_HAS_VALID_PHYS_ADDR_RANGE
> +extern int valid_phys_addr_range(phys_addr_t addr, size_t count);
> +extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t count);
> +
>  #endif /* __KERNEL__ */
>  
>  extern void native_io_delay(void);
> diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> index 845df68..92ec31c 100644
> --- a/arch/x86/mm/mmap.c
> +++ b/arch/x86/mm/mmap.c
> @@ -31,6 +31,8 @@
>  #include <linux/sched.h>
>  #include <asm/elf.h>
>  
> +#include "physaddr.h"
> +
>  struct __read_mostly va_alignment va_align = {
>  	.flags = -1,
>  };
> @@ -122,3 +124,14 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
>  		mm->unmap_area = arch_unmap_area_topdown;
>  	}
>  }
> +
> +int valid_phys_addr_range(phys_addr_t addr, size_t count)
> +{
> +	return addr + count <= __pa(high_memory);
> +}
> +
> +int valid_mmap_phys_addr_range(unsigned long pfn, size_t count)
> +{
> +	resource_size_t addr = (pfn << PAGE_SHIFT) + count;
> +	return phys_addr_valid(addr);
> +}
> 

Good initiative, but I think the implementation is worong.  I suspect we
should use the number of physical address bits supported rather than
high_memory, since it is common and legal to use /dev/mem to access I/O
resources that are beyond the last byte of RAM.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

