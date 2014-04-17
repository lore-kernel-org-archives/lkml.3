Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbaDQIra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:47:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:44368 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbaDQIr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:47:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,877,1389772800"; 
   d="scan'208";a="514651695"
Message-ID: <534F94F2.7020402@intel.com>
Date: Thu, 17 Apr 2014 11:46:42 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Vladimir Nikulichev <nvs@tbricks.com>, Jiri Olsa <jolsa@redhat.com>
CC: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Adjust symbols in VDSO
References: <web-7508803@mx2.tbricks.com>
In-Reply-To: <web-7508803@mx2.tbricks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 05:25 PM, Vladimir Nikulichev wrote:
> perf tools: Adjust symbols in VDSO
> 
> pert-report doesn't resolve function names in VDSO:
> 
> $ perf report --stdio -g flat,0.0,15,callee --sort pid
> ...
>             8.76%
>                0x7fff6b1fe861
>                __gettimeofday
>                ACE_OS::gettimeofday()
> ...
> 
> In this case symbol values should be adjusted the same way as for executables,
> relocatable objects and prelinked libraries.
> 
> After fix:
> 
> $ perf report --stdio -g flat,0.0,15,callee --sort pid
> ...
>             8.76%
>                __vdso_gettimeofday
>                __gettimeofday
>                ACE_OS::gettimeofday()
> 
> Signed-off-by: Vladimir Nikulichev <nvs@tbricks.com>

Annotation still doesn't work. but this is a start, so:

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>


> 
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index 3b7dbf5..6864661 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -6,6 +6,7 @@
> #include <inttypes.h>
> 
> #include "symbol.h"
> +#include "vdso.h"
> #include <symbol/kallsyms.h>
> #include "debug.h"
> 
> @@ -618,6 +619,7 @@ int symsrc__init(struct symsrc *ss, struct dso *dso,
> const char *name,
>         GElf_Shdr shdr;
>         ss->adjust_symbols = (ehdr.e_type == ET_EXEC ||
>                 ehdr.e_type == ET_REL ||
> +                is_vdso_map(dso->short_name) ||
>                 elf_section_by_name(elf, &ehdr, &shdr,
>                              ".gnu.prelink_undo",
>                              NULL) != NULL);

