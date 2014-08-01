Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaHAFFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 01:05:34 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45767 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaHAFFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 01:05:32 -0400
Date: Thu, 31 Jul 2014 22:03:52 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jerome Marchand <jmarchan@redhat.com>
cc: Oleg Nesterov <oleg@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-doc@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux390@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 3/5] mm, shmem: Add shmem_vma() helper
In-Reply-To: <1406036632-26552-4-git-send-email-jmarchan@redhat.com>
Message-ID: <alpine.LSU.2.11.1407312202040.3912@eggly.anvils>
References: <1406036632-26552-1-git-send-email-jmarchan@redhat.com> <1406036632-26552-4-git-send-email-jmarchan@redhat.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Jerome Marchand wrote:

> Add a simple helper to check if a vm area belongs to shmem.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  include/linux/mm.h | 6 ++++++
>  mm/shmem.c         | 8 ++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 34099fa..04a58d1 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1074,11 +1074,17 @@ int shmem_zero_setup(struct vm_area_struct *);
>  
>  extern int shmem_locate(struct vm_area_struct *vma, pgoff_t pgoff, int *count);
>  bool shmem_mapping(struct address_space *mapping);
> +bool shmem_vma(struct vm_area_struct *vma);
> +
>  #else
>  static inline bool shmem_mapping(struct address_space *mapping)
>  {
>  	return false;
>  }
> +static inline bool shmem_vma(struct vm_area_struct *vma)
> +{
> +	return false;
> +}
>  #endif

I would prefer include/linux/shmem_fs.h for this (and one of us clean
up where the declarations of shmem_zero_setup and shmem_mapping live).

But if 4/5 goes away, then there will only be one user of shmem_vma(),
so in that case better just declare it (using shmem_mapping()) there
in task_mmu.c in the smaps patch.

>  
>  extern int can_do_mlock(void);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 8aa4892..7d16227 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1483,6 +1483,14 @@ bool shmem_mapping(struct address_space *mapping)
>  	return mapping->backing_dev_info == &shmem_backing_dev_info;
>  }
>  
> +bool shmem_vma(struct vm_area_struct *vma)
> +{
> +	return (vma->vm_file &&
> +		vma->vm_file->f_dentry->d_inode->i_mapping->backing_dev_info
> +		== &shmem_backing_dev_info);
> +

I agree with Oleg,
	vma->vm_file && shmem_mapping(file_inode(vma->vm_file)->i_mapping);
would be better,

Hugh
