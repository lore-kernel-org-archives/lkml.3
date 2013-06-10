Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab3FJNg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:36:59 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:44809 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab3FJNg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:36:58 -0400
MIME-Version: 1.0
In-Reply-To: <1370624161-2298-3-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1370624161-2298-3-git-send-email-holzheu@linux.vnet.ibm.com>
Date: Mon, 10 Jun 2013 22:36:57 +0900
Message-ID: <CABOkKT13E-nkhu1j06OPqR2dMiK6WbTMp2rPj4mzom_+uDBziQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/5] s390/vmcore: Use ELF header in new memory feature
From: HATAYAMA Daisuke <d.hatayama@gmail.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/8 Michael Holzheu <holzheu@linux.vnet.ibm.com>:
<cut>
> @@ -417,27 +416,44 @@ static void s390_elf_corehdr_create(char **elfcorebuf, size_t *elfcorebuf_sz)
>         ptr = notes_init(phdr_notes, ptr, ((unsigned long) hdr) + hdr_off);
>         /* Init loads */
>         hdr_off = PTR_DIFF(ptr, hdr);
> -       loads_init(phdr_loads, ((unsigned long) hdr) + hdr_off);
> -       *elfcorebuf_sz = hdr_off;
> -       *elfcorebuf = (void *) relocate((unsigned long) hdr);
> -       BUG_ON(*elfcorebuf_sz > alloc_size);
> +       loads_init(phdr_loads, hdr_off);
> +       elfcorehdr_addr = (unsigned long long) hdr;
> +       elfcorehdr_size = (unsigned long long) hdr_off;
> +       elfcorehdr_newmem = hdr;
> +       BUG_ON(elfcorehdr_size > alloc_size);
> +       return 0;
>  }
>
>  /*
> - * Create kdump ELF core header in new kernel, if it has not been passed via
> - * the "elfcorehdr" kernel parameter
> + * Free ELF core header (new kernel)
>   */
> -static int setup_kdump_elfcorehdr(void)
> +void elfcorehdr_free(void)
>  {
> -       size_t elfcorebuf_sz;
> -       char *elfcorebuf;
> -
> -       if (!OLDMEM_BASE || is_kdump_kernel())
> -               return -EINVAL;
> -       s390_elf_corehdr_create(&elfcorebuf, &elfcorebuf_sz);
> -       elfcorehdr_addr = (unsigned long long) elfcorebuf;
> -       elfcorehdr_size = elfcorebuf_sz;
> -       return 0;
> +       if (!elfcorehdr_newmem)
> +               return;
> +       vfree(elfcorehdr_newmem);

kfree is correct here?

Thanks.
HATAYAMA, Daisuke
