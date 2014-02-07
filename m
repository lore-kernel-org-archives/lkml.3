Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbaBGN0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:26:40 -0500
Received: from alerce.vps.bitfolk.com ([85.119.82.134]:47292 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaBGN0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:26:34 -0500
Date: Fri, 7 Feb 2014 13:26:01 +0000
From: Rodrigo Campos <rodrigo@sdfg.com.ar>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 18/21] perf top: Convert to hist_entry_iter
Message-ID: <20140207132601.GA25259@sdfg.com.ar>
References: <1391736923-30765-1-git-send-email-namhyung@kernel.org>
 <1391736923-30765-19-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391736923-30765-19-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 10:35:20AM +0900, Namhyung Kim wrote:
> Reuse hist_entry_iter__add() function to share the similar code with
> perf report.  Note that it needs to be called with hists.lock so tweak
> some internal functions not to deadlock or hold the lock too long.
> 
> Tested-by: Arun Sharma <asharma@fb.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-top.c | 78 ++++++++++++++++++++++++++----------------------
>  1 file changed, 43 insertions(+), 35 deletions(-)
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 40e430530168..e7d67421eb0f 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -194,6 +194,12 @@ static void perf_top__record_precise_ip(struct perf_top *top,
>  
>  	pthread_mutex_unlock(&notes->lock);
>  
> +	/*
> +	 * This function is now called with he->hists->lock held.
> +	 * Release it before going to sleep.
> +	 */
> +	pthread_mutex_unlock(&he->hists->lock);
> +
>  	if (err == -ERANGE && !he->ms.map->erange_warned)
>  		ui__warn_map_erange(he->ms.map, sym, ip);
>  	else if (err == -ENOMEM) {
> @@ -201,6 +207,8 @@ static void perf_top__record_precise_ip(struct perf_top *top,
>  		       sym->name);
>  		sleep(1);
>  	}
> +
> +	pthread_mutex_lock(&he->hists->lock);
>  }


I've seen Jiri's comment on this on a previous version of the patch, and the
comment now really helps. Thanks :)

But it still feels weird for me unlocking and then re-aquiring the lock at the
end. Maybe is error prone too, as it's easy to add a "return" in between where
we don't have yet aquired the lock and everything breaks, for example. I would
document that this function must always return with that lock acquired. But
maybe this is too personal :)

And just curious, isn't it possible that the caller releases the lock before
calling the function and aquires it after ? This function could then aquire +
release the lock and be done with it. Or do you need that atomicity and know
that nobody else have taken the lock between the caller took it and this
function was called ? Although I'm not sure if this is better... Maybe is the
same at the end, as the caller should (maybe) always unlock before calling.

Also, I realize this is shared code so it might not make any sense or even
complicate things a lot more in some other places where this ends-up being
called. Sorry in advance if this is the case, I really don't know about perf :S



Thanks a lot, and sorry again,
Rodrigo
