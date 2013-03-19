Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab3CSV7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:59:40 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59711 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3CSV7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:59:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130316040104.15064.57180.stgit@localhost6.localdomain6>
Date: Tue, 19 Mar 2013 14:59:31 -0700
In-Reply-To: <20130316040104.15064.57180.stgit@localhost6.localdomain6>
	(HATAYAMA Daisuke's message of "Sat, 16 Mar 2013 13:01:04 +0900")
Message-ID: <87wqt3m4os.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19mEvnGJrzWhNnHFfvOJaK+oA35XU20Wjw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 03/21] vmcore: rearrange program headers without assuming consequtive PT_NOTE entries
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:

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

This patch looks like you have really overthought this part of the code.
You are adding a fair amount of complexity for very little gain.

To clean this up I would recommend two buffers.  A temporary buffer
for the program headers read out of oldmem, and a longer lived
buffer where you generate the new headers into.  Then the scary
memmove and the assumptions about location in the PT_LOAD chain
can be removed without having to do fancy hard to follow multi-pass
code.

If the result isn't going to be clean and easy to follow we might as
well deem the requirements of the existing code an ABI and not worry
about relaxing them.

Eric



> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
>
>  fs/proc/vmcore.c |   92 +++++++++++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 74 insertions(+), 18 deletions(-)
>
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 94743d2..7d2dc4c 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -251,8 +251,7 @@ static u64 __init get_vmcore_size_elf32(char *elfptr)
>  static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>  						struct list_head *vc_list)
>  {
> -	int i, nr_ptnote=0, rc=0;
> -	char *tmp;
> +	int i, j, nr_ptnote=0, i_ptnote, rc=0;
>  	Elf64_Ehdr *ehdr_ptr;
>  	Elf64_Phdr phdr, *phdr_ptr;
>  	Elf64_Nhdr *nhdr_ptr;
> @@ -301,6 +300,39 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
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
> @@ -312,18 +344,14 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
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
> @@ -331,8 +359,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>  static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
>  						struct list_head *vc_list)
>  {
> -	int i, nr_ptnote=0, rc=0;
> -	char *tmp;
> +	int i, j, nr_ptnote=0, i_ptnote, rc=0;
>  	Elf32_Ehdr *ehdr_ptr;
>  	Elf32_Phdr phdr, *phdr_ptr;
>  	Elf32_Nhdr *nhdr_ptr;
> @@ -381,6 +408,39 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
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
> @@ -392,18 +452,14 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
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
