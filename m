Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaHNSz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 14:55:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:38852 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbaHNSzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 14:55:55 -0400
Date: Thu, 14 Aug 2014 15:55:49 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf probe: Warn user to rebuild target with debuginfo
Message-ID: <20140814185549.GB2451@kernel.org>
References: <53ECF7E9.3050200@hitachi.com>
 <20140814182938.13429.90615.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140814182938.13429.90615.stgit@kbuild-fedora.novalocal>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 14, 2014 at 06:29:38PM +0000, Masami Hiramatsu escreveu:
> Warn user to rebuild target with debuginfo when the perf probe
> fails to find debug information in the target binary.
> Without this, perf probe just reports the failure, but it's
> no hint for users. This gives more hint for users.
> 
> Without this,

That was quick!

The changelog also was nicely written, stating the problem, then
providing an example to exhibit the problem before the patch, then the
end result, with the intended behaviour, after the patch.

Thanks a lot!

- Arnaldo
 
>   $ strip perf
>   $ ./perf probe -x perf -L argv_split
>   Failed to open debuginfo file.
>     Error: Failed to show lines.
> 
> With this,
> 
>   $ strip perf
>   $ ./perf probe -x perf -L argv_split
>   The /home/fedora/ksrc/linux-3/tools/perf/perf file has no debug information, rebuild with -g.
>     Error: Failed to show lines.
> 
> The "rebuild with ..." part changes to "rebuild with CONFIG_DEBUG_INFO"
> if the target is the kernel or a kernel module.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/util/probe-event.c |   40 ++++++++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 784ea42..57eb343 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -258,21 +258,32 @@ static void clear_probe_trace_events(struct probe_trace_event *tevs, int ntevs)
>  #ifdef HAVE_DWARF_SUPPORT
>  
>  /* Open new debuginfo of given module */
> -static struct debuginfo *open_debuginfo(const char *module)
> +static struct debuginfo *open_debuginfo(const char *module, bool silent)
>  {
>  	const char *path = module;
> +	struct debuginfo *ret;
>  
>  	if (!module || !strchr(module, '/')) {
>  		path = kernel_get_module_path(module);
>  		if (!path) {
> -			pr_err("Failed to find path of %s module.\n",
> -			       module ?: "kernel");
> +			if (!silent)
> +				pr_err("Failed to find path of %s module.\n",
> +				       module ?: "kernel");
>  			return NULL;
>  		}
>  	}
> -	return debuginfo__new(path);
> +	ret = debuginfo__new(path);
> +	if (!ret && !silent) {
> +		pr_warning("The %s file has no debug information, ", path);
> +		if (!module || !strtailcmp(path, ".ko"))
> +			pr_warning("rebuild with CONFIG_DEBUG_INFO=y.\n");
> +		else
> +			pr_warning("rebuild with -g.\n");
> +	}
> +	return ret;
>  }
>  
> +
>  static int get_text_start_address(const char *exec, unsigned long *address)
>  {
>  	Elf *elf;
> @@ -333,15 +344,13 @@ static int find_perf_probe_point_from_dwarf(struct probe_trace_point *tp,
>  	pr_debug("try to find information at %" PRIx64 " in %s\n", addr,
>  		 tp->module ? : "kernel");
>  
> -	dinfo = open_debuginfo(tp->module);
> +	dinfo = open_debuginfo(tp->module, verbose == 0);
>  	if (dinfo) {
>  		ret = debuginfo__find_probe_point(dinfo,
>  						 (unsigned long)addr, pp);
>  		debuginfo__delete(dinfo);
> -	} else {
> -		pr_debug("Failed to open debuginfo at 0x%" PRIx64 "\n", addr);
> +	} else
>  		ret = -ENOENT;
> -	}
>  
>  	if (ret > 0) {
>  		pp->retprobe = tp->retprobe;
> @@ -457,13 +466,11 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
>  	struct debuginfo *dinfo;
>  	int ntevs, ret = 0;
>  
> -	dinfo = open_debuginfo(target);
> +	dinfo = open_debuginfo(target, !need_dwarf);
>  
>  	if (!dinfo) {
> -		if (need_dwarf) {
> -			pr_warning("Failed to open debuginfo file.\n");
> +		if (need_dwarf)
>  			return -ENOENT;
> -		}
>  		pr_debug("Could not open debuginfo. Try to use symbols.\n");
>  		return 0;
>  	}
> @@ -620,11 +627,9 @@ static int __show_line_range(struct line_range *lr, const char *module)
>  	char *tmp;
>  
>  	/* Search a line range */
> -	dinfo = open_debuginfo(module);
> -	if (!dinfo) {
> -		pr_warning("Failed to open debuginfo file.\n");
> +	dinfo = open_debuginfo(module, false);
> +	if (!dinfo)
>  		return -ENOENT;
> -	}
>  
>  	ret = debuginfo__find_line_range(dinfo, lr);
>  	debuginfo__delete(dinfo);
> @@ -772,9 +777,8 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
>  	if (ret < 0)
>  		return ret;
>  
> -	dinfo = open_debuginfo(module);
> +	dinfo = open_debuginfo(module, false);
>  	if (!dinfo) {
> -		pr_warning("Failed to open debuginfo file.\n");
>  		ret = -ENOENT;
>  		goto out;
>  	}
