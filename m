Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3CEIir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:38:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:12055 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab3CEIiq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:38:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,786,1355068800"; 
   d="scan'208";a="6816089"
Message-ID: <5135AEA5.7000605@cn.fujitsu.com>
Date: Tue, 05 Mar 2013 16:36:53 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/20] vmcore: rearrange program headers without assuming
 consequtive PT_NOTE entries
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6> <20130302083559.31252.60341.stgit@localhost6.localdomain6>
In-Reply-To: <20130302083559.31252.60341.stgit@localhost6.localdomain6>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 16:37:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 16:37:43
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月02日 16:35, HATAYAMA Daisuke 写道:
> Current code assumes all PT_NOTE headers are placed at the beginning
> of program header table and they are consequtive. But the assumption
> could be broken by future changes on either kexec-tools or the 1st
> kernel. This patch removes the assumption and rearranges program
> headers as the following conditions are satisfied:
> 
> - PT_NOTE entry is unique at the first entry,
> 
> - the order of program headers are unchanged during this
>   rearrangement, only their positions are changed in positive
>   direction.
> 
> - unused part that occurs in the bottom of program headers are filled
>   with 0.
> 
> Also, this patch adds one exceptional case where the number of PT_NOTE
> entries is somehow 0. Then, immediately go out of the function.
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
> 
>  fs/proc/vmcore.c |   92 +++++++++++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 74 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index abf4f01..b5c9e33 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -251,8 +251,7 @@ static u64 __init get_vmcore_size_elf32(char *elfptr)
>  static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>  						struct list_head *vc_list)
>  {
> -	int i, nr_ptnote=0, rc=0;
> -	char *tmp;
> +	int i, j, nr_ptnote=0, i_ptnote, rc=0;

After applying the patch, there are two "j" defined.

251 static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
252                                                 struct list_head *vc_list)
253 {
254         int i, j, nr_ptnote=0, i_ptnote, rc=0;
255         Elf64_Ehdr *ehdr_ptr;
256         Elf64_Phdr phdr, *phdr_ptr;
257         Elf64_Nhdr *nhdr_ptr;
258         u64 phdr_sz = 0, note_off;
259 
260         ehdr_ptr = (Elf64_Ehdr *)elfptr;
261         phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff);
262         for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
263                 int j;
264                 void *notes_section;
265                 struct vmcore *new;


line 254 and 263.


>  	Elf64_Ehdr *ehdr_ptr;
>  	Elf64_Phdr phdr, *phdr_ptr;
>  	Elf64_Nhdr *nhdr_ptr;
> @@ -302,6 +301,39 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>  		kfree(notes_section);
>  	}
>  
> +	if (nr_ptnote == 0)
> +		goto out;
> +
> +	phdr_ptr = (Elf64_Phdr *)(elfptr + ehdr_ptr->e_phoff);
> +
> +	/* Remove unwanted PT_NOTE program headers. */
> +
> +        /* - 1st pass shifts non-PT_NOTE entries until the first
> +	     PT_NOTE entry. */
> +	i_ptnote = -1;
> +	for (i = 0; i < ehdr_ptr->e_phnum; ++i) {
> +		if (phdr_ptr[i].p_type == PT_NOTE) {
> +			i_ptnote = i;
> +			break;
> +		}
> +	}
> +	BUG_ON(i_ptnote == -1); /* impossible case since nr_ptnote > 0. */
> +	memmove(phdr_ptr + 1, phdr_ptr,	i_ptnote * sizeof(Elf64_Phdr));

is there any problem with this move? What is the batch bytes for every loop
of memmove? 

if i_ptnode == 2, so we have

-------------------------------------
| PT_LOAD 1 | PT_LOAD 2 | PT_NOTE 1 |
-------------------------------------

-->

-------------------------------------
|           | PT_LOAD 1 | PT_LOAD 2 |
-------------------------------------

right? In the move, Does PT_LOAD 1 overwrite the original PT_LOAD 2?

