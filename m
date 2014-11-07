Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaKGP1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:27:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:33973 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbaKGP1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:27:51 -0500
Date: Fri, 7 Nov 2014 12:26:18 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 2/3] perf symbol: Implement a very simple ELF symbol
 parser
Message-ID: <20141107152618.GM18464@kernel.org>
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
 <1415337606-2186-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415337606-2186-2-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 07, 2014 at 02:20:05PM +0900, Namhyung Kim escreveu:
> It'll be used to show (userspace) symbol names when libelf isn't (or
> cannot be) linked.

Does this deals with prelink, etc?

- Arnaldo
 
>   # Overhead  Command     Shared Object      Symbol
>   # ........  ..........  .................  .........................
>   #
>       37.01%  mem-memcpy  libc-2.17.so       [.] __memcpy_ssse3_back
>       24.25%  perf        ld-2.17.so         [.] _dl_relocate_object
>       22.16%  perf        [kernel.kallsyms]  [k] kmem_cache_alloc
>       14.29%  mem-memset  libc-2.17.so       [.] __memset_sse2
>        2.21%  perf        [kernel.kallsyms]  [k] flush_signal_handlers
>        0.07%  perf        [kernel.kallsyms]  [k] intel_pmu_enable_all
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/symbol-minimal.c | 143 ++++++++++++++++++++++++++++++++++++---
>  tools/perf/util/symbol-minimal.h |  64 ++++++++++++++++++
>  tools/perf/util/symbol.h         |  10 ++-
>  3 files changed, 208 insertions(+), 9 deletions(-)
>  create mode 100644 tools/perf/util/symbol-minimal.h
> 
> diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
> index 226cf41ed7e6..9da571d83a25 100644
> --- a/tools/perf/util/symbol-minimal.c
> +++ b/tools/perf/util/symbol-minimal.c
> @@ -1,11 +1,13 @@
>  #include "symbol.h"
>  #include "util.h"
> +#include "debug.h"
>  
>  #include <stdio.h>
>  #include <fcntl.h>
>  #include <string.h>
>  #include <byteswap.h>
>  #include <sys/stat.h>
> +#include <sys/mman.h>
>  
>  
>  static bool check_need_swap(int file_endian)
> @@ -242,22 +244,81 @@ int sysfs__read_build_id(const char *filename, void *build_id, size_t size)
>  	return ret;
>  }
>  
> +static const char *symsrc__symname(struct symsrc *ss, Elf_Shdr *strsec, int idx)
> +{
> +	return ss->ptr + strsec->sh_offset + idx;
> +}
> +
>  int symsrc__init(struct symsrc *ss, struct dso *dso __maybe_unused,
>  		 const char *name,
>  	         enum dso_binary_type type)
>  {
> -	int fd = open(name, O_RDONLY);
> +	int fd;
> +	unsigned i;
> +	Elf_Ehdr ehdr;
> +	struct stat stbuf;
> +	void *ptr;
> +
> +	fd = open(name, O_RDONLY);
>  	if (fd < 0)
>  		return -1;
>  
>  	ss->name = strdup(name);
> -	if (!ss->name)
> -		goto out_close;
> +	if (!ss->name) {
> +		close(fd);
> +		return -1;
> +	}
>  
>  	ss->fd = fd;
>  	ss->type = type;
>  
> +	/* only consider native case (no swap) */
> +	if (read(fd, &ehdr, sizeof(ehdr)) < 0)
> +		goto out_close;
> +
> +	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) ||
> +	    ehdr.e_ident[EI_VERSION] != EV_CURRENT)
> +		goto out_close;
> +
> +	if (ehdr.e_ident[EI_CLASS] != ELFCLASS)
> +		goto out_close;
> +
> +	if (check_need_swap(ehdr.e_ident[EI_DATA]))
> +		goto out_close;
> +
> +	if (ehdr.e_shentsize != sizeof(Elf_Shdr))
> +		goto out_close;
> +
> +	if (fstat(fd, &stbuf) < 0)
> +		goto out_close;
> +
> +	ptr = mmap(NULL, stbuf.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
> +	if (ptr == MAP_FAILED)
> +		goto out_close;
> +
> +	ss->ptr = ptr;
> +	ss->len = stbuf.st_size;
> +	ss->sec = ptr + ehdr.e_shoff;
> +
> +	ss->symtab = NULL;
> +	for (i = 0; i < ehdr.e_shnum; i++) {
> +		Elf_Shdr *shdrp = &ss->sec[i];
> +		const char *shname;
> +
> +		shname = symsrc__symname(ss, &ss->sec[ehdr.e_shstrndx],
> +					 shdrp->sh_name);
> +
> +		if (!strcmp(shname, ".text"))
> +			ss->adjust_offset = shdrp->sh_addr - shdrp->sh_offset;
> +
> +		if (shdrp->sh_type == SHT_SYMTAB) {
> +			ss->symtab = shdrp;
> +			ss->strtab = &ss->sec[shdrp->sh_link];
> +		}
> +	}
> +
>  	return 0;
> +
>  out_close:
>  	close(fd);
>  	return -1;
> @@ -276,6 +337,7 @@ bool symsrc__has_symtab(struct symsrc *ss __maybe_unused)
>  
>  void symsrc__destroy(struct symsrc *ss)
>  {
> +	munmap(ss->ptr, ss->len);
>  	zfree(&ss->name);
>  	close(ss->fd);
>  }
> @@ -332,7 +394,9 @@ int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
>  		  symbol_filter_t filter __maybe_unused,
>  		  int kmodule __maybe_unused)
>  {
> -	unsigned char *build_id[BUILD_ID_SIZE];
> +	Elf_Ehdr *ehdr = ss->ptr;
> +	Elf_Sym *symtab;
> +	size_t i, nr_sym;
>  	int ret;
>  
>  	if (dso->kernel)
> @@ -342,11 +406,74 @@ int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
>  	if (ret >= 0)
>  		dso->is_64_bit = ret;
>  
> -	if (filename__read_build_id(ss->name, build_id, BUILD_ID_SIZE) > 0) {
> -		dso__set_build_id(dso, build_id);
> -		return 1;
> +	if (dso->has_build_id) {
> +		u8 build_id[BUILD_ID_SIZE];
> +
> +		if (filename__read_build_id(ss->name, build_id, BUILD_ID_SIZE) < 0)
> +			return -1;
> +
> +		if (!dso__build_id_equal(dso, build_id))
> +			return -1;
>  	}
> -	return 0;
> +
> +	if (map->type != MAP__FUNCTION)
> +		return 0;
> +
> +	if (!ss->symtab)
> +		return 0;
> +
> +	symtab = ss->ptr + ss->symtab->sh_offset;
> +	nr_sym = ss->symtab->sh_size / ss->symtab->sh_entsize;
> +
> +	pr_debug4("loading symbols from %s\n", ss->name);
> +	ret = 0;
> +	for (i = 0; i < nr_sym; i++) {
> +		struct symbol *s;
> +		Elf_Sym *sym = &symtab[i];
> +		const char *symname = symsrc__symname(ss, ss->strtab, sym->st_name);
> +		unsigned long sym_addr = sym->st_value;
> +
> +		if (ELF_ST_TYPE(sym->st_info) != STT_FUNC)
> +			continue;
> +
> +		if (sym->st_shndx == SHN_UNDEF)
> +			continue;
> +
> +		if (ehdr->e_machine == EM_ARM) {
> +			/* Reject ARM ELF "mapping symbols": these aren't unique
> +			 * and don't identify functions, so will confuse the
> +			 * profile output: */
> +			if (!strcmp(symname, "$a") ||
> +			    !strcmp(symname, "$d") ||
> +			    !strcmp(symname, "$t"))
> +				continue;
> +
> +			/* On ARM, symbols for thumb functions have 1 added to
> +			 * the symbol address as a flag - remove it */
> +			if (sym->st_value & 1)
> +				sym_addr--;
> +		}
> +		sym_addr -= ss->adjust_offset;
> +
> +		pr_debug4("sym: %s (%lx+%lu)\n", symname, sym_addr, sym->st_size);
> +		s = symbol__new(sym_addr, sym->st_size,
> +				ELF_ST_BIND(sym->st_info), symname);
> +		if (!s)
> +			break;
> +
> +		if (filter && filter(map, s))
> +			symbol__delete(s);
> +		else {
> +			symbols__insert(&dso->symbols[map->type], s);
> +			ret++;
> +		}
> +	}
> +
> +	if (ret > 0) {
> +		symbols__fixup_duplicate(&dso->symbols[map->type]);
> +		symbols__fixup_end(&dso->symbols[map->type]);
> +	}
> +	return ret;
>  }
>  
>  int file__read_maps(int fd __maybe_unused, bool exe __maybe_unused,
> diff --git a/tools/perf/util/symbol-minimal.h b/tools/perf/util/symbol-minimal.h
> new file mode 100644
> index 000000000000..7b8b38426359
> --- /dev/null
> +++ b/tools/perf/util/symbol-minimal.h
> @@ -0,0 +1,64 @@
> +#ifndef __PERF_SYMBOL_MINIMAL_H
> +#define __PERF_SYMBOL_MINIMAL_H
> +
> +#include <elf.h>
> +#include <linux/bitops.h>
> +
> +#if BITS_PER_LONG == 32
> +
> +# define ELFCLASS	ELFCLASS32
> +
> +# define Elf_Half	Elf32_Half
> +# define Elf_Word	Elf32_Word
> +# define Elf_Sword	Elf32_Sword
> +# define Elf_Xword	Elf32_Xword
> +# define Elf_Sxword	Elf32_Sxword
> +# define Elf_Addr	Elf32_Addr
> +# define Elf_Off	Elf32_Off
> +# define Elf_Section	Elf32_Section
> +# define Elf_Versym	Elf32_Versym
> +
> +# define Elf_Ehdr	Elf32_Ehdr
> +# define Elf_Phdr	Elf32_Phdr
> +# define Elf_Shdr	Elf32_Shdr
> +# define Elf_Nhdr	Elf32_Nhdr
> +# define Elf_Sym	Elf32_Sym
> +# define Elf_Syminfo	Elf32_Syminfo
> +# define Elf_Rel	Elf32_Rel
> +# define Elf_Rela	Elf32_Rela
> +# define Elf_Dyn	Elf32_Dyn
> +
> +# define ELF_ST_BIND(val)		ELF32_ST_BIND(val)
> +# define ELF_ST_TYPE(val)		ELF32_ST_TYPE(val)
> +# define ELF_ST_INFO(bind, type)	ELF32_ST_INFO(bind, type)
> +
> +#else /* BITS_PER_LONG == 64 */
> +
> +# define ELFCLASS	ELFCLASS64
> +
> +# define Elf_Half	Elf64_Half
> +# define Elf_Word	Elf64_Word
> +# define Elf_Sword	Elf64_Sword
> +# define Elf_Xword	Elf64_Xword
> +# define Elf_Sxword	Elf64_Sxword
> +# define Elf_Addr	Elf64_Addr
> +# define Elf_Off	Elf64_Off
> +# define Elf_Section	Elf64_Section
> +# define Elf_Versym	Elf64_Versym
> +
> +# define Elf_Ehdr	Elf64_Ehdr
> +# define Elf_Phdr	Elf64_Phdr
> +# define Elf_Shdr	Elf64_Shdr
> +# define Elf_Nhdr	Elf64_Nhdr
> +# define Elf_Sym	Elf64_Sym
> +# define Elf_Syminfo	Elf64_Syminfo
> +# define Elf_Rel	Elf64_Rel
> +# define Elf_Rela	Elf64_Rela
> +# define Elf_Dyn	Elf64_Dyn
> +
> +# define ELF_ST_BIND(val)		ELF64_ST_BIND(val)
> +# define ELF_ST_TYPE(val)		ELF64_ST_TYPE(val)
> +# define ELF_ST_INFO(bind, type)	ELF64_ST_INFO(bind, type)
> +
> +#endif /* BITS_PER_LONG == 64 */
> +#endif /* __PERF_SYMBOL_MINIMAL_H */
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index ded3ca7266de..1c1dc5b9b3f8 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -18,8 +18,9 @@
>  #ifdef HAVE_LIBELF_SUPPORT
>  #include <libelf.h>
>  #include <gelf.h>
> +#else
> +#include "symbol-minimal.h"
>  #endif
> -#include <elf.h>
>  
>  #include "dso.h"
>  
> @@ -229,6 +230,13 @@ struct symsrc {
>  
>  	bool adjust_symbols;
>  	bool is_64_bit;
> +#else
> +	void *ptr;
> +	size_t len;
> +	Elf_Shdr *sec;
> +	Elf_Shdr *symtab;
> +	Elf_Shdr *strtab;
> +	long adjust_offset;
>  #endif
>  };
>  
> -- 
> 2.1.2
