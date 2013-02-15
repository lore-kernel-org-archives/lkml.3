Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935802Ab3BOPTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:19:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933005Ab3BOPTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:19:35 -0500
Date: Fri, 15 Feb 2013 10:18:21 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/13] vmcore: round up buffer size of ELF headers by
 PAGE_SIZE
Message-ID: <20130215151821.GB27784@redhat.com>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
 <20130214101154.22466.21769.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214101154.22466.21769.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 07:11:54PM +0900, HATAYAMA Daisuke wrote:
> To satisfy mmap() page-size boundary requirement, reound up buffer
> size of ELF headers by PAGE_SIZE. The resulting value becomes offset
> of ELF note segments and it's assigned in unique PT_NOTE program
> header entry.
> 
> Also, some part that assumes past ELF headers' size is replaced by
> this new rounded-up value.
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
> 
>  fs/proc/vmcore.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 85714c3..5010ead 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -313,7 +313,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>  	phdr.p_flags   = 0;
>  	note_off = sizeof(Elf64_Ehdr) +
>  			(ehdr_ptr->e_phnum - nr_ptnote +1) * sizeof(Elf64_Phdr);
> -	phdr.p_offset  = note_off;
> +	phdr.p_offset  = roundup(note_off, PAGE_SIZE);
>  	phdr.p_vaddr   = phdr.p_paddr = 0;
>  	phdr.p_filesz  = phdr.p_memsz = phdr_sz;
>  	phdr.p_align   = 0;
> @@ -331,6 +331,8 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>  	/* Modify e_phnum to reflect merged headers. */
>  	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
>  

Hi Hatayama,

While reading the /proc/vmcore code again, I realized that we are making
a horrible assumption. And that is that all PT_NOTE program headers
prepared by kexec-tools are contiguous. And we also seem to be assuming
that all PT_NOTE phdrs are following immediately Elf Header.

        /* Add merged PT_NOTE program header*/
        tmp = elfptr + sizeof(Elf64_Ehdr);
        memcpy(tmp, &phdr, sizeof(phdr));
        tmp += sizeof(phdr);

        /* Remove unwanted PT_NOTE program headers. */
        i = (nr_ptnote - 1) * sizeof(Elf64_Phdr);
        *elfsz = *elfsz - i;
        memmove(tmp, tmp+i, ((*elfsz)-sizeof(Elf64_Ehdr)-sizeof(Elf64_Phdr)));

I know I wrote this code but now I realize that this is very bad
assumption. We should not be assuming where PT_NOTE headers are and
also should not be assuming that these are contiguous.

This will require fixing. I think we just need to read old elf headers
in a buffer and prepare new headers (merged one) in a separate buffer
instead of trying to make do with single buffer.

If it is not too much of trouble, can you please do this cleanup and
rebase your patches on top of it.

Thanks
Vivek
