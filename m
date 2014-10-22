Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaJVGoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:44:21 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:34825 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaJVGoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:44:20 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Waiman Long <Waiman.Long@hp.com>,
        <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] perf tools: makes CPUINFO_PROC to array for different kernel version
References: <1413428923-80073-1-git-send-email-wangnan0@huawei.com>
Date: Wed, 22 Oct 2014 15:44:18 +0900
In-Reply-To: <1413428923-80073-1-git-send-email-wangnan0@huawei.com> (Wang
	Nan's message of "Thu, 16 Oct 2014 11:08:43 +0800")
Message-ID: <87wq7seh8d.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang,

On Thu, 16 Oct 2014 11:08:43 +0800, Wang Nan wrote:
> After kerne 3.7 (commit b4b8f770eb10a1bccaf8aa0ec1956e2dd7ed1e0a),
> /proc/cpuinfo replcae 'Processor' to 'model name'. This patch makes
> CPUINFO_PROC to an array and provides two choices for ARM, make it
> compatible for different kernel version.
>
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> -static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
> -		       struct perf_evlist *evlist __maybe_unused)
> +static int __write_cpudesc(int fd, struct perf_header *h __maybe_unused,
> +		       struct perf_evlist *evlist __maybe_unused, const char *cpuinfo_proc)

You don't need to pass @h and @evlist if they're not used.


>  {
> -#ifndef CPUINFO_PROC
> -#define CPUINFO_PROC NULL
> -#endif
>  	FILE *file;
>  	char *buf = NULL;
>  	char *s, *p;
> -	const char *search = CPUINFO_PROC;
> +	const char *search = cpuinfo_proc;
>  	size_t len = 0;
>  	int ret = -1;
>  
> @@ -640,6 +637,23 @@ done:
>  	return ret;
>  }
>  
> +static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
> +		       struct perf_evlist *evlist __maybe_unused)
> +{
> +#ifndef CPUINFO_PROC
> +#define CPUINFO_PROC {"model name", }
> +#endif
> +	const char *cpuinfo_procs[] = CPUINFO_PROC;
> +	unsigned int i;

Please put a blank line between declaration and the function body.

Other than that, looks good to me.

Thanks,
Namhyung


> +	for (i = 0; i < ARRAY_SIZE(cpuinfo_procs); i++) {
> +		int ret;
> +		ret = __write_cpudesc(fd, h, evlist, cpuinfo_procs[i]);
> +		if (ret >= 0)
> +			return ret;
> +	}
> +	return -1;
> +}
> +
>  static int write_nrcpus(int fd, struct perf_header *h __maybe_unused,
>  			struct perf_evlist *evlist __maybe_unused)
>  {
