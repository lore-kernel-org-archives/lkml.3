Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab3E3O6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:58:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757404Ab3E3O6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:58:03 -0400
Date: Thu, 30 May 2013 10:57:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v4 2/3] s390/kdump: Use ELF header in new memory feature
Message-ID: <20130530145732.GA5724@redhat.com>
References: <1369394983-65360-1-git-send-email-holzheu@linux.vnet.ibm.com>
 <1369394983-65360-3-git-send-email-holzheu@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369394983-65360-3-git-send-email-holzheu@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 01:29:42PM +0200, Michael Holzheu wrote:
> This patch now exchanges the old relocate mechanism with the new
> arch function call override mechanism that allows to create the ELF
> core header in the 2nd kernel.
> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> ---
>  arch/s390/kernel/crash_dump.c | 64 ++++++++++++++++++++++++++++++-------------
>  1 file changed, 45 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
> index f703d91..aeb1207 100644
> --- a/arch/s390/kernel/crash_dump.c
> +++ b/arch/s390/kernel/crash_dump.c
> @@ -21,6 +21,9 @@
>  #define PTR_SUB(x, y) (((char *) (x)) - ((unsigned long) (y)))
>  #define PTR_DIFF(x, y) ((unsigned long)(((char *) (x)) - ((unsigned long) (y))))
>  
> +static size_t elfcorebuf_sz;
> +static char *elfcorebuf;
> +
>  /*
>   * Copy one page from "oldmem"
>   *
> @@ -325,14 +328,6 @@ static int get_mem_chunk_cnt(void)
>  }
>  
>  /*
> - * Relocate pointer in order to allow vmcore code access the data
> - */
> -static inline unsigned long relocate(unsigned long addr)
> -{
> -	return OLDMEM_BASE + addr;
> -}
> -
> -/*
>   * Initialize ELF loads (new kernel)
>   */
>  static int loads_init(Elf64_Phdr *phdr, u64 loads_offset)
> @@ -383,7 +378,7 @@ static void *notes_init(Elf64_Phdr *phdr, void *ptr, u64 notes_offset)
>  	ptr = nt_vmcoreinfo(ptr);
>  	memset(phdr, 0, sizeof(*phdr));
>  	phdr->p_type = PT_NOTE;
> -	phdr->p_offset = relocate(notes_offset);
> +	phdr->p_offset = notes_offset;
>  	phdr->p_filesz = (unsigned long) PTR_SUB(ptr, ptr_start);
>  	phdr->p_memsz = phdr->p_filesz;
>  	return ptr;
> @@ -392,7 +387,7 @@ static void *notes_init(Elf64_Phdr *phdr, void *ptr, u64 notes_offset)
>  /*
>   * Create ELF core header (new kernel)
>   */
> -static void s390_elf_corehdr_create(char **elfcorebuf, size_t *elfcorebuf_sz)
> +static int s390_elf_corehdr_create(char **elfcorebuf, size_t *elfcorebuf_sz)
>  {
>  	Elf64_Phdr *phdr_notes, *phdr_loads;
>  	int mem_chunk_cnt;
> @@ -414,28 +409,59 @@ static void s390_elf_corehdr_create(char **elfcorebuf, size_t *elfcorebuf_sz)
>  	ptr = PTR_ADD(ptr, sizeof(Elf64_Phdr) * mem_chunk_cnt);
>  	/* Init notes */
>  	hdr_off = PTR_DIFF(ptr, hdr);
> -	ptr = notes_init(phdr_notes, ptr, ((unsigned long) hdr) + hdr_off);
> +	ptr = notes_init(phdr_notes, ptr, (unsigned long) hdr + hdr_off);
>  	/* Init loads */
>  	hdr_off = PTR_DIFF(ptr, hdr);
> -	loads_init(phdr_loads, ((unsigned long) hdr) + hdr_off);
> +	loads_init(phdr_loads, hdr_off);
>  	*elfcorebuf_sz = hdr_off;
> -	*elfcorebuf = (void *) relocate((unsigned long) hdr);
> +	*elfcorebuf = hdr;
>  	BUG_ON(*elfcorebuf_sz > alloc_size);
> +	return 0;
>  }
>  
>  /*
> - * Create kdump ELF core header in new kernel, if it has not been passed via
> - * the "elfcorehdr" kernel parameter
> + * Return address of ELF core header (new or old memory)
>   */
> -static int setup_kdump_elfcorehdr(void)
> +unsigned long long arch_get_crash_header(void)
>  {
> -	size_t elfcorebuf_sz;
> -	char *elfcorebuf;
> +	if (elfcorebuf)
> +		return elfcorehdr_addr;
> +	else
> +		return __pa(elfcorebuf);
> +}
>  
> +/*
> + * Free crash header
> + */
> +void arch_free_crash_header(void)
> +{
> +	kfree(elfcorebuf);
> +	elfcorebuf = 0;
> +}
> +
> +/*
> + * Read from crash header (new or old memory)
> + */
> +ssize_t arch_read_from_crash_header(char *buf, size_t count, u64 *ppos)
> +{
> +	if (elfcorebuf)
> +		memcpy(buf, (void *)*ppos, count);

This is ugly. It assumes that generic code will always free headers before
reading any PT_LOAD data. It can be easily broken.

Why arch_read_from_crash_header() should not always read new memory for
s390? 

Vivek
