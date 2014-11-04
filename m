Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaKDN3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:29:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:50631 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbaKDN3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:29:10 -0500
Date: Tue, 4 Nov 2014 10:29:04 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf record: Do not save pathname in
 ./debug/.build-id directory for vmlinux
Message-ID: <20141104132904.GE18464@kernel.org>
References: <1415063674-17206-1-git-send-email-namhyung@kernel.org>
 <1415063674-17206-7-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415063674-17206-7-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 04, 2014 at 10:14:32AM +0900, Namhyung Kim escreveu:
> When perf record finishes a session recording, it then pre-process
> samples in order to write build-id info from actually used DSOs.
> During this process it'll call map__load() for kernel map, and it ends
> up calling dso__load_vmlinux_path() which replaces dso->long_name.

Can't we achieve the same end result without introducing yet another
symbol_conf entry?

I think there are way too many there, we need to remove, not add :-\

I'll add this since it improve the end result, but if you don't beat me
to it I'll try to remove this symbol_conf entry while keeping the end
result you achieved with it.

- Arnaldo
 
> But this function checks kernel's build-id before searching vmlinux
> path so it'll have the cryptic name which can be confusing to users IMHO.
> 
> This patch adds a flag to skip the build-id check during record, so
> it'll have a vmlinux path for the kernel dso->long_name.
> 
> Before:
>   # perf record -va sleep 3
>   mmap size 528384B
>   [ perf record: Woken up 1 times to write data ]
>   [ perf record: Captured and wrote 0.196 MB perf.data (~8545 samples) ]
>   Looking at the vmlinux_path (7 entries long)
>   Using /home/namhyung/.debug/.build-id/f0/6e17aa50adf4d00b88925e03775de107611551 for symbols
> 
> After:
>   # perf record -va sleep 3
>   mmap size 528384B
>   [ perf record: Woken up 1 times to write data ]
>   [ perf record: Captured and wrote 0.193 MB perf.data (~8432 samples) ]
>   Looking at the vmlinux_path (7 entries long)
>   Using /lib/modules/3.16.4-1-ARCH/build/vmlinux for symbols
 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-record.c | 11 +++++++++++
>  tools/perf/util/symbol.c    | 11 ++++++-----
>  tools/perf/util/symbol.h    |  1 +
>  3 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 5091a27e6d28..582c4da155ea 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -200,6 +200,17 @@ static int process_buildids(struct record *rec)
>  	if (size == 0)
>  		return 0;
>  
> +	/*
> +	 * During this process, it'll load kernel map and replace the
> +	 * dso->long_name to a real pathname it found.  In this case
> +	 * we prefer the vmlinux path like
> +	 *   /lib/modules/3.16.4/build/vmlinux
> +	 *
> +	 * rather than build-id path (in debug directory).
> +	 *   $HOME/.debug/.build-id/f0/6e17aa50adf4d00b88925e03775de107611551
> +	 */
> +	symbol_conf.ignore_vmlinux_buildid = true;
> +
>  	return __perf_session__process_events(session, start,
>  					      size - start,
>  					      size, &build_id__mark_dso_hit_ops);
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index c69915c9d5bc..c24c5b83156c 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1511,12 +1511,10 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
>  			   symbol_filter_t filter)
>  {
>  	int i, err = 0;
> -	char *filename;
> +	char *filename = NULL;
>  
> -	pr_debug("Looking at the vmlinux_path (%d entries long)\n",
> -		 vmlinux_path__nr_entries + 1);
> -
> -	filename = dso__build_id_filename(dso, NULL, 0);
> +	if (!symbol_conf.ignore_vmlinux_buildid)
> +		filename = dso__build_id_filename(dso, NULL, 0);
>  	if (filename != NULL) {
>  		err = dso__load_vmlinux(dso, map, filename, true, filter);
>  		if (err > 0)
> @@ -1524,6 +1522,9 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
>  		free(filename);
>  	}
>  
> +	pr_debug("Looking at the vmlinux_path (%d entries long)\n",
> +		 vmlinux_path__nr_entries + 1);
> +
>  	for (i = 0; i < vmlinux_path__nr_entries; ++i) {
>  		err = dso__load_vmlinux(dso, map, vmlinux_path[i], false, filter);
>  		if (err > 0)
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index eb2c19bf8d90..ded3ca7266de 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -105,6 +105,7 @@ struct symbol_conf {
>  	unsigned short	nr_events;
>  	bool		try_vmlinux_path,
>  			ignore_vmlinux,
> +			ignore_vmlinux_buildid,
>  			show_kernel_path,
>  			use_modules,
>  			sort_by_name,
> -- 
> 2.1.2
