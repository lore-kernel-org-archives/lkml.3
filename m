Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab3IRJY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:24:56 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:38076 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3IRJYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:24:54 -0400
Date: Wed, 18 Sep 2013 11:24:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Support for Openembedded/Yocto -dbg packages
Message-ID: <20130918092444.GA2778@gmail.com>
References: <1379493790-9554-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379493790-9554-1-git-send-email-ricardo.ribalda@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> wrote:

> On OpenEmbedded the symbol files are located under a .debug folder on
> the same folder as the binary file.
> 
> This patch adds support for such files.

It would be nice to cite before/after perf report output, to see how this 
improved things and to see the output format you picked.

> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  tools/perf/util/dso.c    | 16 ++++++++++++++++
>  tools/perf/util/dso.h    |  1 +
>  tools/perf/util/symbol.c |  1 +
>  3 files changed, 18 insertions(+)
> 
> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
> index c4374f0..bab18b7 100644
> --- a/tools/perf/util/dso.c
> +++ b/tools/perf/util/dso.c
> @@ -14,6 +14,7 @@ char dso__symtab_origin(const struct dso *dso)
>  		[DSO_BINARY_TYPE__BUILD_ID_CACHE]	= 'B',
>  		[DSO_BINARY_TYPE__FEDORA_DEBUGINFO]	= 'f',
>  		[DSO_BINARY_TYPE__UBUNTU_DEBUGINFO]	= 'u',
> +		[DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO] = 'o',
>  		[DSO_BINARY_TYPE__BUILDID_DEBUGINFO]	= 'b',
>  		[DSO_BINARY_TYPE__SYSTEM_PATH_DSO]	= 'd',
>  		[DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE]	= 'K',

Stylistic nit: if a new entry breaks vertical alignment then re-align the 
other entries as well so that it still looks nice after your change ...

> @@ -64,6 +65,21 @@ int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
>  			 symbol_conf.symfs, dso->long_name);
>  		break;
>  
> +	case DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO:{

/: {

> +		char *last_slash;
> +
> +		last_slash = dso->long_name + dso->long_name_len;
> +		while (last_slash != dso->long_name && *last_slash != '/')
> +			last_slash--;
> +
> +		snprintf(file, MIN(size, strlen(symbol_conf.symfs) +
> +				(last_slash - dso->long_name) + 2), "%s%s",
> +				symbol_conf.symfs, dso->long_name);
> +		snprintf(file + strlen(file), size-strlen(file), ".debug%s",
> +				last_slash);

So the way such multi-snprintf() sequences are implemented in the kernel 
is not this unreadable, fragile, repetitive concatenation of length 
calculations, but an adjustment of 'size':

		size -= snprintf(..., size, ...);

that way 'size' always tracks the remaining limit of the output string, 
each snprintf consumes from it.

> +		}
> +		break;

Small nit: we generally put the final break inside the block.

Besides the details it looks like a useful patch.

Thanks,

	Ingo
