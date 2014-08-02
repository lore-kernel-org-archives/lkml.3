Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaHBNfJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 09:35:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:42104 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbaHBNfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 09:35:07 -0400
Date: Sat, 2 Aug 2014 10:35:03 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 8/8] perf symbol: Don't demangle parameters and such by
 default
Message-ID: <20140802133503.GE13375@kernel.org>
References: <1406785662-5534-1-git-send-email-namhyung@kernel.org>
 <1406785662-5534-9-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406785662-5534-9-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 31, 2014 at 02:47:42PM +0900, Namhyung Kim escreveu:
> Some C++ symbols have very long name and they make column length
> longer.  Most of them are about parameters including templates and we
> can ignore such info most of time IMHO.
> 
> This patch passes DMGL_NO_OPTS by default when calling bfd_demangle().
> One can still see full symbols with -v/--verbose option.
> 
> before:
>   JS_CallFunctionValue(JSContext*, JSObject*, JS::Value, unsigned int, JS::Value*, JS::Value*)
> 
> after:
>   JS_CallFunctionValue

Are you sure we want that?

With this we'll end up having different instantiations having the same
name, since the way to differentiate them is exactly by a different
parameter list, no?

- Arnaldo
 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/symbol-elf.c | 7 +++++--
>  tools/perf/util/symbol.h     | 1 +
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index d75349979e65..ec5ec1c9d9b5 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -939,8 +939,11 @@ new_symbol:
>  		 * to it...
>  		 */
>  		if (symbol_conf.demangle) {
> -			demangled = bfd_demangle(NULL, elf_name,
> -						 DMGL_PARAMS | DMGL_ANSI);
> +			int demangle_flags = DMGL_NO_OPTS;
> +			if (verbose)
> +				demangle_flags = DMGL_PARAMS | DMGL_ANSI;
> +
> +			demangled = bfd_demangle(NULL, elf_name, demangle_flags);
>  			if (demangled != NULL)
>  				elf_name = demangled;
>  		}
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index e7295e93cff9..c16dc16f83d5 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -59,6 +59,7 @@ extern Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
>  #endif
>  
>  #ifndef DMGL_PARAMS
> +#define DMGL_NO_OPTS     0              /* For readability... */
>  #define DMGL_PARAMS      (1 << 0)       /* Include function args */
>  #define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
>  #endif
> -- 
> 2.0.0