> +
> +	/* - 2nd pass moves the remaining non-PT_NOTE entries under
> +	     the first PT_NOTE entry. */
> +	for (i = j = i_ptnote + 1; i < ehdr_ptr->e_phnum; i++) {
> +		if (phdr_ptr[i].p_type != PT_NOTE) {
> +			memmove(phdr_ptr + j, phdr_ptr + i,
> +				sizeof(Elf64_Phdr));
> +			j++;
> +		}
> +	}
> +
> +	/* - Finally, fill unused part with 0. */
> +	memset(phdr_ptr + ehdr_ptr->e_phnum - (nr_ptnote - 1), 0,
> +	       (nr_ptnote - 1) * sizeof(Elf64_Phdr));
> +
>  	/* Prepare merged PT_NOTE program header. */
>  	phdr.p_type    = PT_NOTE;
>  	phdr.p_flags   = 0;
> @@ -313,18 +345,14 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>  	phdr.p_align   = 0;
>  
>  	/* Add merged PT_NOTE program header*/
> -	tmp = elfptr + ehdr_ptr->e_phoff;
> -	memcpy(tmp, &phdr, sizeof(phdr));
> -	tmp += sizeof(phdr);
> +	memcpy(phdr_ptr, &phdr, sizeof(Elf64_Phdr));
>  
> -	/* Remove unwanted PT_NOTE program headers. */
> -	i = (nr_ptnote - 1) * sizeof(Elf64_Phdr);
> -	*elfsz = *elfsz - i;
> -	memmove(tmp, tmp+i, ((*elfsz)-ehdr_ptr->e_phoff-sizeof(Elf64_Phdr)));
> +	*elfsz = *elfsz - (nr_ptnote - 1) * sizeof(Elf64_Phdr);
>  
>  	/* Modify e_phnum to reflect merged headers. */
>  	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
>  
> +out:
>  	return 0;
>  }
>  
> @@ -332,8 +360,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>  static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
>  						struct list_head *vc_list)
>  {
> -	int i, nr_ptnote=0, rc=0;
> -	char *tmp;
> +	int i, j, nr_ptnote=0, i_ptnote, rc=0;
>  	Elf32_Ehdr *ehdr_ptr;
>  	Elf32_Phdr phdr, *phdr_ptr;
>  	Elf32_Nhdr *nhdr_ptr;
> @@ -383,6 +410,39 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
>  		kfree(notes_section);
>  	}
>  
> +	if (nr_ptnote == 0)
> +		goto out;
> +
> +	phdr_ptr = (Elf32_Phdr *)(elfptr + ehdr_ptr->e_phoff);
> +
> +	/* Remove unwanted PT_NOTE program headers. */
> +
> +	/* - 1st pass shifts non-PT_NOTE entries until the first
> +	     PT_NOTE entry. */
> +	i_ptnote = -1;
> +	for (i = 0; i < ehdr_ptr->e_phnum; ++i) {
> +		if (phdr_ptr[i].p_type == PT_NOTE) {
> +			i_ptnote = i;
> +			break;
> +		}
> +	}
> +	BUG_ON(i_ptnote == -1); /* impossible case since nr_ptnote > 0. */
> +	memmove(phdr_ptr + 1, phdr_ptr, i_ptnote * sizeof(Elf32_Phdr));
> +
> +	/* - 2nd pass moves the remaining non-PT_NOTE entries under
> +	     the first PT_NOTE entry. */
> +	for (i = j = i_ptnote + 1; i < ehdr_ptr->e_phnum; i++) {
> +		if (phdr_ptr[i].p_type != PT_NOTE) {
> +			memmove(phdr_ptr + j, phdr_ptr + i,
> +				sizeof(Elf32_Phdr));
> +			j++;
> +		}
> +	}
> +
> +	/* - Finally, fill unused part with 0. */
> +	memset(phdr_ptr + ehdr_ptr->e_phnum - (nr_ptnote - 1), 0,
> +	       (nr_ptnote - 1) * sizeof(Elf32_Phdr));
> +
>  	/* Prepare merged PT_NOTE program header. */
>  	phdr.p_type    = PT_NOTE;
>  	phdr.p_flags   = 0;
> @@ -394,18 +454,14 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
>  	phdr.p_align   = 0;
>  
>  	/* Add merged PT_NOTE program header*/
> -	tmp = elfptr + ehdr_ptr->e_phoff;
> -	memcpy(tmp, &phdr, sizeof(phdr));
> -	tmp += sizeof(phdr);
> +	memcpy(phdr_ptr, &phdr, sizeof(Elf32_Phdr));
>  
> -	/* Remove unwanted PT_NOTE program headers. */
> -	i = (nr_ptnote - 1) * sizeof(Elf32_Phdr);
> -	*elfsz = *elfsz - i;
> -	memmove(tmp, tmp+i, ((*elfsz)-ehdr_ptr->e_phoff-sizeof(Elf32_Phdr)));
> +	*elfsz = *elfsz - (nr_ptnote - 1) * sizeof(Elf32_Phdr);
>  
>  	/* Modify e_phnum to reflect merged headers. */
>  	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
>  
> +out:
>  	return 0;
>  }
>  
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 

