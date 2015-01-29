Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbbA2Bkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:40:43 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52567 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497AbbA2Bkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:40:41 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 29 Jan 2015 10:38:09 +0900
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
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jiri Olsa <jolsa@kernel.org>, Waiman Long <Waiman.Long@hp.com>
Subject: Re: [PATCH V3 2/2] perf symbols: debuglink should take symfs option
 into account
Message-ID: <20150129013809.GB24182@sejong>
References: <1422340442-4673-1-git-send-email-victor.kamensky@linaro.org>
 <1422340442-4673-3-git-send-email-victor.kamensky@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1422340442-4673-3-git-send-email-victor.kamensky@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Victor,

On Mon, Jan 26, 2015 at 10:34:02PM -0800, Victor Kamensky wrote:
> Currently code that tries to read corresponding debug symbol
> file from .gnu_debuglink section (DSO_BINARY_TYPE__DEBUGLINK)
> does not take in account symfs option, so filename__read_debuglink
> function cannot open ELF file, if symfs option is used.
> 
> Fix is to add proper handling of symfs as it is done in other
> places: use __symbol__join_symfs function to get real file name
> of target ELF file.
> 
> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Waiman Long <Waiman.Long@hp.com>
> Cc: David Ahern <dsahern@gmail.com>
> Acked-and-tested-by: David Ahern <dsahern@gmail.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/perf/util/dso.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
> index 45be944..ca8d8d5 100644
> --- a/tools/perf/util/dso.c
> +++ b/tools/perf/util/dso.c
> @@ -45,13 +45,13 @@ int dso__read_binary_type_filename(const struct dso *dso,
>  	case DSO_BINARY_TYPE__DEBUGLINK: {
>  		char *debuglink;
>  
> -		strncpy(filename, dso->long_name, size);
> -		debuglink = filename + dso->long_name_len;
> +		len = __symbol__join_symfs(filename, size, dso->long_name);
> +		debuglink = filename + len;
>  		while (debuglink != filename && *debuglink != '/')
>  			debuglink--;
>  		if (*debuglink == '/')
>  			debuglink++;
> -		ret = filename__read_debuglink(dso->long_name, debuglink,
> +		ret = filename__read_debuglink(filename, debuglink,
>  					       size - (debuglink - filename));
>  		}
>  		break;
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
