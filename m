Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbbAVP3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:29:52 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:46270 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbAVP3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:29:50 -0500
Date: Thu, 22 Jan 2015 15:29:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Victor Kamensky <victor.kamensky@linaro.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, Dave Martin <Dave.Martin@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 2/3] perf symbols: improve abi compliance in arm
 mapping symbols handling
Message-ID: <20150122152908.GA26493@n2100.arm.linux.org.uk>
References: <1421902378-3634-1-git-send-email-victor.kamensky@linaro.org>
 <1421902378-3634-3-git-send-email-victor.kamensky@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421902378-3634-3-git-send-email-victor.kamensky@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 08:52:57PM -0800, Victor Kamensky wrote:
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
> Acked-by: Will Deacon <will.deacon@arm.com>
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
> Cc: Dave Martin <Dave.Martin@arm.com>
> ---
>  tools/perf/util/symbol-elf.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index 1e188dd..7fd35d6 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -857,17 +857,16 @@ int dso__load_sym(struct dso *dso, struct map *map,
>  		 * don't identify functions, so will confuse the profile
>  		 * output: */
>  		if (ehdr.e_machine == EM_ARM) {
> -			if (!strcmp(elf_name, "$a") ||
> -			    !strcmp(elf_name, "$d") ||
> -			    !strcmp(elf_name, "$t"))
> +			if (elf_name[0] == '$' && strchr("adt", elf_name[1])
> +			    && (elf_name[2] == '\0' || elf_name[2] == '.'))
>  				continue;
>  		}
>  		/* Reject Aarch64 ELF "mapping symbols": these aren't unique and
>  		 * don't identify functions, so will confuse the profile
>  		 * output: */
>  		if (ehdr.e_machine == EM_AARCH64) {
> -			if (!strcmp(elf_name, "$x") ||
> -			    !strcmp(elf_name, "$d"))
> +			if (elf_name[0] == '$' && strchr("dx", elf_name[1])
> +			    && (elf_name[2] == '\0' || elf_name[2] == '.'))
>  				continue;
>  		}

Why not fix this first?  Then, all you'd need to do would be to change
the test for EM_ARM to EM_ARM or EM_AARCH64, and add the 'x' into the
strchr() string.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
