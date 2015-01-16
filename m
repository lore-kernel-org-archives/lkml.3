Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbbAPJ46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 04:56:58 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:35496 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbbAPJ4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 04:56:50 -0500
Date: Fri, 16 Jan 2015 09:56:45 +0000
From: Will Deacon <will.deacon@arm.com>
To: Victor Kamensky <victor.kamensky@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Avi Kivity <avi@cloudius-systems.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] perf symbols: Ignore mapping symbols on aarch64
Message-ID: <20150116095644.GA7091@arm.com>
References: <1421168344-5363-1-git-send-email-victor.kamensky@linaro.org>
 <20150114112210.GF4050@arm.com>
 <CAA3XUr2KUyafcnUggN7=xGNGSeRkkRtYtxZmwm4UC8sRCGup3g@mail.gmail.com>
 <20150115000305.GC12302@n2100.arm.linux.org.uk>
 <CAA3XUr2ej57VxAF1D3tbhjcVFtgyvHWKQxMiTBJ9RcmYCUHekQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA3XUr2ej57VxAF1D3tbhjcVFtgyvHWKQxMiTBJ9RcmYCUHekQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 02:51:06AM +0000, Victor Kamensky wrote:
> On 14 January 2015 at 16:03, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Wed, Jan 14, 2015 at 10:38:38AM -0800, Victor Kamensky wrote:
> >> >From fed6caab410ddcaf487ff23a3908eca129e50b89 Mon Sep 17 00:00:00 2001
> >> From: Victor Kamensky <victor.kamensky@linaro.org>
> >> Date: Wed, 14 Jan 2015 07:42:41 -0800
> >> Subject: [PATCH 3/3] perf symbols: improve abi compliance in arm mapping
> >>  symbols handling
> >>
> >> Both Arm and Aarch64 ELF ABI allow mapping symbols be in from
> >> either "$d" or "$d.<any>". But current code that handles mapping
> >> symbols only deals with the first, dollar character and a single
> >> letter, case.
> >>
> >> The patch adds handling of the second case with period
> >> followed by any characters.
> >>
> >> Suggested-by: Will Deacon <will.deacon@arm.com>
> >> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
> >
> > I wonder if it would make more sense to re-use the "is_arm_mapping_symbol"
> > thing which we have in kernel/module.c and scripts/kallsyms.c - it
> > seems silly to re-invent code which we already have to detect these
> > symbols.
> 
> Thanks for pointing this out. I did not know about
> "is_arm_mapping_symbol" function.
> 
> Do you suggest we copy one of those functions into tools/perf?
> Since tools/perf is separate user-land utility I don't see easy way
> how can we reuse those directly.
> 
> Also those functions check for mapping symbols
> seems to be more efficient that one I come with, for example
> one from scripts/kallsyms.c
> 
> static inline int is_arm_mapping_symbol(const char *str)
> {
>     return str[0] == '$' && strchr("axtd", str[1])
>            && (str[2] == '\0' || str[2] == '.');
> }
> 
> But it seems that they are somewhat accurate: because they bundle
> EM_ARM and EM_AARCH64 into one case. According to ABIs
> for EM_ARM we have $a, $t, $d, $a.<any>, $t.<any>, $d.<any>;
> and for EM_AARCH64 we have $x, $d, $x.<any>, $d.<any>.
> 
> How about the following two variants of the patch. It follows the same
> mapping handling logic as in other 3 copies of is_arm_mapping_symbol
> function in kernel, but it still separate copy in tools/perf code. Personally I
> prefer variant 1, but I am fine with variant 2 too, because practically it
> will be OK.

They both look fine to me; pick your favourite.

Acked-by: Will Deacon <will.deacon@arm.com>

Will

> Variant 1 (as addition to this patch, as above):
> 
> From e08d348bd72d406d8939993d266729d805577c4b Mon Sep 17 00:00:00 2001
> From: Victor Kamensky <victor.kamensky@linaro.org>
> Date: Wed, 14 Jan 2015 07:42:41 -0800
> Subject: [PATCH 3/3] perf symbols: improve abi compliance in arm mapping
>  symbols handling
> 
> Both Arm and Aarch64 ELF ABI allow mapping symbols be in from
> either "$d" or "$d.<any>". But current code that handles mapping
> symbols only deals with the first, dollar character and a single
> letter, case.
> 
> The patch adds handling of the second case with period
> followed by any characters.
> 
> Suggested-by: Russell King <linux@arm.linux.org.uk>
> Suggested-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
> ---
>  tools/perf/util/symbol-elf.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index 1e188dd..a038c98 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -857,17 +857,16 @@ int dso__load_sym(struct dso *dso, struct map *map,
>           * don't identify functions, so will confuse the profile
>           * output: */
>          if (ehdr.e_machine == EM_ARM) {
> -            if (!strcmp(elf_name, "$a") ||
> -                !strcmp(elf_name, "$d") ||
> -                !strcmp(elf_name, "$t"))
> +                        if (elf_name[0] == '$' && strchr("adt", elf_name[1])
> +                        && (elf_name[2] == '\0' || elf_name[2] == '.'))
>                  continue;
>          }
>          /* Reject Aarch64 ELF "mapping symbols": these aren't unique and
>           * don't identify functions, so will confuse the profile
>           * output: */
>          if (ehdr.e_machine == EM_AARCH64) {
> -            if (!strcmp(elf_name, "$x") ||
> -                !strcmp(elf_name, "$d"))
> +                        if (elf_name[0] == '$' && strchr("dx", elf_name[1])
> +                        && (elf_name[2] == '\0' || elf_name[2] == '.'))
>                  continue;
>          }
> 
> -- 
> 1.9.3
> 
> Variant 2 instead of patch posted with current subject:
> 
>  From c8d08ebddc61203daf21b17c891c26c1d08e14f1 Mon Sep 17 00:00:00 2001
> From: Victor Kamensky <victor.kamensky@linaro.org>
> Date: Mon, 12 Jan 2015 14:13:36 -0800
> Subject: [PATCH 1/2] perf symbols: Ignore mapping symbols on aarch64
> 
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
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Dave Martin <Dave.Martin@arm.com>
> ---
>  tools/perf/util/symbol-elf.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index 06fcd1b..b2eb0f9 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -856,10 +856,9 @@ int dso__load_sym(struct dso *dso, struct map *map,
>          /* Reject ARM ELF "mapping symbols": these aren't unique and
>           * don't identify functions, so will confuse the profile
>           * output: */
> -        if (ehdr.e_machine == EM_ARM) {
> -            if (!strcmp(elf_name, "$a") ||
> -                !strcmp(elf_name, "$d") ||
> -                !strcmp(elf_name, "$t"))
> +        if (ehdr.e_machine == EM_ARM || ehdr.e_machine == EM_AARCH64) {
> +                        if (elf_name[0] == '$' && strchr("adtx", elf_name[1])
> +                        && (elf_name[2] == '\0' || elf_name[2] == '.'))
>                  continue;
>          }
> 
> -- 
> 1.9.3
> 
> Thanks,
> Victor
> 
> > --
> > FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
> > according to speedtest.net.
> 
