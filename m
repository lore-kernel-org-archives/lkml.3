Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaBENjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:39:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbaBENjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:39:18 -0500
Date: Wed, 5 Feb 2014 08:39:12 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Greg Pearson <greg.pearson@hp.com>
Cc: akpm@linux-foundation.org, d.hatayama@jp.fujitsu.com,
        holzheu@linux.vnet.ibm.com, dhowells@redhat.com,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vmcore: prevent PT_NOTE p_memsz overflow during
 header update
Message-ID: <20140205133912.GC6042@redhat.com>
References: <1391556352-15881-1-git-send-email-greg.pearson@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391556352-15881-1-git-send-email-greg.pearson@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 04:25:52PM -0700, Greg Pearson wrote:

[..]
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 2ca7ba0..88d4585 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -468,17 +468,24 @@ static int __init update_note_header_size_elf64(const Elf64_Ehdr *ehdr_ptr)
>  			return rc;
>  		}
>  		nhdr_ptr = notes_section;
> -		while (real_sz < max_sz) {
> -			if (nhdr_ptr->n_namesz == 0)
> -				break;
> +		while (nhdr_ptr->n_namesz != 0) {
>  			sz = sizeof(Elf64_Nhdr) +
>  				((nhdr_ptr->n_namesz + 3) & ~3) +
>  				((nhdr_ptr->n_descsz + 3) & ~3);
> +			if ((real_sz + sz) > max_sz) {
> +				pr_warn("Warning: Exceeded p_memsz, dropping PT_NOTE entry n_namesz=0x%x, n_descsz=0x%x\n",
> +					nhdr_ptr->n_namesz, nhdr_ptr->n_descsz);

You will need line break in pr_warn(). Too long a line. Limit it 80
columns per line.

> +				break;
> +			}
>  			real_sz += sz;
>  			nhdr_ptr = (Elf64_Nhdr*)((char*)nhdr_ptr + sz);
>  		}
>  		kfree(notes_section);
>  		phdr_ptr->p_memsz = real_sz;
> +		if (real_sz == 0) {
> +			pr_warn("Warning: Zero PT_NOTE entries found\n");
> +			return -EINVAL;

Given the fact that this is the first time I have heard about a PT_NOTE
being corrup, I will be fine with this patch too. If one encounters
an empty PT_NOTE, error out and don't create vmcore.

So please repost this patch with line lenght fixed.

Thanks
Vivek
