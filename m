Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaFZDzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 23:55:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48419 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaFZDzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 23:55:11 -0400
Date: Wed, 25 Jun 2014 20:53:52 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Konstantin Khlebnikov <koct9i@gmail.com>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] shmem: update memory reservation on truncate
In-Reply-To: <20140624201610.18273.93645.stgit@zurg>
Message-ID: <alpine.LSU.2.11.1406252044420.30620@eggly.anvils>
References: <20140624201606.18273.44270.stgit@zurg> <20140624201610.18273.93645.stgit@zurg>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, Konstantin Khlebnikov wrote:

> Shared anonymous mapping created without MAP_NORESERVE holds memory
> reservation for whole range of shmem segment. Usually there is no way to
> change its size, but /proc/<pid>/map_files/...
> (available if CONFIG_CHECKPOINT_RESTORE=y) allows to do that.
> 
> This patch adjust memory reservation in shmem_setattr().
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>

Acked-by: Hugh Dickins <hughd@google.com>

Thank you, I knew nothing about this backdoor to shmem objects.  Scary.
Was this really the only problem map_files access leads to?  If you
did not do so already, please try to think through other possibilities.

I haven't begun, but perhaps it's not so bad.  I guess the interaction
with mremap extension is benign - it's annoyed people in the past that
the underlying shmem object is not extended, but now here's a way that
it can be. 

(I'll leave it to others comment on 3/3 if they wish.)

> 
> ---
> 
> exploit:
> 
> #include <sys/mman.h>
> #include <unistd.h>
> #include <stdio.h>
> 
> int main(int argc, char **argv)
> {
> 	unsigned long addr;
> 	char path[100];
> 
> 	/* charge 4KiB */
> 	addr = (unsigned long)mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0);
> 	sprintf(path, "/proc/self/map_files/%lx-%lx", addr, addr + 4096);
> 	truncate(path, 1 << 30);
> 	/* uncharge 1GiB */
> }
> ---
>  mm/shmem.c |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 0aabcbd..a3c49d6 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -149,6 +149,19 @@ static inline void shmem_unacct_size(unsigned long flags, loff_t size)
>  		vm_unacct_memory(VM_ACCT(size));
>  }
>  
> +static inline int shmem_reacct_size(unsigned long flags,
> +		loff_t oldsize, loff_t newsize)
> +{
> +	if (!(flags & VM_NORESERVE)) {
> +		if (VM_ACCT(newsize) > VM_ACCT(oldsize))
> +			return security_vm_enough_memory_mm(current->mm,
> +					VM_ACCT(newsize) - VM_ACCT(oldsize));
> +		else if (VM_ACCT(newsize) < VM_ACCT(oldsize))
> +			vm_unacct_memory(VM_ACCT(oldsize) - VM_ACCT(newsize));
> +	}
> +	return 0;
> +}
> +
>  /*
>   * ... whereas tmpfs objects are accounted incrementally as
>   * pages are allocated, in order to allow huge sparse files.
> @@ -543,6 +556,10 @@ static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
>  		loff_t newsize = attr->ia_size;
>  
>  		if (newsize != oldsize) {
> +			error = shmem_reacct_size(SHMEM_I(inode)->flags,
> +					oldsize, newsize);
> +			if (error)
> +				return error;
>  			i_size_write(inode, newsize);
>  			inode->i_ctime = inode->i_mtime = CURRENT_TIME;
>  		}
> 
> 
