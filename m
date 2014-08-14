Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaHNQgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 12:36:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:56565 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbaHNQgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 12:36:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,864,1400050800"; 
   d="scan'208";a="558633973"
Message-ID: <53ECE573.1030405@intel.com>
Date: Thu, 14 Aug 2014 09:36:03 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Frantisek Hrbata <fhrbata@redhat.com>, linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com, akpm@linux-foundation.org, dvlasenk@redhat.com,
        prarit@redhat.com, lwoodman@redhat.com, hannsj_uhl@de.ibm.com
Subject: Re: [PATCH 1/1] x86: add phys addr validity check for /dev/mem mmap
References: <1408025927-16826-1-git-send-email-fhrbata@redhat.com> <1408025927-16826-2-git-send-email-fhrbata@redhat.com>
In-Reply-To: <1408025927-16826-2-git-send-email-fhrbata@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for dredging this back up!

On 08/14/2014 07:18 AM, Frantisek Hrbata wrote:
> +int valid_phys_addr_range(phys_addr_t addr, size_t count)
> +{
> +	return addr + count <= __pa(high_memory);
> +}

Is this correct on 32-bit?  It would limit /dev/mem to memory below 896MB.

> +int valid_mmap_phys_addr_range(unsigned long pfn, size_t count)
> +{

Nit: please add units to things like "count".  len_bytes would be nice
for this kind of thing, especially since it's passed *with* a pfn it
would be easy to think it is a count in pages.

> +	/* pgoff + count overflow is checked in do_mmap_pgoff */
> +	pfn += count >> PAGE_SHIFT;
> +
> +	if (pfn >> BITS_PER_LONG - PAGE_SHIFT)
> +		return -EOVERFLOW;

Is this -EOVERFLOW correct?  It is called like this:

> static int mmap_mem(struct file *file, struct vm_area_struct *vma)
> {
>         if (!valid_mmap_phys_addr_range(vma->vm_pgoff, size))
>                 return -EINVAL;

So I think we need to return true/false:0/1.  -EOVERFLOW would be true,
and that if() would pass.

> +	return phys_addr_valid(pfn << PAGE_SHIFT);
> +}

Maybe I'm dumb, but it took me a minute to figure out what you were
trying to do with the: "(pfn >> BITS_PER_LONG - PAGE_SHIFT)".  In any
case, I think it is wrong on 32-bit.

On 32-bit, BITS_PER_LONG=32, and PAGE_SIZE=12, and a paddr=0x100000000
or pfn=0x100000 (4GB) is perfectly valid with PAE enabled.  But, this
code pfn>>(32-12) would result in 0x1 and return -EOVERFLOW.

I think something like this would be easier to read and actually work on
32-bit:

static inline int arch_pfn_possible(unsigned long pfn)
{
 	unsigned long max_arch_pfn = 1UL << (boot_cpu_data.x86_phys_bits -
PAGE_SHIFT);
	return pfn < max_arch_pfn;
}
