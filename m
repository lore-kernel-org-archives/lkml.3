Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933545AbaE3P2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:28:38 -0400
Received: from mail.kernel.org ([198.145.19.201]:46540 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271AbaE3P2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:28:35 -0400
Date: Fri, 30 May 2014 12:28:30 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: jolsa@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/7 V2] perf: Add support to dynamically get cacheline
 size
Message-ID: <20140530152830.GB1202@kernel.org>
References: <1401208087-181977-7-git-send-email-dzickus@redhat.com>
 <1401461425-209679-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401461425-209679-1-git-send-email-dzickus@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 30, 2014 at 10:50:25AM -0400, Don Zickus escreveu:
> Different arches may have different cacheline sizes.  Look it up and set
> a global variable for reference.

[acme@zoo linux]$ strings `which getconf` | grep LINESIZE
LEVEL1_ICACHE_LINESIZE
LEVEL1_DCACHE_LINESIZE
LEVEL2_CACHE_LINESIZE
LEVEL3_CACHE_LINESIZE
LEVEL4_CACHE_LINESIZE
[acme@zoo linux]$

man sysconf

That is what I use in pahole, for instance:

[acme@zoo pahole]$ grep sysconf *.c
dwarves_fprintf.c:		long sys_cacheline_size =
sysconf(_SC_LEVEL1_DCACHE_LINESIZE);
[acme@zoo pahole]$

- Arnaldo
 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> 
> ---
> V3: remove unneeded cpumap.h (Namhyung Kim)
> V2: change to be global and setup in perf.c
>     use filename__read_int for setup
> ---
>  tools/perf/perf.c        |  5 +++++
>  tools/perf/util/cpumap.c | 27 +++++++++++++++++++++++++++
>  tools/perf/util/cpumap.h |  3 +++
>  tools/perf/util/util.c   |  1 +
>  tools/perf/util/util.h   |  1 +
>  5 files changed, 37 insertions(+)
> 
> diff --git a/tools/perf/perf.c b/tools/perf/perf.c
> index 431798a..dabf08b 100644
> --- a/tools/perf/perf.c
> +++ b/tools/perf/perf.c
> @@ -13,6 +13,7 @@
>  #include "util/quote.h"
>  #include "util/run-command.h"
>  #include "util/parse-events.h"
> +#include "util/cpumap.h"
>  #include <api/fs/debugfs.h>
>  #include <pthread.h>
>  
> @@ -459,6 +460,10 @@ int main(int argc, const char **argv)
>  	/* The page_size is placed in util object. */
>  	page_size = sysconf(_SC_PAGE_SIZE);
>  
> +	/* The cacheline_size is placed in util objet */
> +	if (cpu__setup_cacheline_size() < 0) 
> +		goto out;
> +
>  	cmd = perf_extract_argv0_path(argv[0]);
>  	if (!cmd)
>  		cmd = "perf-help";
> diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
> index c4e55b7..1029982 100644
> --- a/tools/perf/util/cpumap.c
> +++ b/tools/perf/util/cpumap.c
> @@ -477,3 +477,30 @@ int cpu__setup_cpunode_map(void)
>  	closedir(dir1);
>  	return 0;
>  }
> +
> +int cpu__setup_cacheline_size(void)
> +{
> +	const char *mnt;
> +	char path[PATH_MAX];
> +	int n, size;
> +	
> +
> +	mnt = sysfs__mountpoint();
> +	if (!mnt)
> +		return -1;
> +
> +	n = snprintf(path, PATH_MAX, "%s/devices/system/cpu/cpu0/cache/index0/coherency_line_size", mnt);
> +	if (n == PATH_MAX) {
> +		pr_err("sysfs path crossed PATH_MAX(%d) size\n", PATH_MAX);
> +		return -1;
> +	}
> +
> +	if (filename__read_int(path, &size)) {
> +		pr_err("Can not read cacheline size\n");
> +		return -1;
> +	}
> +
> +	cacheline_size = size;
> +
> +	return 0;
> +}
> diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
> index 61a6548..507d7fd 100644
> --- a/tools/perf/util/cpumap.h
> +++ b/tools/perf/util/cpumap.h
> @@ -5,6 +5,7 @@
>  #include <stdbool.h>
>  
>  #include "perf.h"
> +#include "util/util.h"
>  #include "util/debug.h"
>  
>  struct cpu_map {
> @@ -81,4 +82,6 @@ static inline int cpu__get_node(int cpu)
>  	return cpunode_map[cpu];
>  }
>  
> +int cpu__setup_cacheline_size(void);
> +
>  #endif /* __PERF_CPUMAP_H */
> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
> index 7fff6be..95aefa7 100644
> --- a/tools/perf/util/util.c
> +++ b/tools/perf/util/util.c
> @@ -17,6 +17,7 @@
>   * XXX We need to find a better place for these things...
>   */
>  unsigned int page_size;
> +int cacheline_size;
>  
>  bool test_attr__enabled;
>  
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index b03da44..6686436 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -304,6 +304,7 @@ char *rtrim(char *s);
>  void dump_stack(void);
>  
>  extern unsigned int page_size;
> +extern int cacheline_size;
>  
>  void get_term_dimensions(struct winsize *ws);
>  
> -- 
> 1.7.11.7
