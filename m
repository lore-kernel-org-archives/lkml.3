Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbbANLWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:22:18 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33748 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbbANLWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:22:17 -0500
Date: Wed, 14 Jan 2015 11:22:10 +0000
From: Will Deacon <will.deacon@arm.com>
To: Victor Kamensky <victor.kamensky@linaro.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, David Ahern <dsahern@gmail.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] perf symbols: Ignore mapping symbols on aarch64
Message-ID: <20150114112210.GF4050@arm.com>
References: <1421168344-5363-1-git-send-email-victor.kamensky@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421168344-5363-1-git-send-email-victor.kamensky@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 04:59:03PM +0000, Victor Kamensky wrote:
> Aarch64 ELF files use mapping symbols with special names $x, $d
> to identify regions of Aarch64 code (see Aarch64 ELF ABI - "ARM
> IHI 0056B", section "4.5.4 Mapping symbols").
> 
> The patch filters out these symbols at load time, similar to
> "696b97a perf symbols: Ignore mapping symbols on ARM" changes
> done for ARM before V8.
> 
> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Avi Kivity <avi@cloudius-systems.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Anton Blanchard <anton@samba.org>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Dave Martin <Dave.Martin@arm.com>
> ---
>  tools/perf/util/symbol-elf.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index 06fcd1b..1e188dd 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -862,6 +862,14 @@ int dso__load_sym(struct dso *dso, struct map *map,
>  			    !strcmp(elf_name, "$t"))
>  				continue;
>  		}
> +		/* Reject Aarch64 ELF "mapping symbols": these aren't unique and
> +		 * don't identify functions, so will confuse the profile
> +		 * output: */
> +		if (ehdr.e_machine == EM_AARCH64) {
> +			if (!strcmp(elf_name, "$x") ||
> +			    !strcmp(elf_name, "$d"))
> +				continue;
> +		}

Do we need to skip $x.* and $d.* too? I doubt GCC generates them, but they
are permitted by the ELF ABI.

Will
