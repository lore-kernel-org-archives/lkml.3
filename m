Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab3CJGsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:48:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:36356 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab3CJGsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:48:04 -0500
X-IronPort-AV: E=Sophos;i="4.84,817,1355068800"; 
   d="scan'208";a="6843783"
Message-ID: <513C2C47.5020008@cn.fujitsu.com>
Date: Sun, 10 Mar 2013 14:46:31 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: kexec@lists.infradead.org, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, lisa.mitchell@hp.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com,
        akpm@linux-foundation.org, cpw@sgi.com, vgoyal@redhat.com
Subject: Re: [PATCH v2 01/20] vmcore: refer to e_phoff member explicitly
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6> <20130302083554.31252.30615.stgit@localhost6.localdomain6> <5135A054.7010401@cn.fujitsu.com>
In-Reply-To: <5135A054.7010401@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/10 14:46:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/10 14:46:52
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月05日 15:35, Zhang Yanfei 写道:
> 于 2013年03月02日 16:35, HATAYAMA Daisuke 写道:
>> Code around /proc/vmcore currently assumes program header table is
>> next to ELF header. But future change can break the assumption on
>> kexec-tools and the 1st kernel. To avoid worst case, now refer to
>> e_phoff member that indicates position of program header table in
>> file-offset.
> 
> Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> 
>>
>> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
>> ---
>>
>>  fs/proc/vmcore.c |   40 ++++++++++++++++++++--------------------
>>  1 files changed, 20 insertions(+), 20 deletions(-)
>>
>> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
>> index b870f74..abf4f01 100644
>> --- a/fs/proc/vmcore.c
>> +++ b/fs/proc/vmcore.c
>> @@ -221,8 +221,8 @@ static u64 __init get_vmcore_size_elf64(char *elfptr)
>>  	Elf64_Phdr *phdr_ptr;
>>  
>>  	ehdr_ptr = (Elf64_Ehdr *)elfptr;
>> -	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr));
>> -	size = sizeof(Elf64_Ehdr) + ((ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr));
>> +	phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff);
>> +	size = ehdr_ptr->e_phoff + ((ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr));
>>  	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
>>  		size += phdr_ptr->p_memsz;
>>  		phdr_ptr++;
>> @@ -238,8 +238,8 @@ static u64 __init get_vmcore_size_elf32(char *elfptr)
>>  	Elf32_Phdr *phdr_ptr;
>>  
>>  	ehdr_ptr = (Elf32_Ehdr *)elfptr;
>> -	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr));
>> -	size = sizeof(Elf32_Ehdr) + ((ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr));
>> +	phdr_ptr = (Elf32_Phdr*)(elfptr + ehdr_ptr->e_phoff);
>> +	size = ehdr_ptr->e_phoff + ((ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr));
>>  	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
>>  		size += phdr_ptr->p_memsz;
>>  		phdr_ptr++;
>> @@ -259,7 +259,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>>  	u64 phdr_sz = 0, note_off;
>>  
>>  	ehdr_ptr = (Elf64_Ehdr *)elfptr;
>> -	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr));
>> +	phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff);
>>  	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
>>  		int j;
>>  		void *notes_section;
>> @@ -305,7 +305,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>>  	/* Prepare merged PT_NOTE program header. */
>>  	phdr.p_type    = PT_NOTE;
>>  	phdr.p_flags   = 0;
>> -	note_off = sizeof(Elf64_Ehdr) +
>> +	note_off = ehdr_ptr->e_phoff +
>>  			(ehdr_ptr->e_phnum - nr_ptnote +1) * sizeof(Elf64_Phdr);
>>  	phdr.p_offset  = note_off;
>>  	phdr.p_vaddr   = phdr.p_paddr = 0;
>> @@ -313,14 +313,14 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
>>  	phdr.p_align   = 0;
>>  
>>  	/* Add merged PT_NOTE program header*/
>> -	tmp = elfptr + sizeof(Elf64_Ehdr);
>> +	tmp = elfptr + ehdr_ptr->e_phoff;
>>  	memcpy(tmp, &phdr, sizeof(phdr));
>>  	tmp += sizeof(phdr);
>>  
>>  	/* Remove unwanted PT_NOTE program headers. */
>>  	i = (nr_ptnote - 1) * sizeof(Elf64_Phdr);
>>  	*elfsz = *elfsz - i;
>> -	memmove(tmp, tmp+i, ((*elfsz)-sizeof(Elf64_Ehdr)-sizeof(Elf64_Phdr)));
>> +	memmove(tmp, tmp+i, ((*elfsz)-ehdr_ptr->e_phoff-sizeof(Elf64_Phdr)));
>>  
>>  	/* Modify e_phnum to reflect merged headers. */
>>  	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
>> @@ -340,7 +340,7 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
>>  	u64 phdr_sz = 0, note_off;
>>  
>>  	ehdr_ptr = (Elf32_Ehdr *)elfptr;
>> -	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr));
>> +	phdr_ptr = (Elf32_Phdr*)(elfptr + ehdr_ptr->e_phoff);
>>  	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
>>  		int j;
>>  		void *notes_section;
>> @@ -386,7 +386,7 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
>>  	/* Prepare merged PT_NOTE program header. */
>>  	phdr.p_type    = PT_NOTE;
>>  	phdr.p_flags   = 0;
>> -	note_off = sizeof(Elf32_Ehdr) +
>> +	note_off = ehdr_ptr->e_phoff +
>>  			(ehdr_ptr->e_phnum - nr_ptnote +1) * sizeof(Elf32_Phdr);
>>  	phdr.p_offset  = note_off;
>>  	phdr.p_vaddr   = phdr.p_paddr = 0;
>> @@ -394,14 +394,14 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
>>  	phdr.p_align   = 0;
>>  
>>  	/* Add merged PT_NOTE program header*/
>> -	tmp = elfptr + sizeof(Elf32_Ehdr);
>> +	tmp = elfptr + ehdr_ptr->e_phoff;
>>  	memcpy(tmp, &phdr, sizeof(phdr));
>>  	tmp += sizeof(phdr);
>>  
>>  	/* Remove unwanted PT_NOTE program headers. */
>>  	i = (nr_ptnote - 1) * sizeof(Elf32_Phdr);
>>  	*elfsz = *elfsz - i;
>> -	memmove(tmp, tmp+i, ((*elfsz)-sizeof(Elf32_Ehdr)-sizeof(Elf32_Phdr)));
>> +	memmove(tmp, tmp+i, ((*elfsz)-ehdr_ptr->e_phoff-sizeof(Elf32_Phdr)));
>>  
>>  	/* Modify e_phnum to reflect merged headers. */
>>  	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
>> @@ -422,10 +422,10 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
>>  	struct vmcore *new;
>>  
>>  	ehdr_ptr = (Elf64_Ehdr *)elfptr;
>> -	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr)); /* PT_NOTE hdr */
>> +	phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
>>  
>>  	/* First program header is PT_NOTE header. */
>> -	vmcore_off = sizeof(Elf64_Ehdr) +
>> +	vmcore_off = ehdr_ptr->e_phoff +
>>  			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr) +
>>  			phdr_ptr->p_memsz; /* Note sections */
>>  
>> @@ -459,10 +459,10 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
>>  	struct vmcore *new;
>>  
>>  	ehdr_ptr = (Elf32_Ehdr *)elfptr;
>> -	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr)); /* PT_NOTE hdr */
>> +	phdr_ptr = (Elf32_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
>>  
>>  	/* First program header is PT_NOTE header. */
>> -	vmcore_off = sizeof(Elf32_Ehdr) +
>> +	vmcore_off = ehdr_ptr->e_phoff +
>>  			(ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr) +
>>  			phdr_ptr->p_memsz; /* Note sections */
>>  
>> @@ -496,7 +496,7 @@ static void __init set_vmcore_list_offsets_elf64(char *elfptr,
>>  	ehdr_ptr = (Elf64_Ehdr *)elfptr;
>>  
>>  	/* Skip Elf header and program headers. */
>> -	vmcore_off = sizeof(Elf64_Ehdr) +
>> +	vmcore_off = ehdr_ptr->e_phoff +
>>  			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr);
>>  
>>  	list_for_each_entry(m, vc_list, list) {
>> @@ -516,7 +516,7 @@ static void __init set_vmcore_list_offsets_elf32(char *elfptr,
>>  	ehdr_ptr = (Elf32_Ehdr *)elfptr;
>>  
>>  	/* Skip Elf header and program headers. */
>> -	vmcore_off = sizeof(Elf32_Ehdr) +
>> +	vmcore_off = ehdr_ptr->e_phoff +
>>  			(ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr);
>>  
>>  	list_for_each_entry(m, vc_list, list) {
>> @@ -553,7 +553,7 @@ static int __init parse_crash_elf64_headers(void)
>>  	}
>>  
>>  	/* Read in all elf headers. */
>> -	elfcorebuf_sz = sizeof(Elf64_Ehdr) + ehdr.e_phnum * sizeof(Elf64_Phdr);
>> +	elfcorebuf_sz = ehdr.e_phoff + ehdr.e_phnum * sizeof(Elf64_Phdr);

One minor suggestion.

Previously, when the code assumes program headers are following immediately
the ELF header, it uses

 elfcorebuf_sz = sizeof(Elf64_Ehdr) + ehdr.e_phnum * sizeof(Elf64_Phdr);

to calculate the size of ELF header and ELF program headers

This patch avoids the assumption, and uses ehdr.e_phoff to get the program
headers' address. But it will read unrelated contents into elfcorebuf if
program headers are not following immediately the ELF header. So could the
code be:

elfcorebuf_sz = sizeof(Elf64_Ehdr) + ehdr.e_phnum * sizeof(Elf64_Phdr);
addr = elfcorehdr_addr + ehdr.e_phoff;
memcpy(elfcorebuf, &ehdr, sizeof(Elf64_Ehdr));
read_from_oldmem(elfcorebuf + sizeof(Elf64_Ehdr), elfcorebuf_sz -
                 sizeof(Elf64_Ehdr), &addr, 0);
(Elf64_Ehdr *)elfcorebuf->e_phoff = sizeof(Elf64_Ehdr);

>>  	elfcorebuf = kmalloc(elfcorebuf_sz, GFP_KERNEL);
>>  	if (!elfcorebuf)
>>  		return -ENOMEM;
>> @@ -608,7 +608,7 @@ static int __init parse_crash_elf32_headers(void)
>>  	}
>>  
>>  	/* Read in all elf headers. */
>> -	elfcorebuf_sz = sizeof(Elf32_Ehdr) + ehdr.e_phnum * sizeof(Elf32_Phdr);
>> +	elfcorebuf_sz = ehdr.e_phoff + ehdr.e_phnum * sizeof(Elf32_Phdr);
>>  	elfcorebuf = kmalloc(elfcorebuf_sz, GFP_KERNEL);
>>  	if (!elfcorebuf)
>>  		return -ENOMEM;
>>
>>
>> _______________________________________________
>> kexec mailing list
>> kexec@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/kexec
>>
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

