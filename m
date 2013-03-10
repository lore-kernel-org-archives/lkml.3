Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab3CJHME (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 03:12:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27894 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab3CJHMC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 03:12:02 -0400
X-IronPort-AV: E=Sophos;i="4.84,817,1355068800"; 
   d="scan'208";a="6843846"
Message-ID: <513C2553.5050402@cn.fujitsu.com>
Date: Sun, 10 Mar 2013 14:16:51 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/20] vmcore: copy non page-size aligned head and
 tail pages in 2nd kernel
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6> <20130302083627.31252.41277.stgit@localhost6.localdomain6>
In-Reply-To: <20130302083627.31252.41277.stgit@localhost6.localdomain6>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/10 14:17:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/10 14:17:18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月02日 16:36, HATAYAMA Daisuke 写道:
> Due to mmap() requirement, we need to copy pages not starting or
> ending with page-size aligned address in 2nd kernel and to map them to
> user-space.
> 
> For example, see the map below:
> 
>     00000000-0001ffff : reserved
>     00010000-0009f7ff : System RAM
>     0009f800-0009ffff : reserved
> 
> where the System RAM ends with 0x9f800 that is not page-size
> aligned. This map is divided into two parts:
> 
>     00010000-0009dfff

00010000-0009efff

>     0009f000-0009f7ff
> 
> and the first one is kept in old memory and the 2nd one is copied into
> buffer on 2nd kernel.
> 
> This kind of non-page-size-aligned area can always occur since any
> part of System RAM can be converted into reserved area at runtime.
> 
> If not doing copying like this and if remapping non page-size aligned
> pages on old memory directly, mmap() had to export memory which is not
> dump target to user-space. In the above example this is reserved
> 0x9f800-0xa0000.
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
> 
>  fs/proc/vmcore.c |  192 ++++++++++++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 172 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index c511cf4..6b071b4 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -474,11 +474,10 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
>  						size_t elfsz,
>  						struct list_head *vc_list)
>  {
> -	int i;
> +	int i, rc;
>  	Elf64_Ehdr *ehdr_ptr;
>  	Elf64_Phdr *phdr_ptr;
>  	loff_t vmcore_off;
> -	struct vmcore *new;
>  
>  	ehdr_ptr = (Elf64_Ehdr *)elfptr;
>  	phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
> @@ -488,20 +487,97 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
>  						  PAGE_SIZE);
>  
>  	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
> +		u64 start, end, rest;
> +
>  		if (phdr_ptr->p_type != PT_LOAD)
>  			continue;
>  
> -		/* Add this contiguous chunk of memory to vmcore list.*/
> -		new = get_new_element();
> -		if (!new)
> -			return -ENOMEM;
> -		new->paddr = phdr_ptr->p_offset;
> -		new->size = phdr_ptr->p_memsz;
> -		list_add_tail(&new->list, vc_list);
> +		start = phdr_ptr->p_offset;
> +		end = phdr_ptr->p_offset + phdr_ptr->p_memsz;
> +		rest = phdr_ptr->p_memsz;
> +
> +		if (start & ~PAGE_MASK) {
> +			u64 paddr, len;
> +			char *buf;
> +			struct vmcore *new;
> +
> +			paddr = start;
> +			len = min(roundup(start,PAGE_SIZE), end) - start;
> +
> +			buf = (char *)get_zeroed_page(GFP_KERNEL);
> +			if (!buf)
> +				return -ENOMEM;
> +			rc = read_from_oldmem(buf + (start & ~PAGE_MASK), len,
> +					      &paddr, 0);
> +			if (rc < 0) {
> +				free_pages((unsigned long)buf, 0);
> +				return rc;
> +			}
> +
> +			new = get_new_element();
> +			if (!new) {
> +				free_pages((unsigned long)buf, 0);
> +				return -ENOMEM;
> +			}
> +			new->flag |= MEM_TYPE_CURRENT_KERNEL;
> +			new->size = PAGE_SIZE;
> +			new->buf = buf;
> +			list_add_tail(&new->list, vc_list);
> +
> +			rest -= len;
> +		}
> +
> +		if (rest > 0 &&
> +		    roundup(start, PAGE_SIZE) < rounddown(end, PAGE_SIZE)) {
> +			u64 paddr, len;
> +			struct vmcore *new;
> +
> +			paddr = roundup(start, PAGE_SIZE);
> +			len =rounddown(end,PAGE_SIZE)-roundup(start,PAGE_SIZE);
> +
> +			new = get_new_element();
> +			if (!new)
> +				return -ENOMEM;
> +			new->paddr = paddr;
> +			new->size = len;
> +			list_add_tail(&new->list, vc_list);
> +
> +			rest -= len;
> +		}
> +
> +		if (rest > 0) {
> +			u64 paddr, len;
> +			char *buf;
> +			struct vmcore *new;
> +
> +			paddr = rounddown(end, PAGE_SIZE);
> +			len = end - rounddown(end, PAGE_SIZE);
> +
> +			buf = (char *)get_zeroed_page(GFP_KERNEL);
> +			if (!buf)
> +				return -ENOMEM;
> +			rc = read_from_oldmem(buf, len, &paddr, 0);
> +			if (rc < 0) {
> +				free_pages((unsigned long)buf, 0);
> +				return rc;
> +			}
> +
> +			new = get_new_element();
> +			if (!new) {
> +				free_pages((unsigned long)buf, 0);
> +				return -ENOMEM;
> +			}
> +			new->flag |= MEM_TYPE_CURRENT_KERNEL;
> +			new->size = PAGE_SIZE;
> +			new->buf = buf;
> +			list_add_tail(&new->list, vc_list);
> +
> +			rest -= len;
> +		}
>  
>  		/* Update the program header offset. */
>  		phdr_ptr->p_offset = vmcore_off;
> -		vmcore_off = vmcore_off + phdr_ptr->p_memsz;
> +		vmcore_off +=roundup(end,PAGE_SIZE)-rounddown(start,PAGE_SIZE);

