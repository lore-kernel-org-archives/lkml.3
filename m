Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaBQH42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 02:56:28 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63610 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaBQH41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 02:56:27 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-fd-5301c0a87b9e
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt \(Red Hat\)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip v3 01/11] [BUGFIX] perf-probe: Fix to do exit call for symbol maps
In-Reply-To: <20140206053204.29635.28334.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
	(Masami Hiramatsu's message of "Thu, 06 Feb 2014 05:32:04 +0000")
References: <20140206053201.29635.99095.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
	<20140206053204.29635.28334.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Mon, 17 Feb 2014 16:56:24 +0900
Message-ID: <87bny6xjdj.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Thu, 06 Feb 2014 05:32:04 +0000, Masami Hiramatsu wrote:
> Some perf-probe commands do symbol_init() but doesn't
> do exit call. This fixes that to call symbol_exit()
> and releases machine if needed.
> This also merges init_vmlinux() and init_user_exec()
> because both of them are doing similar things.
> (init_user_exec() just skips init vmlinux related
>  symbol maps)
>
> Changes from v2:
>  - Not to set symbol_conf.try_vmlinux_path in init_symbol_maps()
>    (Thanks to Namhyung Kim!)
>
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

[SNIP]
> -int show_line_range(struct line_range *lr, const char *module)
> +static int __show_line_range(struct line_range *lr, const char *module)
>  {
>  	int l = 1;
>  	struct line_node *ln;
> @@ -573,10 +568,6 @@ int show_line_range(struct line_range *lr, const char *module)
>  	char *tmp;
>  
>  	/* Search a line range */
> -	ret = init_vmlinux();
> -	if (ret < 0)
> -		return ret;
> -
>  	dinfo = open_debuginfo(module);
>  	if (!dinfo) {
>  		pr_warning("Failed to open debuginfo file.\n");
> @@ -646,6 +637,19 @@ end:
>  	return ret;
>  }
>  
> +int show_line_range(struct line_range *lr, const char *module)
> +{
> +	int ret;
> +
> +	ret = init_symbol_maps(false);
> +	if (ret < 0)
> +		return ret;
> +	ret = __show_line_range(lr, module);
> +	exit_symbol_maps();

Wouldn't it be better moving init/exit_symbol_maps() to a common
location if they're used by every operations?

Thanks,
Namhyung

> +
> +	return ret;
> +}
> +
>  static int show_available_vars_at(struct debuginfo *dinfo,
>  				  struct perf_probe_event *pev,
>  				  int max_vls, struct strfilter *_filter,
> @@ -707,14 +711,15 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
>  	int i, ret = 0;
>  	struct debuginfo *dinfo;
>  
> -	ret = init_vmlinux();
> +	ret = init_symbol_maps(false);
>  	if (ret < 0)
>  		return ret;
>  
>  	dinfo = open_debuginfo(module);
>  	if (!dinfo) {
>  		pr_warning("Failed to open debuginfo file.\n");
> -		return -ENOENT;
> +		ret = -ENOENT;
> +		goto out;
>  	}
>  
>  	setup_pager();
> @@ -724,6 +729,8 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
>  					     externs);
>  
>  	debuginfo__delete(dinfo);
> +out:
> +	exit_symbol_maps();
>  	return ret;
>  }
>  
> @@ -1807,7 +1814,7 @@ int show_perf_probe_events(void)
>  	if (fd < 0)
>  		return fd;
>  
> -	ret = init_vmlinux();
> +	ret = init_symbol_maps(false);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -1820,6 +1827,7 @@ int show_perf_probe_events(void)
>  		close(fd);
>  	}
>  
> +	exit_symbol_maps();
>  	return ret;
>  }
>  
> @@ -2135,12 +2143,7 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
>  	if (pkgs == NULL)
>  		return -ENOMEM;
>  
> -	if (!pevs->uprobes)
> -		/* Init vmlinux path */
> -		ret = init_vmlinux();
> -	else
> -		ret = init_user_exec();
> -
> +	ret = init_symbol_maps(pevs->uprobes);
>  	if (ret < 0) {
>  		free(pkgs);
>  		return ret;
> @@ -2174,6 +2177,7 @@ end:
>  		zfree(&pkgs[i].tevs);
>  	}
>  	free(pkgs);
> +	exit_symbol_maps();
>  
>  	return ret;
>  }
> @@ -2347,7 +2351,7 @@ static int available_kernel_funcs(const char *module)
>  	struct map *map;
>  	int ret;
>  
> -	ret = init_vmlinux();
> +	ret = init_symbol_maps(false);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -2356,7 +2360,10 @@ static int available_kernel_funcs(const char *module)
>  		pr_err("Failed to find %s map.\n", (module) ? : "kernel");
>  		return -EINVAL;
>  	}
> -	return __show_available_funcs(map);
> +	ret = __show_available_funcs(map);
> +	exit_symbol_maps();
> +
> +	return ret;
>  }
>  
>  static int available_user_funcs(const char *target)
> @@ -2364,7 +2371,7 @@ static int available_user_funcs(const char *target)
>  	struct map *map;
>  	int ret;
>  
> -	ret = init_user_exec();
> +	ret = init_symbol_maps(true);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -2372,6 +2379,7 @@ static int available_user_funcs(const char *target)
>  	ret = __show_available_funcs(map);
>  	dso__delete(map->dso);
>  	map__delete(map);
> +	exit_symbol_maps();
>  	return ret;
>  }
>  
