Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab3EPQvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:51:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761Ab3EPQvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:51:43 -0400
Date: Thu, 16 May 2013 12:51:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH v6 2/8] vmcore: allocate buffer for ELF headers on
 page-size alignment
Message-ID: <20130516165105.GB8726@redhat.com>
References: <20130515090507.28109.28956.stgit@localhost6.localdomain6>
 <20130515090551.28109.73350.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515090551.28109.73350.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 06:05:51PM +0900, HATAYAMA Daisuke wrote:

[..]
> @@ -398,9 +403,7 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
>  	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr)); /* PT_NOTE hdr */
>  
>  	/* First program header is PT_NOTE header. */
> -	vmcore_off = sizeof(Elf64_Ehdr) +
> -			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr) +
> -			phdr_ptr->p_memsz; /* Note sections */
> +	vmcore_off = elfsz + roundup(phdr_ptr->p_memsz, PAGE_SIZE);
>  
>  	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
>  		if (phdr_ptr->p_type != PT_LOAD)
> @@ -435,9 +438,7 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
>  	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr)); /* PT_NOTE hdr */
>  
>  	/* First program header is PT_NOTE header. */
> -	vmcore_off = sizeof(Elf32_Ehdr) +
> -			(ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr) +
> -			phdr_ptr->p_memsz; /* Note sections */
> +	vmcore_off = elfsz + roundup(phdr_ptr->p_memsz, PAGE_SIZE);

Hmm.., so we are rounding up ELF note data size too here. I think this belongs
in some other patch as in this patch we are just rounding up the elf
headers.

This might create read problems too as we have not taking care of this
rounding when adding note to vc_list and it might happen that we are
reading wrong data at a particular offset.

So may be this rounding up we should do in later patches when we take
care of copying ELF notes data to second kernel.

Vivek
