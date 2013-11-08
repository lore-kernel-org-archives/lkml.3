Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3KHJEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:04:33 -0500
Received: from mga14.intel.com ([143.182.124.37]:49340 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab3KHJEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:04:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="318646403"
Message-ID: <527CAAAB.3000900@intel.com>
Date: Fri, 08 Nov 2013 11:11:07 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tool: Round mmap pages to power 2
References: <1383885392-31082-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1383885392-31082-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/13 06:36, David Ahern wrote:
> Currently perf requires the -m / --mmap_pages option to be a power of 2.
> To be more user friendly perf should automatically round this up to the
> next power of 2.
>
> Currently:
>   $ perf record -m 3 -a -- sleep 1
>   --mmap_pages/-m value must be a power of two.sleep: Terminated
>
> With patch:
>   $ perf record -m 3 -a -- sleep 1
>   rounding mmap pages size to 16384 (4 pages)
>   ...

This prevents:

    --out-pages=0

from working e.g.

    tools/perf/perf record -vv --out-pages=0 uname
    rounding mmap pages size to 4096 (1 pages)

Although without this patch:

    tools/perf/perf record -vv --out-pages=0 uname
    --mmap_pages/-m value must be a power of two.
     usage: perf record [<options>] [<command>]
        or: perf record [<options>] -- <command> [<options>]

            --out-pages <pages>
                          Number of pages or size with units to use for
output (default 64M)

Also there is:

    tools/perf/perf record -vv --no-out-pages uname
    Segmentation fault (core dumped)



> Signed-off-by: David Ahern <dsahern@gmail.com>
> Suggested-by: Ingo Molnar <mingo@kernel.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/util/evlist.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index b939221efd8d..9ec3a5a45f22 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -722,11 +722,6 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
>  	if (val != (unsigned long) -1) {
>  		/* we got file size value */
>  		pages = PERF_ALIGN(val, page_size) / page_size;
> -		if (pages < (1UL << 31) && !is_power_of_2(pages)) {
> -			pages = next_pow2(pages);
> -			pr_info("rounding mmap pages size to %lu (%lu pages)\n",
> -				pages * page_size, pages);
> -		}
>  	} else {
>  		/* we got pages count value */
>  		char *eptr;
> @@ -737,6 +732,12 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
>  		}
>  	}
>  
> +	if (pages < (1UL << 31) && !is_power_of_2(pages)) {
> +		pages = next_pow2(pages);
> +		pr_info("rounding mmap pages size to %lu (%lu pages)\n",
> +			pages * page_size, pages);
> +	}
> +
>  	if (pages > UINT_MAX || pages > SIZE_MAX / page_size) {
>  		pr_err("--mmap_pages/-m value too big\n");
>  		return -1;

