Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaAEQQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 11:16:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbaAEQQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 11:16:47 -0500
Date: Sun, 5 Jan 2014 17:16:32 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 03/21] perf hists: Add support for accumulated stat of
 hist entry
Message-ID: <20140105161632.GB10018@krava.brq.redhat.com>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
 <1387873347-28838-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387873347-28838-4-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 05:22:09PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Maintain accumulated stat information in hist_entry->stat_acc if
> symbol_conf.cumulate_callchain is set.  Fields in ->stat_acc have same
> vaules initially, and will be updated as callchain is processed later.
> 
> Cc: Arun Sharma <asharma@fb.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/hist.c   | 18 ++++++++++++++++++
>  tools/perf/util/sort.h   |  1 +
>  tools/perf/util/symbol.h |  1 +
>  3 files changed, 20 insertions(+)
> 
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 283aa1972b4f..b61e2fa42412 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -237,6 +237,8 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
>  		return true;
>  
>  	he_stat__decay(&he->stat);
> +	if (symbol_conf.cumulate_callchain)
> +		he_stat__decay(he->stat_acc);
>  
>  	if (!he->filtered)
>  		hists->stats.total_period -= prev_period - he->stat.period;
> @@ -284,6 +286,15 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
>  	if (he != NULL) {
>  		*he = *template;
>  
> +		if (symbol_conf.cumulate_callchain) {
> +			he->stat_acc = malloc(sizeof(he->stat));
> +			if (he->stat_acc == NULL) {
> +				free(he);
> +				return NULL;
> +			}
> +			memcpy(he->stat_acc, &he->stat, sizeof(he->stat));
> +		}
> +
>  		if (he->ms.map)
>  			he->ms.map->referenced = true;
>  
> @@ -295,6 +306,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
>  			 */
>  			he->branch_info = malloc(sizeof(*he->branch_info));
>  			if (he->branch_info == NULL) {
> +				free(he->stat_acc);
>  				free(he);
>  				return NULL;

hum, he->stat_acc should get freed in hist_entry__free

jirka
