Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964782AbaDIPgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:36:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933353AbaDIPgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:36:00 -0400
Date: Wed, 9 Apr 2014 17:35:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Vladimir Nikulichev <nvs@tbricks.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-perf-users@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Correctly handle symbols in VDSO
Message-ID: <20140409153546.GA19506@krava.brq.redhat.com>
References: <D6A5CDD8-F8F1-4C9D-8BCF-83A739FD6A2F@tbricks.com>
 <87eh19y8cm.fsf@sejong.aot.lge.com>
 <3C60FB26-A78B-4E37-B4A6-E6F7283CEB4C@tbricks.com>
 <20140408154101.GA21094@krava.brq.redhat.com>
 <A7CC2084-4F71-436C-9AEC-394F66A4981E@tbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A7CC2084-4F71-436C-9AEC-394F66A4981E@tbricks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 10:46:13AM +0400, Vladimir Nikulichev wrote:
> Hi,
> 
> On Apr 8, 2014, at 7:41 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > hi,
> > could you please put explanation from first email
> > into the patch changelog?
> > 
> > cc-ing lkml
> > 
> > thanks,
> > jirka
> 
> 
> OK, pasting it together:

ook

hum, your email's encoding kills my 'git am' :-\
also 'perf tools: Adjust symbols in VDSO' should go into the
email subject

I processed this patch by hand this time

thanks,
jirka

> 
> ---------------------------------------------------------------------------------------------------------------------------
> 
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
> In this case symbol values should be adjusted the same way as for executables, relocatable objects and prelinked libraries.
> 
> After fix:
> 
> $ perf report --stdio -g flat,0.0,15,callee --sort pid
> ...
>             8.76%
>                __vdso_gettimeofday
>                __gettimeofday
>                ACE_OS::gettimeofday()
> …
> 
> Signed-off-by: Vladimir Nikulichev <nvs@tbricks.com>
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
> @@ -618,6 +619,7 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
> 		GElf_Shdr shdr;
> 		ss->adjust_symbols = (ehdr.e_type == ET_EXEC ||
> 				ehdr.e_type == ET_REL ||
> +				is_vdso_map(dso->short_name) ||
> 				elf_section_by_name(elf, &ehdr, &shdr,
> 						     ".gnu.prelink_undo",
> 						     NULL) != NULL);
