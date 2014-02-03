Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaBCVin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:38:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbaBCViV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:38:21 -0500
Date: Mon, 3 Feb 2014 16:38:13 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Greg Pearson <greg.pearson@hp.com>
Cc: akpm@linux-foundation.org, d.hatayama@jp.fujitsu.com,
        holzheu@linux.vnet.ibm.com, dhowells@redhat.com,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vmcore: prevent PT_NOTE p_memsz overflow during
 header update
Message-ID: <20140203213813.GH10795@redhat.com>
References: <1391458718-11994-1-git-send-email-greg.pearson@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391458718-11994-1-git-send-email-greg.pearson@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 01:18:38PM -0700, Greg Pearson wrote:

[..]
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 2ca7ba0..051c803 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -468,12 +468,14 @@ static int __init update_note_header_size_elf64(const Elf64_Ehdr *ehdr_ptr)
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
> +				pr_warn("Warning: dropping PT_NOTE entry\n");
> +				break;
> +			}

Hi Greg,

Couple of minor nits.

I think it is a good idea to give more data in warning which tells why
are we dropping a note entry. May be something like.

"Warning: Total note entry size exceeded PT_NOTE memsz. Dropping PT_NOTE entry, n_namesz=<> n_descsz=<>".

Secondly, if there is only on note entry in a PT_NOTE header and we drop
it, then that PT_NOTE header is empty and needs to be cleaned up.

I think you will have to modify get_note_number_and_size_elf64() and
other relevant functions which are not expecting ->p_memsz=0.

Thanks
Vivek