Here the code changes phdr_ptr->p_offset to a new page-size aligned offset.
But it seems the phdr_ptr->p_paddr is still the non page-size aligned
physical address? Does the mismatch of a PT_LOAD segment and the physical
memory occur?

Or, later in makedumpfile, it will check the phdr_ptr->paddr to see if it
is page-size aligned and also phdr_ptr->p_memsz to get the real memory size,
not including padding?

>  	}
>  	return 0;
>  }
> @@ -510,11 +586,10 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
>  						size_t elfsz,
>  						struct list_head *vc_list)
>  {
> -	int i;
> +	int i, rc;
>  	Elf32_Ehdr *ehdr_ptr;
>  	Elf32_Phdr *phdr_ptr;
>  	loff_t vmcore_off;
> -	struct vmcore *new;
>  
>  	ehdr_ptr = (Elf32_Ehdr *)elfptr;
>  	phdr_ptr = (Elf32_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
> @@ -524,20 +599,97 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
>  						 PAGE_SIZE);
>  
>  	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
> +		u64 start, end, rest;
> +
>  		if (phdr_ptr->p_type != PT_LOAD)
>  			continue;
>  
> -		/* Add this contiguous chunk of memory to vmcore list.*/
> -		new = get_new_element();
> -		if (!new)
> -			return -ENOMEM;
> -		new->paddr = phdr_ptr->p_offset;
> -		new->size = phdr_ptr->p_memsz;
> -		list_add_tail(&new->list, vc_list);
> +		start = phdr_ptr->p_offset;
> +		end = phdr_ptr->p_offset + phdr_ptr->p_memsz;
> +		rest = phdr_ptr->p_memsz;
> +
> +		if (start & ~PAGE_MASK) {
> +			u64 paddr, len;
> +			char *buf;
> +			struct vmcore *new;
> +
> +			paddr = start;
> +			len = min(roundup(start,PAGE_SIZE), end) - start;
> +
> +			buf = (char *)get_zeroed_page(GFP_KERNEL);
> +			if (!buf)
> +				return -ENOMEM;
> +			rc = read_from_oldmem(buf + (start & ~PAGE_MASK), len,
> +					      &paddr, 0);
> +			if (rc < 0) {
> +				free_pages((unsigned long)buf, 0);
> +				return rc;
> +			}
> +
> +			new = get_new_element();
> +			if (!new) {
> +				free_pages((unsigned long)buf, 0);
> +				return -ENOMEM;
> +			}
> +			new->flag |= MEM_TYPE_CURRENT_KERNEL;
> +			new->size = PAGE_SIZE;
> +			new->buf = buf;
> +			list_add_tail(&new->list, vc_list);
> +
> +			rest -= len;
> +		}
> +
> +		if (rest > 0 &&
> +		    roundup(start, PAGE_SIZE) < rounddown(end, PAGE_SIZE)) {
> +			u64 paddr, len;
> +			struct vmcore *new;
> +
> +			paddr = roundup(start, PAGE_SIZE);
> +			len =rounddown(end,PAGE_SIZE)-roundup(start,PAGE_SIZE);
> +
> +			new = get_new_element();
> +			if (!new)
> +				return -ENOMEM;
> +			new->paddr = paddr;
> +			new->size = len;
> +			list_add_tail(&new->list, vc_list);
> +
> +			rest -= len;
> +		}
> +
> +		if (rest > 0) {
> +			u64 paddr, len;
> +			char *buf;
> +			struct vmcore *new;
> +
> +			paddr = rounddown(end, PAGE_SIZE);
> +			len = end - rounddown(end, PAGE_SIZE);
> +
> +			buf = (char *)get_zeroed_page(GFP_KERNEL);
> +			if (!buf)
> +				return -ENOMEM;
> +			rc = read_from_oldmem(buf, len, &paddr, 0);
> +			if (rc < 0) {
> +				free_pages((unsigned long)buf, 0);
> +				return rc;
> +			}
> +
> +			new = get_new_element();
> +			if (!new) {
> +				free_pages((unsigned long)buf, 0);
> +				return -ENOMEM;
> +			}
> +			new->flag |= MEM_TYPE_CURRENT_KERNEL;
> +			new->size = PAGE_SIZE;
> +			new->buf = buf;
> +			list_add_tail(&new->list, vc_list);
> +
> +			rest -= len;
> +		}
>  
>  		/* Update the program header offset */
>  		phdr_ptr->p_offset = vmcore_off;
> -		vmcore_off = vmcore_off + phdr_ptr->p_memsz;
> +		vmcore_off +=roundup(end,PAGE_SIZE)-rounddown(start,PAGE_SIZE);
>  	}
>  	return 0;
>  }
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 

