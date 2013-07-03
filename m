Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3GCMGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:06:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129Ab3GCMGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:06:53 -0400
Message-ID: <51D413D9.8040604@suse.cz>
Date: Wed, 03 Jul 2013 14:06:49 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Daniel Tang <dt.tangr@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH 1/2] Fix a build warning in scripts/sortextable.h
References: <1370745235-12951-1-git-send-email-dt.tangr@gmail.com>
In-Reply-To: <1370745235-12951-1-git-send-email-dt.tangr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added David Daney to CC.

On 9.6.2013 04:33, Daniel Tang wrote:
> The pointer passed to the _r() macro does not always match the type
> of the function that it is aliasing and raises several of the following
> warnings at compile time:
> 
> warning: passing argument 1 of ‘r8’ from incompatible pointer type

In what environment (arch, compiler, glibc) are you seeing this?

Michal

> Fixed by casting the pointers to (void *) so they work with both the
> 32bit and 64bit code.
> 
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
> ---
>  scripts/sortextable.h | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/scripts/sortextable.h b/scripts/sortextable.h
> index f5eb43d..0a38fbd 100644
> --- a/scripts/sortextable.h
> +++ b/scripts/sortextable.h
> @@ -110,9 +110,9 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
>  	int i;
>  	int idx;
>  
> -	shdr = (Elf_Shdr *)((char *)ehdr + _r(&ehdr->e_shoff));
> +	shdr = (Elf_Shdr *)((char *)ehdr + _r((void *)&ehdr->e_shoff));
>  	shstrtab_sec = shdr + r2(&ehdr->e_shstrndx);
> -	secstrtab = (const char *)ehdr + _r(&shstrtab_sec->sh_offset);
> +	secstrtab = (const char *)ehdr + _r((void *)&shstrtab_sec->sh_offset);
>  	for (i = 0; i < r2(&ehdr->e_shnum); i++) {
>  		idx = r(&shdr[i].sh_name);
>  		if (strcmp(secstrtab + idx, "__ex_table") == 0) {
> @@ -122,8 +122,8 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
>  		if ((r(&shdr[i].sh_type) == SHT_REL ||
>  		     r(&shdr[i].sh_type) == SHT_RELA) &&
>  		    r(&shdr[i].sh_info) == extab_index) {
> -			relocs = (void *)ehdr + _r(&shdr[i].sh_offset);
> -			relocs_size = _r(&shdr[i].sh_size);
> +			relocs = (void *)ehdr + _r((void *)&shdr[i].sh_offset);
> +			relocs_size = _r((void *)&shdr[i].sh_size);
>  		}
>  		if (strcmp(secstrtab + idx, ".symtab") == 0)
>  			symtab_sec = shdr + i;
> @@ -142,14 +142,14 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
>  		fprintf(stderr,	"no __ex_table in  file: %s\n", fname);
>  		fail_file();
>  	}
> -	strtab = (const char *)ehdr + _r(&strtab_sec->sh_offset);
> +	strtab = (const char *)ehdr + _r((void *)&strtab_sec->sh_offset);
>  
> -	extab_image = (void *)ehdr + _r(&extab_sec->sh_offset);
> +	extab_image = (void *)ehdr + _r((void *)&extab_sec->sh_offset);
>  
>  	if (custom_sort) {
> -		custom_sort(extab_image, _r(&extab_sec->sh_size));
> +		custom_sort(extab_image, _r((void *)&extab_sec->sh_size));
>  	} else {
> -		int num_entries = _r(&extab_sec->sh_size) / extable_ent_size;
> +		int num_entries = _r((void *)&extab_sec->sh_size) / extable_ent_size;
>  		qsort(extab_image, num_entries,
>  		      extable_ent_size, compare_extable);
>  	}
> @@ -159,12 +159,13 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
>  
>  	/* find main_extable_sort_needed */
>  	sort_needed_sym = NULL;
> -	for (i = 0; i < _r(&symtab_sec->sh_size) / sizeof(Elf_Sym); i++) {
> -		sym = (void *)ehdr + _r(&symtab_sec->sh_offset);
> +	for (i = 0; i < _r((void *)&symtab_sec->sh_size) / sizeof(Elf_Sym); i++)
> +	{
> +		sym = (void *)ehdr + _r((void *)&symtab_sec->sh_offset);
>  		sym += i;
>  		if (ELF_ST_TYPE(sym->st_info) != STT_OBJECT)
>  			continue;
> -		idx = r(&sym->st_name);
> +		idx = r((void *)&sym->st_name);
>  		if (strcmp(strtab + idx, "main_extable_sort_needed") == 0) {
>  			sort_needed_sym = sym;
>  			break;
> @@ -178,9 +179,9 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
>  	}
>  	sort_needed_sec = &shdr[r2(&sort_needed_sym->st_shndx)];
>  	sort_done_location = (void *)ehdr +
> -		_r(&sort_needed_sec->sh_offset) +
> -		_r(&sort_needed_sym->st_value) -
> -		_r(&sort_needed_sec->sh_addr);
> +		_r((void *)&sort_needed_sec->sh_offset) +
> +		_r((void *)&sort_needed_sym->st_value) -
> +		_r((void *)&sort_needed_sec->sh_addr);
>  
>  #if 0
>  	printf("sort done marker at %lx\n",
> 

