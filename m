Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaKYVi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:38:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaKYVi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:38:58 -0500
Date: Tue, 25 Nov 2014 13:38:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jungseung Lee <js07.lee@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] fs/binfmt_elf.c: fix inconsistent vma dump size
Message-Id: <20141125133857.bb2d71659287df6aa908de5b@linux-foundation.org>
In-Reply-To: <1416683799-678-1-git-send-email-js07.lee@gmail.com>
References: <1416683799-678-1-git-send-email-js07.lee@gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2014 04:16:39 +0900 Jungseung Lee <js07.lee@gmail.com> wrote:

> vma_dump_size() has been used several times on actual dumper
> and it is supposed to be same values for same vma.
> But vma_dump_size() could be different, while coredump is procceeded.
> (e.g. remove shared memory)
> 
> In that case, header info and vma size could be inconsistent
> and it cause wrong coredump file creation.
> 
> Fix the problem by always using the same vma dump size
> which is stored in vma_filsz.

So concurrent shared memory removal causes inconsistencies.

But concurrent shared memory removal can still cause inconsistency
after this patch, can't it?  If it happens while vma_filesz[] is being
populated or if it happens between vma_filesz[] population and
vma_filesz[] usage.  This will result in a dump file which is
internally consistent, but is inconsistent with reality?

If my understanding is correct then please fully describe this scenario
within the changelog and explain why it is tolerable, if it is
tolerable.

> @@ -2093,7 +2083,20 @@ static int elf_core_dump(struct coredump_params *cprm)
>  
>  	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
>  
> -	offset += elf_core_vma_data_size(gate_vma, cprm->mm_flags);
> +	vma_filesz = kmalloc(sizeof(*vma_filesz) * (segs - 1), GFP_KERNEL);

Use kmalloc_array() here, in case a disaster has occurred...

> +	if (!vma_filesz)
> +		goto end_coredump;
> +
> +	for (i = 0, vma = first_vma(current, gate_vma); vma != NULL;
> +			vma = next_vma(vma, gate_vma)) {
> +		unsigned long dump_size;
> +
> +		dump_size = vma_dump_size(vma, cprm->mm_flags);
> +		vma_filesz[i++] = dump_size;
> +		vma_data_size += dump_size;
> +	}
> +
> +	offset += vma_data_size;

