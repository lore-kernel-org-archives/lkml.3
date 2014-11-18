Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbaKSPAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:00:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:46298 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718AbaKSO7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:59:12 -0500
Date: Tue, 18 Nov 2014 18:20:02 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: kan.liang@intel.com
Cc: jolsa@redhat.com, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH V4 2/3] perf tool:perf diff support for different binaries
Message-ID: <20141118212002.GE3790@kernel.org>
References: <1416328700-1836-1-git-send-email-kan.liang@intel.com>
 <1416328700-1836-3-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416328700-1836-3-git-send-email-kan.liang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 18, 2014 at 11:38:19AM -0500, kan.liang@intel.com escreveu:
> From: Kan Liang <kan.liang@intel.com>
> 
> Currently, the perf diff only works with same binaries. That's because
> it compares the symbol start address. It doesn't work if the perf.data
> comes from different binaries. This patch matches the function names.
> 
> Signed-off-by: Kan Liang <kan.liang@intel.com>
> Acked-by: Namhyung Kim <namhyung@kernel.org>

Can you provide an example of this?

Also, can you add some note on the documentation? The example you use in
the changelog may also be appropriate to have in the man page.

Its been a looong while since I looked at the diff code, but yeah,
comparing by symbol address makes no sense, it had to do a diff from
file name!

The canonical example is:

  vim workload.c
  make workload
  perf record ./workload
  vim workload.c # do some changes
  perf record ./workload
  perf diff

And of course doing that would probably result in symbols moving around
as functions grow in size and new ones are added...

/me scratches head...

- Arnaldo

> ---
>  tools/perf/util/sort.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 95efaaf..bea2e07 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -1432,6 +1432,15 @@ int sort_dimension__add(const char *tok)
>  			sort__has_parent = 1;
>  		} else if (sd->entry == &sort_sym) {
>  			sort__has_sym = 1;
> +			/*
> +			 * perf diff displays the performance difference amongst
> +			 * two or more perf.data files. Those files could come
> +			 * from different binaries. So we should not compare
> +			 * their ips, but the name of symble.

					s/symble/symbol/g

> +			 */
> +			if (sort__mode == SORT_MODE__DIFF)
> +				sd->entry->se_collapse = sort__sym_sort;
> +
>  		} else if (sd->entry == &sort_dso) {
>  			sort__has_dso = 1;
>  		}
> -- 
> 1.8.3.2
