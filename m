Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762168Ab3DBTK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:10:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761925Ab3DBTK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:10:26 -0400
Date: Tue, 2 Apr 2013 21:10:12 +0200
From: Frantisek Hrbata <fhrbata@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, oleg@redhat.com,
        kamaleshb@in.ibm.com, hechjie@cn.ibm.com
Subject: Re: [PATCH] x86: add phys addr validity check for /dev/mem mmap
Message-ID: <20130402191012.GC3314@dhcp-26-164.brq.redhat.com>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <1364905733-23937-1-git-send-email-fhrbata@redhat.com>
 <515B2802.1050405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515B2802.1050405@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 11:48:34AM -0700, H. Peter Anvin wrote:
> On 04/02/2013 05:28 AM, Frantisek Hrbata wrote:
> > 
> > diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
> > index d8e8eef..39607c6 100644
> > --- a/arch/x86/include/asm/io.h
> > +++ b/arch/x86/include/asm/io.h
> > @@ -242,6 +242,10 @@ static inline void flush_write_buffers(void)
> >  #endif
> >  }
> >  
> > +#define ARCH_HAS_VALID_PHYS_ADDR_RANGE
> > +extern int valid_phys_addr_range(phys_addr_t addr, size_t count);
> > +extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t count);
> > +
> >  #endif /* __KERNEL__ */
> >  
> >  extern void native_io_delay(void);
> > diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> > index 845df68..92ec31c 100644
> > --- a/arch/x86/mm/mmap.c
> > +++ b/arch/x86/mm/mmap.c
> > @@ -31,6 +31,8 @@
> >  #include <linux/sched.h>
> >  #include <asm/elf.h>
> >  
> > +#include "physaddr.h"
> > +
> >  struct __read_mostly va_alignment va_align = {
> >  	.flags = -1,
> >  };
> > @@ -122,3 +124,14 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
> >  		mm->unmap_area = arch_unmap_area_topdown;
> >  	}
> >  }
> > +
> > +int valid_phys_addr_range(phys_addr_t addr, size_t count)
> > +{
> > +	return addr + count <= __pa(high_memory);
> > +}
> > +
> > +int valid_mmap_phys_addr_range(unsigned long pfn, size_t count)
> > +{
> > +	resource_size_t addr = (pfn << PAGE_SHIFT) + count;
> > +	return phys_addr_valid(addr);
> > +}
> > 
> 
> Good initiative, but I think the implementation is worong.  I suspect we
> should use the number of physical address bits supported rather than
> high_memory, since it is common and legal to use /dev/mem to access I/O
> resources that are beyond the last byte of RAM.
> 
> 	-hpa

Hi, this is exactly what the patch is doing imho. Note that the
valid_phys_addr_range(), which is using the high_memory, is the same as the
default one in drivers/char/mem.c(#ifndef ARCH_HAS_VALID_PHYS_ADDR_RANGE). I
just added x86 specific check for valid_mmap_phys_addr_range and moved both
functions to arch/x86/mm/mmap.c, rather then modifying the default generic ones.
This is how other archs(arm) are doing it.

Also valid_phys_addr_range is used just in read|write_mem and
valid_mmap_phys_addr_range is checked in mmap_mem and it calls phys_addr_valid

static inline int phys_addr_valid(resource_size_t addr)
{
#ifdef CONFIG_PHYS_ADDR_T_64BIT
	return !(addr >> boot_cpu_data.x86_phys_bits);
#else
        return 1;
#endif
}                          

I for sure could overlooked something, but this seems right to me.

Thank you!

> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 

-- 
Frantisek Hrbata
