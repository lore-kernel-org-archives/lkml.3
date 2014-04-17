Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161415AbaDQNbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:31:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651AbaDQNbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:31:16 -0400
Date: Thu, 17 Apr 2014 15:10:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/3] perf hists: Add missing updates on
 nr_non_filtered_entries
Message-ID: <20140417131014.GD7422@krava.brq.redhat.com>
References: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
 <1397721206-15393-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397721206-15393-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 04:53:24PM +0900, Namhyung Kim wrote:
> When a filter is used for perf top, its hists->nr_non_filtered_entries
> was not updated after applying the filter.  But it needs to be updated
> as new samples are captured.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/hist.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 5a892477aa50..2edbcd717f0e 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -259,8 +259,11 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
>  			if (sort__need_collapse)
>  				rb_erase(&n->rb_node_in, &hists->entries_collapsed);
>  
> -			hist_entry__free(n);
>  			--hists->nr_entries;
> +			if (!n->filtered)
> +				--hists->nr_non_filtered_entries;
> +
> +			hist_entry__free(n);
>  		}
>  	}
>  }
> @@ -394,6 +397,9 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
>  		return NULL;
>  
>  	hists->nr_entries++;
> +	if (!he->filtered)
> +		hists->nr_non_filtered_entries++;
> +

I'm probably missing something, but what is hists->nr_non_filtered_entries
used for? I can only see it being inc/dec-ed, but not used..

jirka

>  	rb_link_node(&he->rb_node_in, parent, p);
>  	rb_insert_color(&he->rb_node_in, hists->entries_in);
>  out:
> -- 
> 1.9.2
> 
