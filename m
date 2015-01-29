Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbbA2Blt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:41:49 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:40039 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbbA2Blq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:41:46 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 29 Jan 2015 10:39:14 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Victor Kamensky <victor.kamensky@linaro.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Russell King <linux@arm.linux.org.uk>, David Ahern <dsahern@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, Dave Martin <Dave.Martin@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 1/2] perf symbols: Ignore mapping symbols on aarch64
Message-ID: <20150129013914.GC24182@sejong>
References: <1422340442-4673-1-git-send-email-victor.kamensky@linaro.org>
 <1422340442-4673-2-git-send-email-victor.kamensky@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1422340442-4673-2-git-send-email-victor.kamensky@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 10:34:01PM -0800, Victor Kamensky wrote:
> Aarch64 ELF files use mapping symbols with special names $x, $d
> to identify regions of Aarch64 code (see Aarch64 ELF ABI - "ARM
> IHI 0056B", section "4.5.4 Mapping symbols").
> 
> The patch filters out these symbols at load time, similar to
> "696b97a perf symbols: Ignore mapping symbols on ARM" changes
> done for ARM before V8.
> 
> Also added handling of mapping symbols that has format
> "$d.<any>" and similar for both cases.
> 
> Note we are not making difference between EM_ARM and
> EM_AARCH64 mapping symbols instead code handles superset
> of both.
> 
> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
> Acked-by: Will Deacon <will.deacon@arm.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Avi Kivity <avi@cloudius-systems.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Anton Blanchard <anton@samba.org>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Dave Martin <Dave.Martin@arm.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/perf/util/symbol-elf.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index 06fcd1b..8fc6e2f 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -856,10 +856,9 @@ int dso__load_sym(struct dso *dso, struct map *map,
>  		/* Reject ARM ELF "mapping symbols": these aren't unique and
>  		 * don't identify functions, so will confuse the profile
>  		 * output: */
> -		if (ehdr.e_machine == EM_ARM) {
> -			if (!strcmp(elf_name, "$a") ||
> -			    !strcmp(elf_name, "$d") ||
> -			    !strcmp(elf_name, "$t"))
> +		if (ehdr.e_machine == EM_ARM || ehdr.e_machine == EM_AARCH64) {
> +			if (elf_name[0] == '$' && strchr("adtx", elf_name[1])
> +			    && (elf_name[2] == '\0' || elf_name[2] == '.'))
>  				continue;
>  		}
>  
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
