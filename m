Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaAKQf5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 11:35:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbaAKQfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 11:35:55 -0500
Date: Sat, 11 Jan 2014 17:35:29 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 25/28] perf top: Convert to hist_entry_iter
Message-ID: <20140111163529.GF1131@krava.brq.redhat.com>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
 <1389170793-21926-26-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389170793-21926-26-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 05:46:30PM +0900, Namhyung Kim wrote:
> Reuse hist_entry_iter__add() function to share the similar code with
> perf report.  Note that it needs to be called with hists.lock so tweak
> some internal functions not to deadlock or hold the lock too long.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-top.c | 75 ++++++++++++++++++++++++------------------------
>  1 file changed, 37 insertions(+), 38 deletions(-)
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index f0f55e6030cd..cf330c66bed7 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -186,9 +186,6 @@ static void perf_top__record_precise_ip(struct perf_top *top,
>  	sym = he->ms.sym;
>  	notes = symbol__annotation(sym);
>  
> -	if (pthread_mutex_trylock(&notes->lock))
> -		return;
> -
>  	ip = he->ms.map->map_ip(he->ms.map, ip);
>  	err = hist_entry__inc_addr_samples(he, counter, ip);
>  
> @@ -201,6 +198,8 @@ static void perf_top__record_precise_ip(struct perf_top *top,
>  		       sym->name);
>  		sleep(1);
>  	}
> +
> +	pthread_mutex_lock(&notes->lock);
>  }

locking on function exit.. does not look right ;-)

jirka
