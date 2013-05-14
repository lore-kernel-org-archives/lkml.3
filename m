Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab3ENQsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:48:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab3ENQsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:48:12 -0400
Date: Tue, 14 May 2013 12:47:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org
Subject: Re: [PATCH v5 7/8] vmcore: calculate vmcore file size from buffer
 size and total size of vmcore objects
Message-ID: <20130514164739.GJ13674@redhat.com>
References: <20130514015622.18697.77191.stgit@localhost6.localdomain6>
 <20130514015746.18697.1089.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514015746.18697.1089.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 10:57:46AM +0900, HATAYAMA Daisuke wrote:
> The previous patches newly added holes before each chunk of memory and
> the holes need to be count in vmcore file size. There are two ways to
> count file size in such a way:
> 
> 1) supporse p as a poitner to the last program header entry with
> PT_LOAD type, then roundup(p->p_offset + p->p_memsz, PAGE_SIZE), or
> 
> 2) calculate sum of size of buffers for ELF header, program headers,
> ELF note segments and objects in vmcore_list.
> 
> Although 1) is more direct and simpler than 2), 2) seems better in
> that it reflects internal object structure of /proc/vmcore. Thus, this
> patch changes get_vmcore_size_elf{64, 32} so that it calculates size
> in the way of 2).
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> 
>  fs/proc/vmcore.c |   40 ++++++++++++++++++----------------------
>  1 files changed, 18 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index eb7ff29..ad6da17 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -210,36 +210,28 @@ static struct vmcore* __init get_new_element(void)
>  	return kzalloc(sizeof(struct vmcore), GFP_KERNEL);
>  }
>  
> -static u64 __init get_vmcore_size_elf64(char *elfptr, size_t elfsz)
> +static u64 __init get_vmcore_size_elf64(size_t elfsz, size_t elfnotesegsz,
> +					struct list_head *vc_list)
>  {
> -	int i;
>  	u64 size;
> -	Elf64_Ehdr *ehdr_ptr;
> -	Elf64_Phdr *phdr_ptr;
> +	struct vmcore *m;
>  
> -	ehdr_ptr = (Elf64_Ehdr *)elfptr;
> -	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr));
> -	size = elfsz;
> -	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
> -		size += phdr_ptr->p_memsz;
> -		phdr_ptr++;
> +	size = elfsz + elfnotesegsz;
> +	list_for_each_entry(m, vc_list, list) {
> +		size += m->size;
>  	}
>  	return size;
>  }
>  
> -static u64 __init get_vmcore_size_elf32(char *elfptr, size_t elfsz)
> +static u64 __init get_vmcore_size_elf32(size_t elfsz, size_t elfnotesegsz,
> +					struct list_head *vc_list)
>  {
> -	int i;
>  	u64 size;
> -	Elf32_Ehdr *ehdr_ptr;
> -	Elf32_Phdr *phdr_ptr;
> +	struct vmcore *m;
>  
> -	ehdr_ptr = (Elf32_Ehdr *)elfptr;
> -	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr));
> -	size = elfsz;
> -	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
> -		size += phdr_ptr->p_memsz;
> -		phdr_ptr++;
> +	size = elfsz + elfnotesegsz;
> +	list_for_each_entry(m, vc_list, list) {
> +		size += m->size;
>  	}
>  	return size;
>  }
> @@ -755,14 +747,18 @@ static int __init parse_crash_elf_headers(void)
>  			return rc;
>  
>  		/* Determine vmcore size. */
> -		vmcore_size = get_vmcore_size_elf64(elfcorebuf, elfcorebuf_sz);
> +		vmcore_size = get_vmcore_size_elf64(elfcorebuf_sz,
> +						    elfnotesegbuf_sz,
> +						    &vmcore_list);
>  	} else if (e_ident[EI_CLASS] == ELFCLASS32) {
>  		rc = parse_crash_elf32_headers();
>  		if (rc)
>  			return rc;
>  
>  		/* Determine vmcore size. */
> -		vmcore_size = get_vmcore_size_elf32(elfcorebuf, elfcorebuf_sz);
> +		vmcore_size = get_vmcore_size_elf32(elfcorebuf_sz,
> +						    elfnotesegbuf_sz,
> +						    &vmcore_list);
>  	} else {
>  		pr_warn("Warning: Core image elf header is not sane\n");
>  		return -EINVAL;
