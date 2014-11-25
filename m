Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaKYMWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:22:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbaKYMWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:22:06 -0500
Date: Tue, 25 Nov 2014 13:21:59 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Kan Liang <kan.liang@intel.com>
Cc: acme@kernel.org, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH V5 3/3] perf tool: check buildid for symoff
Message-ID: <20141125122159.GF30861@krava.brq.redhat.com>
References: <1416844829-26945-1-git-send-email-kan.liang@intel.com>
 <1416844829-26945-3-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416844829-26945-3-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 11:00:29AM -0500, Kan Liang wrote:
> From: Kan Liang <kan.liang@intel.com>
> 
> symoff can support both same binaries and different binaries. However,
> the offset may be changed for different binaries. This patch checks the
> buildid of perf.data. If they are from different binaries, print a
> warning to notify the user.
> 
> Signed-off-by: Kan Liang <kan.liang@intel.com>
> ---
>  tools/perf/builtin-diff.c | 25 +++++++++++++++++++++++++
>  tools/perf/util/sort.c    |  3 +++
>  tools/perf/util/sort.h    |  1 +
>  3 files changed, 29 insertions(+)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 03a4001..2a8c17a 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -678,6 +678,28 @@ static void data__free(struct data__file *d)
>  	}
>  }
>  
> +static void buildid_check(void)
> +{
> +	struct dsos *base_k_dsos = &data__files[0].session->machines.host.kernel_dsos;
> +	struct dsos *base_u_dsos = &data__files[0].session->machines.host.user_dsos;
> +	struct dsos *k_dsos_tmp, *u_dsos_tmp;
> +	struct data__file *d;
> +	int i;
> +
> +	data__for_each_file_new(i, d) {
> +		k_dsos_tmp = &d->session->machines.host.kernel_dsos;
> +		u_dsos_tmp = &d->session->machines.host.user_dsos;
> +
> +		if (!dsos__build_ids_equal(base_k_dsos, k_dsos_tmp))
> +			pr_warning("The perf.data come from different kernel. "
> +				   "The kernel symbol offset may vary for different kernel.\n");
> +
> +		if (!dsos__build_ids_equal(base_u_dsos, u_dsos_tmp))

looks like at this time not all dsos on the list have
the buildids read..

I tried to put in here the perf_session__read_build_ids call
but it keeps showing me warning below:

> +			pr_warning("The perf.data come from different user binary. "
> +				   "The user space symbol offset may vary for different binaries.\n");

for following workload:

[jolsa@krava perf]$ ./perf record ls
...
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.012 MB perf.data (~540 samples) ]
[jolsa@krava perf]$ ./perf record ls
...
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.012 MB perf.data (~540 samples) ]
[jolsa@krava perf]$ ./perf diff -s symoff
The perf.data come from different user binary. The user space symbol offset may vary for different binaries.
# Event 'cycles'
...


jirka
