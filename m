Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaFZDpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 23:45:54 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:58464 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbaFZDpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 23:45:53 -0400
Date: Wed, 25 Jun 2014 20:44:28 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Konstantin Khlebnikov <koct9i@gmail.com>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] shmem: fix double uncharge in __shmem_file_setup()
In-Reply-To: <20140624201606.18273.44270.stgit@zurg>
Message-ID: <alpine.LSU.2.11.1406252039290.30620@eggly.anvils>
References: <20140624201606.18273.44270.stgit@zurg>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, Konstantin Khlebnikov wrote:

> If __shmem_file_setup() fails on struct file allocation it uncharges memory
> commitment twice: first by shmem_unacct_size() and second time implicitly in
> shmem_evict_inode() when it kills newly created inode.
> This patch removes shmem_unacct_size() from error path if inode already here.
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>

Acked-by: Hugh Dickins <hughd@google.com>

Thank you for the patch, and thank you for your patience (or perhaps for
your kindly concealed impatience): I realize that this (and the other two)
have been languishing in the must-get-to-look-at-it-sometime end of my
mailbox for nine months now - sorry.

> ---
>  mm/shmem.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 8f419cf..0aabcbd 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2895,16 +2895,16 @@ static struct file *__shmem_file_setup(const char *name, loff_t size,
>  	this.len = strlen(name);
>  	this.hash = 0; /* will go */
>  	sb = shm_mnt->mnt_sb;
> +	path.mnt = mntget(shm_mnt);
>  	path.dentry = d_alloc_pseudo(sb, &this);
>  	if (!path.dentry)
>  		goto put_memory;
>  	d_set_d_op(path.dentry, &anon_ops);
> -	path.mnt = mntget(shm_mnt);
>  
>  	res = ERR_PTR(-ENOSPC);
>  	inode = shmem_get_inode(sb, NULL, S_IFREG | S_IRWXUGO, 0, flags);
>  	if (!inode)
> -		goto put_dentry;
> +		goto put_memory;
>  
>  	inode->i_flags |= i_flags;
>  	d_instantiate(path.dentry, inode);
> @@ -2912,19 +2912,19 @@ static struct file *__shmem_file_setup(const char *name, loff_t size,
>  	clear_nlink(inode);	/* It is unlinked */
>  	res = ERR_PTR(ramfs_nommu_expand_for_mapping(inode, size));
>  	if (IS_ERR(res))
> -		goto put_dentry;
> +		goto put_path;
>  
>  	res = alloc_file(&path, FMODE_WRITE | FMODE_READ,
>  		  &shmem_file_operations);
>  	if (IS_ERR(res))
> -		goto put_dentry;
> +		goto put_path;
>  
>  	return res;
>  
> -put_dentry:
> -	path_put(&path);
>  put_memory:
>  	shmem_unacct_size(flags, size);
> +put_path:
> +	path_put(&path);
>  	return res;
>  }
>  
