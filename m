Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaKDWUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:20:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaKDWU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:20:27 -0500
Date: Tue, 4 Nov 2014 14:20:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH] mm: fix overly aggressive shmdt() when calls span
 multiple segments
Message-Id: <20141104142027.a7a0d010772d84560b445f59@linux-foundation.org>
In-Reply-To: <20141104000633.F35632C6@viggo.jf.intel.com>
References: <20141104000633.F35632C6@viggo.jf.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2014 16:06:33 -0800 Dave Hansen <dave@sr71.net> wrote:

> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This is a highly-contrived scenario.  But, a single shmdt() call
> can be induced in to unmapping memory from mulitple shm segments.
> Example code is here:
> 
> 	http://www.sr71.net/~dave/intel/shmfun.c

Could be preserved in tools/testing/selftests/ipc/

> The fix is pretty simple:  Record the 'struct file' for the first
> VMA we encounter and then stick to it.  Decline to unmap anything
> not from the same file and thus the same segment.
> 
> I found this by inspection and the odds of anyone hitting this in
> practice are pretty darn small.
> 
> Lightly tested, but it's a pretty small patch.
> 
> ...
>
> --- a/ipc/shm.c~mm-shmdt-fix-over-aggressive-unmap	2014-11-03 14:32:09.479595152 -0800
> +++ b/ipc/shm.c	2014-11-03 16:04:28.340225666 -0800
> @@ -1229,6 +1229,7 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
>  	int retval = -EINVAL;
>  #ifdef CONFIG_MMU
>  	loff_t size = 0;
> +	struct file *file;
>  	struct vm_area_struct *next;
>  #endif
>  
> @@ -1245,7 +1246,8 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
>  	 *   started at address shmaddr. It records it's size and then unmaps
>  	 *   it.
>  	 * - Then it unmaps all shm vmas that started at shmaddr and that
> -	 *   are within the initially determined size.
> +	 *   are within the initially determined size and that are from the
> +	 *   same shm segment from which we determined the size.
>  	 * Errors from do_munmap are ignored: the function only fails if
>  	 * it's called with invalid parameters or if it's called to unmap
>  	 * a part of a vma. Both calls in this function are for full vmas,
> @@ -1271,8 +1273,14 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
>  		if ((vma->vm_ops == &shm_vm_ops) &&
>  			(vma->vm_start - addr)/PAGE_SIZE == vma->vm_pgoff) {
>  
> -
> -			size = file_inode(vma->vm_file)->i_size;
> +			/*
> +			 * Record the file of the shm segment being
> +			 * unmapped.  With mremap(), someone could place
> +			 * page from another segment but with equal offsets
> +			 * in the range we are unmapping.
> +			 */
> +			file = vma->vm_file;
> +			size = file_inode(file)->i_size;

Maybe we should have used i_size_read() here.  I don't think i_mutex is
held?

>  			do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
>  			/*
>  			 * We discovered the size of the shm segment, so

