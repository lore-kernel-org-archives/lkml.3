Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbaAaXOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 18:14:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129AbaAaXOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 18:14:18 -0500
Date: Fri, 31 Jan 2014 15:14:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Pearson <greg.pearson@hp.com>
Cc: vgoyal@redhat.com, d.hatayama@jp.fujitsu.com, holzheu@linux.vnet.ibm.com,
        dhowells@redhat.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vmcore: prevent PT_NOTE p_memsz overflow during header
 update
Message-Id: <20140131151417.b770ca3c1913938ab6b43292@linux-foundation.org>
In-Reply-To: <1391209566-4734-1-git-send-email-greg.pearson@hp.com>
References: <1391209566-4734-1-git-send-email-greg.pearson@hp.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014 16:06:06 -0700 Greg Pearson <greg.pearson@hp.com> wrote:

> Currently, update_note_header_size_elf64() and
> update_note_header_size_elf32() will add the size
> of a PT_NOTE entry to real_sz even if that causes real_sz
> to exceeds max_sz. This patch corrects the while loop logic
> in those routines to ensure that does not happen.
> 
> One possible negative side effect of exceeding the max_sz
> limit is an allocation failure in merge_note_headers_elf64()
> or merge_note_headers_elf32() which would produce console
> output such as the following while booting the crash
> kernel.
> 
> ...
>
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -468,12 +468,13 @@ static int __init update_note_header_size_elf64(const Elf64_Ehdr *ehdr_ptr)
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
> +			/* Silently drop further PT_NOTE entries */
> +			if ((real_sz + sz) > max_sz)
> +				break;

What are the implications of silently dropping some notes?  Should we
warn when it occurs?

>  			real_sz += sz;
>  			nhdr_ptr = (Elf64_Nhdr*)((char*)nhdr_ptr + sz);
>  		}

