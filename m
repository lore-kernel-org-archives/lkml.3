Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab3KYWNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:13:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3KYWN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:13:29 -0500
Date: Mon, 25 Nov 2013 14:13:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: <davem@davemloft.net>, <adobriyan@gmail.com>, <d.hatayama@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: also fix proc_reg_get_unmapped_area() for !MMU
 case
Message-Id: <20131125141328.d9da16e10526e2ff1d368f0f@linux-foundation.org>
In-Reply-To: <529387570200007800106C9F@nat28.tlf.novell.com>
References: <529387570200007800106C9F@nat28.tlf.novell.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Nov 2013 16:22:31 +0000 "Jan Beulich" <JBeulich@suse.com> wrote:

> Commit fad1a86e ("procfs: call default get_unmapped_area on MMU-present
> architectures"), as its title says, took care of only the MMU case,
> leaving the !MMU side still in the regressed state (returning -EIO in
> all cases where pde->proc_fops->get_unmapped_area is NULL).

The changelog is rather mystifying unless the reader goes off and finds
the fad1a86e changelog, so let's do that for them by adding this:

>From the fad1a86e changelog:

: Commit c4fe24485729 ("sparc: fix PCI device proc file mmap(2)") added
: proc_reg_get_unmapped_area in proc_reg_file_ops and
: proc_reg_file_ops_no_compat, by which now mmap always returns EIO if
: get_unmapped_area method is not defined for the target procfs file, which
: causes regression of mmap on /proc/vmcore.
: 
: To address this issue, like get_unmapped_area(), call default
: current->mm->get_unmapped_area on MMU-present architectures if
: pde->proc_fops->get_unmapped_area, i.e.  the one in actual file operation
: in the procfs file, is not defined.

> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: David S. Miller <davem@davemloft.net> 

I tagged this with

	Cc: <stable@vger.kernel.org>	[3.12.x]

OK?

> +++ 3.13-rc1-proc-get-unmapped-area/fs/proc/inode.c
> @@ -292,16 +292,19 @@ proc_reg_get_unmapped_area(struct file *
>  {
>  	struct proc_dir_entry *pde = PDE(file_inode(file));
>  	unsigned long rv = -EIO;
> -	unsigned long (*get_area)(struct file *, unsigned long, unsigned long,
> -				  unsigned long, unsigned long) = NULL;
> +
>  	if (use_pde(pde)) {
> +		typeof(proc_reg_get_unmapped_area) *get_area
>  #ifdef CONFIG_MMU
> -		get_area = current->mm->get_unmapped_area;
> +			= pde->proc_fops->get_unmapped_area
> +			  ?: current->mm->get_unmapped_area;
> +#else
> +			= pde->proc_fops->get_unmapped_area;
>  #endif
> -		if (pde->proc_fops->get_unmapped_area)
> -			get_area = pde->proc_fops->get_unmapped_area;
> -		if (get_area)
> -			rv = get_area(file, orig_addr, len, pgoff, flags);
> +
> +		rv = get_area
> +		     ? get_area(file, orig_addr, len, pgoff, flags)
> +		     : orig_addr;
>  		unuse_pde(pde);
>  	}
>  	return rv;

That function has gone from bad to worse :(

How does this version look?

It would be acceptable and beneficial to create a new get_unmapped_area_t.

: static unsigned long
: proc_reg_get_unmapped_area(struct file *file, unsigned long orig_addr,
: 			   unsigned long len, unsigned long pgoff,
: 			   unsigned long flags)
: {
: 	struct proc_dir_entry *pde = PDE(file_inode(file));
: 	unsigned long rv = -EIO;
: 
: 	if (use_pde(pde)) {
: 		typeof(proc_reg_get_unmapped_area) *get_area;
: 
: 		get_area = pde->proc_fops->get_unmapped_area;
: #ifdef CONFIG_MMU
: 		if (!get_area)
: 			get_area = current->mm->get_unmapped_area;
: #endif
: 
: 		if (get_area)
: 			rv = get_area(file, orig_addr, len, pgoff, flags);
: 		else
: 			rv = orig_addr;
: 		unuse_pde(pde);
: 	}
: 	return rv;
: }

--- a/fs/proc/inode.c~procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix
+++ a/fs/proc/inode.c
@@ -294,17 +294,18 @@ proc_reg_get_unmapped_area(struct file *
 	unsigned long rv = -EIO;
 
 	if (use_pde(pde)) {
-		typeof(proc_reg_get_unmapped_area) *get_area
+		typeof(proc_reg_get_unmapped_area) *get_area;
+
+		get_area = pde->proc_fops->get_unmapped_area;
 #ifdef CONFIG_MMU
-			= pde->proc_fops->get_unmapped_area
-			  ?: current->mm->get_unmapped_area;
-#else
-			= pde->proc_fops->get_unmapped_area;
+		if (!get_area)
+			get_area = current->mm->get_unmapped_area;
 #endif
 
-		rv = get_area
-		     ? get_area(file, orig_addr, len, pgoff, flags)
-		     : orig_addr;
+		if (get_area)
+			rv = get_area(file, orig_addr, len, pgoff, flags);
+		else
+			rv = orig_addr;
 		unuse_pde(pde);
 	}
 	return rv;
_

