Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965126Ab3CSVo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:44:26 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:55413 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964907Ab3CSVoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:44:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130316040053.15064.93652.stgit@localhost6.localdomain6>
Date: Tue, 19 Mar 2013 14:44:16 -0700
In-Reply-To: <20130316040053.15064.93652.stgit@localhost6.localdomain6>
	(HATAYAMA Daisuke's message of "Sat, 16 Mar 2013 13:00:53 +0900")
Message-ID: <87ppyvnjyn.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+caWOOf/4mEW/H1pBqd8uc/2KNSu9m9RQ=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
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
Subject: Re: [PATCH v3 01/21] vmcore: reference e_phoff member explicitly to get position of program header table
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:

> Currently, the code assumes that position of program header table is
> next to ELF header. But future change can break the assumption on
> kexec-tools and the 1st kernel. To avoid worst case, reference e_phoff
> member explicitly to get position of program header table in
> file-offset.

In principle this looks good.  However when I read this it looks like
you are going a little too far.

You are changing not only the reading of the supplied headers, but
you are changing the generation of the new new headers that describe
the data provided by /proc/vmcore.

I get lost in following this after you mangle merge_note_headers.

In principle removing silly assumptions seems reasonable, but I think
it is completely orthogonal to the task of maping vmcore mmapable.

I think it is fine to claim that the assumptions made here in vmcore are
part of the kexec on panic ABI at this point, which would generally make
this change unnecessary.

> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
>
>  fs/proc/vmcore.c |   56 +++++++++++++++++++++++++++++++++++-------------------
>  1 files changed, 36 insertions(+), 20 deletions(-)
>
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index b870f74..163281e 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -221,8 +221,8 @@ static u64 __init get_vmcore_size_elf64(char *elfptr)
>  	Elf64_Phdr *phdr_ptr;
>  
>  	ehdr_ptr = (Elf64_Ehdr *)elfptr;
> -	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr));
> -	size = sizeof(Elf64_Ehdr) + ((ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr));
> +	phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff);
> +	size = ehdr_ptr->e_phoff + ((ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr));
>  	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
>  		size += phdr_ptr->p_memsz;
>  		phdr_ptr++;
> @@ -238,8 +238,8 @@ static u64 __init get_vmcore_size_elf32(char *elfptr)
>  	Elf32_Phdr *phdr_ptr;
>  
>  	ehdr_ptr = (Elf32_Ehdr *)elfptr;
> -	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr));
> -	size = sizeof(Elf32_Ehdr) + ((ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr));
> +	phdr_ptr = (Elf32_Phdr*)(elfptr + ehdr_ptr->e_phoff);
> +	size = ehdr_ptr->e_phoff + ((ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr));
>  	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
>  		size += phdr_ptr->p_memsz;
>  		phdr_ptr++;

> @@ -259,7 +259,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>  	u64 phdr_sz = 0, note_off;
>  
>  	ehdr_ptr = (Elf64_Ehdr *)elfptr;
> -	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr));
> +	phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff);
>  	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
>  		int j;
>  		void *notes_section;

Up to here things look good.

> @@ -305,7 +305,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>  	/* Prepare merged PT_NOTE program header. */
>  	phdr.p_type    = PT_NOTE;
>  	phdr.p_flags   = 0;
> -	note_off = sizeof(Elf64_Ehdr) +
> +	note_off = ehdr_ptr->e_phoff +
>  			(ehdr_ptr->e_phnum - nr_ptnote +1) * sizeof(Elf64_Phdr);

And this is is just silly.  There is no point in changing where the
regenerated headers live.

>  	phdr.p_offset  = note_off;
>  	phdr.p_vaddr   = phdr.p_paddr = 0;
> @@ -313,14 +313,14 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>  	phdr.p_align   = 0;
>  
>  	/* Add merged PT_NOTE program header*/
> -	tmp = elfptr + sizeof(Elf64_Ehdr);
> +	tmp = elfptr + ehdr_ptr->e_phoff;
Again this looks very silly.

>  	memcpy(tmp, &phdr, sizeof(phdr));
>  	tmp += sizeof(phdr);
>  
>  	/* Remove unwanted PT_NOTE program headers. */
>  	i = (nr_ptnote - 1) * sizeof(Elf64_Phdr);
>  	*elfsz = *elfsz - i;
> -	memmove(tmp, tmp+i, ((*elfsz)-sizeof(Elf64_Ehdr)-sizeof(Elf64_Phdr)));
> +	memmove(tmp, tmp+i, ((*elfsz)-ehdr_ptr->e_phoff-sizeof(Elf64_Phdr)));

This is a regenerated header so this change is dubious.


Eric
