Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab3CFHAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:00:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:10457 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab3CFHAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:00:51 -0500
X-IronPort-AV: E=Sophos;i="4.84,793,1355068800"; 
   d="scan'208";a="6822382"
Message-ID: <5136E8EE.6080301@cn.fujitsu.com>
Date: Wed, 06 Mar 2013 14:57:50 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/20] vmcore: allocate buffer for ELF headers on page-size
 alignment
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6> <20130302083610.31252.18601.stgit@localhost6.localdomain6>
In-Reply-To: <20130302083610.31252.18601.stgit@localhost6.localdomain6>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 14:58:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 14:58:20
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月02日 16:36, HATAYAMA Daisuke 写道:
> Allocate buffer for ELF headers on page-size aligned boudary to
> satisfy mmap() requirement. For this, __get_free_pages() is used
> instead of kmalloc().
> 
> Also, later patch will decrease actually used buffer size for ELF
> headers, so it's necessary to keep original buffer size and actually
> used buffer size separately. elfcorebuf_sz_orig keeps the original one
> and elfcorebuf_sz the actually used one.
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
> 
>  fs/proc/vmcore.c |   30 +++++++++++++++++++++---------
>  1 files changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index b5c9e33..1b02d01 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -31,6 +31,7 @@ static LIST_HEAD(vmcore_list);
>  /* Stores the pointer to the buffer containing kernel elf core headers. */
>  static char *elfcorebuf;
>  static size_t elfcorebuf_sz;
> +static size_t elfcorebuf_sz_orig;
>  
>  /* Total size of vmcore file. */
>  static u64 vmcore_size;
> @@ -610,26 +611,31 @@ static int __init parse_crash_elf64_headers(void)
>  
>  	/* Read in all elf headers. */
>  	elfcorebuf_sz = ehdr.e_phoff + ehdr.e_phnum * sizeof(Elf64_Phdr);
> -	elfcorebuf = kmalloc(elfcorebuf_sz, GFP_KERNEL);
> +	elfcorebuf_sz_orig = elfcorebuf_sz;
> +	elfcorebuf = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
> +					       get_order(elfcorebuf_sz_orig));
>  	if (!elfcorebuf)
>  		return -ENOMEM;
>  	addr = elfcorehdr_addr;
>  	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz, &addr, 0);
>  	if (rc < 0) {
> -		kfree(elfcorebuf);
> +		free_pages((unsigned long)elfcorebuf,
> +			   get_order(elfcorebuf_sz_orig));
>  		return rc;
>  	}
>  
>  	/* Merge all PT_NOTE headers into one. */
>  	rc = merge_note_headers_elf64(elfcorebuf, &elfcorebuf_sz, &vmcore_list);
>  	if (rc) {
> -		kfree(elfcorebuf);
> +		free_pages((unsigned long)elfcorebuf,
> +			   get_order(elfcorebuf_sz_orig));
>  		return rc;
>  	}
>  	rc = process_ptload_program_headers_elf64(elfcorebuf, elfcorebuf_sz,
>  							&vmcore_list);
>  	if (rc) {
> -		kfree(elfcorebuf);
> +		free_pages((unsigned long)elfcorebuf,
> +			   get_order(elfcorebuf_sz_orig));
>  		return rc;
>  	}
>  	set_vmcore_list_offsets_elf64(elfcorebuf, &vmcore_list);
> @@ -665,26 +671,31 @@ static int __init parse_crash_elf32_headers(void)
>  
>  	/* Read in all elf headers. */
>  	elfcorebuf_sz = ehdr.e_phoff + ehdr.e_phnum * sizeof(Elf32_Phdr);
> -	elfcorebuf = kmalloc(elfcorebuf_sz, GFP_KERNEL);
> +	elfcorebuf_sz_orig = elfcorebuf_sz;
> +	elfcorebuf = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
> +					       get_order(elfcorebuf_sz));

Why not elfcorebuf_sz_orig here?

>  	if (!elfcorebuf)
>  		return -ENOMEM;
>  	addr = elfcorehdr_addr;
>  	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz, &addr, 0);
>  	if (rc < 0) {
> -		kfree(elfcorebuf);
> +		free_pages((unsigned long)elfcorebuf,
> +			   get_order(elfcorebuf_sz_orig));
>  		return rc;
>  	}
>  
>  	/* Merge all PT_NOTE headers into one. */
>  	rc = merge_note_headers_elf32(elfcorebuf, &elfcorebuf_sz, &vmcore_list);
>  	if (rc) {
> -		kfree(elfcorebuf);
> +		free_pages((unsigned long)elfcorebuf,
> +			   get_order(elfcorebuf_sz_orig));
>  		return rc;
>  	}
>  	rc = process_ptload_program_headers_elf32(elfcorebuf, elfcorebuf_sz,
>  								&vmcore_list);
>  	if (rc) {
> -		kfree(elfcorebuf);
> +		free_pages((unsigned long)elfcorebuf,
> +			   get_order(elfcorebuf_sz_orig));
>  		return rc;
>  	}
>  	set_vmcore_list_offsets_elf32(elfcorebuf, &vmcore_list);
> @@ -766,7 +777,8 @@ void vmcore_cleanup(void)
>  		list_del(&m->list);
>  		kfree(m);
>  	}
> -	kfree(elfcorebuf);
> +	free_pages((unsigned long)elfcorebuf,
> +		   get_order(elfcorebuf_sz_orig));
>  	elfcorebuf = NULL;
>  }
>  EXPORT_SYMBOL_GPL(vmcore_cleanup);
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 

