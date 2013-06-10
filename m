Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3FJKAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:00:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:35698 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab3FJKAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:00:30 -0400
X-IronPort-AV: E=Sophos;i="4.87,836,1363104000"; 
   d="scan'208";a="7513157"
Message-ID: <51B596B3.8050005@cn.fujitsu.com>
Date: Mon, 10 Jun 2013 17:04:51 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmcore: disable mmap_vmcore() if CONFIG_MMU is not defined
References: <51B593C3.7030609@jp.fujitsu.com>
In-Reply-To: <51B593C3.7030609@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/10 17:05:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/10 17:06:09,
	Serialize complete at 2013/06/10 17:06:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 04:52 PM, HATAYAMA Daisuke wrote:
> Hello,
> 
> This patch fixes the issue reported by Amd on an overlook of no-MMU configuration.
> 
> This patch is made on top of v3.10-rc4-mmotm-2013-06-06-16-19.
> 
> I tested this on x86_64 and x86 with 1GB and 5GB memory.
> 
> I build this on arm without CONFIG_MMU configuration.
> 
> Thanks.
> HATAYAMA, Daisuke
> 
>>From e2f067a497872a9c60002c56ea550e4600072166 Mon Sep 17 00:00:00 2001
> From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> Date: Sat, 8 Jun 2013 20:46:57 +0900
> Subject: [PATCH] vmcore: disable mmap_vmcore() if CONFIG_MMU is not defined
> 
>>From Amd's report of a link-time build error in vmcore.c, it turned
> out that mmap_vmcore() work overlooked no-MMU configuraiton.
> 
> In the current design, it's impossible to implement mmap_vmcore() for
> no-MMU configuration since MMU is essential in order to map physically
> non-contiguous objects (ELF header, ELF note segment and memory
> regions in the 1st kernel pointed to by PT_LOAD entries) into
> virtually contiguous user-space in ELF layout.
> 
> Hence, this patch disables mmap_vmcore() if CONFIG_MMU is not defined,
> returning -ENOSYS.
> 
> Another change is to fix the build error by using vmalloc_user()

Yeah, I think this change makes code more clear by hiding vmcore-irrelevant
details.

> instead of calling vzalloc() and find_vm_area() in order, by which we
> no longer need to call find_vm_area() in vmcore.c that has no
> counterpart on non-MMU configuration.
> 
> Also, on no-MMU configuration, because we don't export buffer for ELF
> note segment to user-space, we use vzalloc() to allocate the buffer.
> Therefore, we use differnet functions to allocate the buffer for ELF
> note segment. To avoid code duplication, introduce a helper
> alloc_elfnotes_buf().
> 
> Reported-by: Amd Bergmann <arnd@arndb.de>
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
>  fs/proc/vmcore.c |   57 +++++++++++++++++++++++++++++++++++------------------
>  1 files changed, 37 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 0f6db52..2850317 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -195,6 +195,35 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
>  	return acc;
>  }
>  
> +/**
> + * alloc_elfnotes_buf - allocate buffer for ELF note segment in
> + *                      vmalloc memory
> + *
> + * @notes_sz: size of buffer
> + *
> + * If CONFIG_MMU is defined, use vmalloc_user() to allow users to mmap
> + * the buffer to user-space by means of remap_vmalloc_range().
> + *
> + * If CONFIG_MMU is not defined, use vzalloc() since mmap_vmcore() is
> + * disabled and there's no need to allow users to mmap the buffer.
> + */
> +static inline char *alloc_elfnotes_buf(size_t notes_sz)
> +{
> +#ifdef CONFIG_MMU
> +	return vmalloc_user(notes_sz);
> +#else
> +	return vzalloc(notes_sz);
> +#endif
> +}
> +
> +/*
> + * Disable mmap_vmcore() if CONFIG_MMU is not defined. MMU is
> + * essential for mmap_vmcore() in order to map physically
> + * non-contiguous objects (ELF header, ELF note segment and memory
> + * regions in the 1st kernel pointed to by PT_LOAD entries) into
> + * virtually contiguous user-space in ELF layout.
> + */
> +#ifdef CONFIG_MMU
>  static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
>  {
>  	size_t size = vma->vm_end - vma->vm_start;
> @@ -271,6 +300,12 @@ fail:
>  	do_munmap(vma->vm_mm, vma->vm_start, len);
>  	return -EAGAIN;
>  }
> +#else
> +static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
> +{
> +	return -ENOSYS;
> +}
> +#endif
>  
>  static const struct file_operations proc_vmcore_operations = {
>  	.read		= read_vmcore,
> @@ -427,7 +462,6 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>  	Elf64_Ehdr *ehdr_ptr;
>  	Elf64_Phdr phdr;
>  	u64 phdr_sz = 0, note_off;
> -	struct vm_struct *vm;
>  
>  	ehdr_ptr = (Elf64_Ehdr *)elfptr;
>  
> @@ -440,18 +474,10 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>  		return rc;
>  
>  	*notes_sz = roundup(phdr_sz, PAGE_SIZE);
> -	*notes_buf = vzalloc(*notes_sz);
> +	*notes_buf = alloc_elfnotes_buf(*notes_sz);
>  	if (!*notes_buf)
>  		return -ENOMEM;
>  
> -	/*
> -	 * Allow users to remap ELF note segment buffer on vmalloc memory using
> -	 * remap_vmalloc_range.()
> -	 */
> -	vm = find_vm_area(*notes_buf);
> -	BUG_ON(!vm);
> -	vm->flags |= VM_USERMAP;
> -
>  	rc = copy_notes_elf64(ehdr_ptr, *notes_buf);
>  	if (rc < 0)
>  		return rc;
> @@ -615,7 +641,6 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
>  	Elf32_Ehdr *ehdr_ptr;
>  	Elf32_Phdr phdr;
>  	u64 phdr_sz = 0, note_off;
> -	struct vm_struct *vm;
>  
>  	ehdr_ptr = (Elf32_Ehdr *)elfptr;
>  
> @@ -628,18 +653,10 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
>  		return rc;
>  
>  	*notes_sz = roundup(phdr_sz, PAGE_SIZE);
> -	*notes_buf = vzalloc(*notes_sz);
> +	*notes_buf = alloc_elfnotes_buf(*notes_sz);
>  	if (!*notes_buf)
>  		return -ENOMEM;
>  
> -	/*
> -	 * Allow users to remap ELF note segment buffer on vmalloc memory using
> -	 * remap_vmalloc_range()
> -	 */
> -	vm = find_vm_area(*notes_buf);
> -	BUG_ON(!vm);
> -	vm->flags |= VM_USERMAP;
> -
>  	rc = copy_notes_elf32(ehdr_ptr, *notes_buf);
>  	if (rc < 0)
>  		return rc;


-- 
Thanks.
Zhang Yanfei
