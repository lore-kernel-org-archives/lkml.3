Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab3EPIA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:00:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27733 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab3EPIA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:00:56 -0400
X-IronPort-AV: E=Sophos;i="4.87,683,1363104000"; 
   d="scan'208";a="7284471"
Message-ID: <51948885.5040408@cn.fujitsu.com>
Date: Thu, 16 May 2013 15:19:33 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org,
        cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        jingbai.ma@hp.com, linux-mm@kvack.org, riel@redhat.com,
        walken@google.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH v6 7/8] vmcore: calculate vmcore file size from buffer
 size and total size of vmcore objects
References: <20130515090507.28109.28956.stgit@localhost6.localdomain6> <20130515090620.28109.68803.stgit@localhost6.localdomain6>
In-Reply-To: <20130515090620.28109.68803.stgit@localhost6.localdomain6>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/16 15:20:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/16 15:21:01
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月15日 17:06, HATAYAMA Daisuke 写道:
> The previous patches newly added holes before each chunk of memory and
> the holes need to be count in vmcore file size. There are two ways to
> count file size in such a way:
> 
> 1) supporse m as a poitner to the last vmcore object in vmcore_list.
> , then file size is (m->offset + m->size), or
> 
> 2) calculate sum of size of buffers for ELF header, program headers,
> ELF note segments and objects in vmcore_list.
> 
> Although 1) is more direct and simpler than 2), 2) seems better in
> that it reflects internal object structure of /proc/vmcore. Thus, this
> patch changes get_vmcore_size_elf{64, 32} so that it calculates size
> in the way of 2).
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> ---

Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> 
>  fs/proc/vmcore.c |   40 ++++++++++++++++++----------------------
>  1 files changed, 18 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 4e121fda..7f2041c 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -210,36 +210,28 @@ static struct vmcore* __init get_new_element(void)
>  	return kzalloc(sizeof(struct vmcore), GFP_KERNEL);
>  }
>  
> -static u64 __init get_vmcore_size_elf64(char *elfptr, size_t elfsz)
> +static u64 __init get_vmcore_size_elf64(size_t elfsz, size_t elfnotesegsz,
> +					struct list_head *vc_list)
>  {
> -	int i;
>  	u64 size;
> -	Elf64_Ehdr *ehdr_ptr;
> -	Elf64_Phdr *phdr_ptr;
> +	struct vmcore *m;
>  
> -	ehdr_ptr = (Elf64_Ehdr *)elfptr;
> -	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr));
> -	size = elfsz;
> -	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
> -		size += phdr_ptr->p_memsz;
> -		phdr_ptr++;
> +	size = elfsz + elfnotesegsz;
> +	list_for_each_entry(m, vc_list, list) {
> +		size += m->size;
>  	}
>  	return size;
>  }
>  
> -static u64 __init get_vmcore_size_elf32(char *elfptr, size_t elfsz)
> +static u64 __init get_vmcore_size_elf32(size_t elfsz, size_t elfnotesegsz,
> +					struct list_head *vc_list)
>  {
> -	int i;
>  	u64 size;
> -	Elf32_Ehdr *ehdr_ptr;
> -	Elf32_Phdr *phdr_ptr;
> +	struct vmcore *m;
>  
> -	ehdr_ptr = (Elf32_Ehdr *)elfptr;
> -	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr));
> -	size = elfsz;
> -	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
> -		size += phdr_ptr->p_memsz;
> -		phdr_ptr++;
> +	size = elfsz + elfnotesegsz;
> +	list_for_each_entry(m, vc_list, list) {
> +		size += m->size;
>  	}
>  	return size;
>  }
> @@ -795,14 +787,18 @@ static int __init parse_crash_elf_headers(void)
>  			return rc;
>  
>  		/* Determine vmcore size. */
> -		vmcore_size = get_vmcore_size_elf64(elfcorebuf, elfcorebuf_sz);
> +		vmcore_size = get_vmcore_size_elf64(elfcorebuf_sz,
> +						    elfnotes_sz,
> +						    &vmcore_list);
>  	} else if (e_ident[EI_CLASS] == ELFCLASS32) {
>  		rc = parse_crash_elf32_headers();
>  		if (rc)
>  			return rc;
>  
>  		/* Determine vmcore size. */
> -		vmcore_size = get_vmcore_size_elf32(elfcorebuf, elfcorebuf_sz);
> +		vmcore_size = get_vmcore_size_elf32(elfcorebuf_sz,
> +						    elfnotes_sz,
> +						    &vmcore_list);
>  	} else {
>  		pr_warn("Warning: Core image elf header is not sane\n");
>  		return -EINVAL;
> 
> 

