Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaA2S6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:58:00 -0500
Received: from mail-yk0-f176.google.com ([209.85.160.176]:51462 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaA2S56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:57:58 -0500
Date: Wed, 29 Jan 2014 15:57:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 1/9] perf tools: Fix symbol annotation for relocated
 kernel
Message-ID: <20140129185747.GE3998@ghostprotocols.net>
References: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
 <1391004884-10334-2-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391004884-10334-2-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 29, 2014 at 04:14:36PM +0200, Adrian Hunter escreveu:
> Kernel maps map memory addresses to file offsets.
> For symbol annotation, objdump needs the object VMA
> addresses.  For an unrelocated kernel, that is the
> same as the memory address.
> 
> The addresses passed to objdump for symbol annotation
> did not take into account kernel relocation.  This
> patch fixes that.

Question: To fix the problem reported by Linus, i.e. the very minimal
fix, we only need this patch, right?

Reading the other patches now.

- Arnaldo
 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/map.c        | 5 +++--
>  tools/perf/util/map.h        | 1 +
>  tools/perf/util/symbol-elf.c | 2 ++
>  3 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index ee1dd68..b46f527 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -39,6 +39,7 @@ void map__init(struct map *map, enum map_type type,
>  	map->start    = start;
>  	map->end      = end;
>  	map->pgoff    = pgoff;
> +	map->reloc    = 0;
>  	map->dso      = dso;
>  	map->map_ip   = map__map_ip;
>  	map->unmap_ip = map__unmap_ip;
> @@ -288,7 +289,7 @@ u64 map__rip_2objdump(struct map *map, u64 rip)
>  	if (map->dso->rel)
>  		return rip - map->pgoff;
>  
> -	return map->unmap_ip(map, rip);
> +	return map->unmap_ip(map, rip) - map->reloc;
>  }
>  
>  /**
> @@ -311,7 +312,7 @@ u64 map__objdump_2mem(struct map *map, u64 ip)
>  	if (map->dso->rel)
>  		return map->unmap_ip(map, ip + map->pgoff);
>  
> -	return ip;
> +	return ip + map->reloc;
>  }
>  
>  void map_groups__init(struct map_groups *mg)
> diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
> index 18068c6..257e513 100644
> --- a/tools/perf/util/map.h
> +++ b/tools/perf/util/map.h
> @@ -36,6 +36,7 @@ struct map {
>  	bool			erange_warned;
>  	u32			priv;
>  	u64			pgoff;
> +	u64			reloc;
>  	u32			maj, min; /* only valid for MMAP2 record */
>  	u64			ino;      /* only valid for MMAP2 record */
>  	u64			ino_generation;/* only valid for MMAP2 record */
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index 7594567..8ce52da 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -751,6 +751,8 @@ int dso__load_sym(struct dso *dso, struct map *map,
>  			if (strcmp(elf_name, kmap->ref_reloc_sym->name))
>  				continue;
>  			kmap->ref_reloc_sym->unrelocated_addr = sym.st_value;
> +			map->reloc = kmap->ref_reloc_sym->addr -
> +				     kmap->ref_reloc_sym->unrelocated_addr;
>  			break;
>  		}
>  	}
> -- 
> 1.7.11.7
