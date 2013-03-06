Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab3CFPv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 10:51:59 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59801 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab3CFPv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 10:51:57 -0500
MIME-Version: 1.0
In-Reply-To: <20130302083616.31252.73787.stgit@localhost6.localdomain6>
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
	<20130302083616.31252.73787.stgit@localhost6.localdomain6>
Date: Wed, 6 Mar 2013 23:51:55 +0800
Message-ID: <CANBD6kHioMc27GzyWT2v_5Pt=0N2-VNFE7RDUuMWajj3J5zsuA@mail.gmail.com>
Subject: Re: [PATCH v2 05/20] vmcore: round up buffer size of ELF headers by PAGE_SIZE
From: Yanfei Zhang <zhangyanfei.yes@gmail.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/2 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>:
> To satisfy mmap() page-size boundary requirement, round up buffer size
> of ELF headers by PAGE_SIZE. The resulting value becomes offset of ELF
      ~~~~~~~~~~~
      ELF header? or ELF program headers?

> note segments and it's assigned in unique PT_NOTE program header
> entry.
>
> Also, some part that assumes past ELF headers' size is replaced by
> this new rounded-up value.

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

>
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
>
>  fs/proc/vmcore.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 1b02d01..c511cf4 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -340,7 +340,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>         phdr.p_flags   = 0;
>         note_off = ehdr_ptr->e_phoff +
>                         (ehdr_ptr->e_phnum - nr_ptnote +1) * sizeof(Elf64_Phdr);
> -       phdr.p_offset  = note_off;
> +       phdr.p_offset  = roundup(note_off, PAGE_SIZE);
>         phdr.p_vaddr   = phdr.p_paddr = 0;
>         phdr.p_filesz  = phdr.p_memsz = phdr_sz;
>         phdr.p_align   = 0;
> @@ -353,6 +353,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>         /* Modify e_phnum to reflect merged headers. */
>         ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
>
> +       *elfsz = roundup(*elfsz, PAGE_SIZE);
>  out:
>         return 0;
>  }
> @@ -449,7 +450,7 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
>         phdr.p_flags   = 0;
>         note_off = ehdr_ptr->e_phoff +
>                         (ehdr_ptr->e_phnum - nr_ptnote +1) * sizeof(Elf32_Phdr);
> -       phdr.p_offset  = note_off;
> +       phdr.p_offset  = roundup(note_off, PAGE_SIZE);
>         phdr.p_vaddr   = phdr.p_paddr = 0;
>         phdr.p_filesz  = phdr.p_memsz = phdr_sz;
>         phdr.p_align   = 0;
> @@ -462,6 +463,7 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
>         /* Modify e_phnum to reflect merged headers. */
>         ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
>
> +       *elfsz = roundup(*elfsz, PAGE_SIZE);
>  out:
>         return 0;
>  }
> @@ -482,9 +484,8 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
>         phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
>
>         /* First program header is PT_NOTE header. */
> -       vmcore_off = ehdr_ptr->e_phoff +
> -                       (ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr) +
> -                       phdr_ptr->p_memsz; /* Note sections */
> +       vmcore_off = phdr_ptr->p_offset + roundup(phdr_ptr->p_memsz,
> +                                                 PAGE_SIZE);
>
>         for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
>                 if (phdr_ptr->p_type != PT_LOAD)
> @@ -519,9 +520,8 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
>         phdr_ptr = (Elf32_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
>
>         /* First program header is PT_NOTE header. */
> -       vmcore_off = ehdr_ptr->e_phoff +
> -                       (ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr) +
> -                       phdr_ptr->p_memsz; /* Note sections */
> +       vmcore_off = phdr_ptr->p_offset + roundup(phdr_ptr->p_memsz,
> +                                                PAGE_SIZE);
>
>         for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
>                 if (phdr_ptr->p_type != PT_LOAD)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
