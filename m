Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaAISG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:06:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaAISGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:06:51 -0500
Date: Thu, 9 Jan 2014 19:06:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 10/28] perf report: Cache cumulative callchains
Message-ID: <20140109180627.GC11793@krava.brq.redhat.com>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
 <1389170793-21926-11-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389170793-21926-11-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 05:46:15PM +0900, Namhyung Kim wrote:

SNIP

>  			goto out;
>  	}
>  
> -	if (al->map->groups == &iter->machine->kmaps) {
> -		if (machine__is_host(iter->machine)) {
> +	if (al->map->groups == &al->machine->kmaps) {
> +		if (machine__is_host(al->machine)) {
>  			al->cpumode = PERF_RECORD_MISC_KERNEL;
>  			al->level = 'k';
>  		} else {
> @@ -417,7 +440,7 @@ iter_next_cumulative_entry(struct hist_entry_iter *iter,
>  			al->level = 'g';
>  		}
>  	} else {
> -		if (machine__is_host(iter->machine)) {
> +		if (machine__is_host(al->machine)) {
>  			al->cpumode = PERF_RECORD_MISC_USER;
>  			al->level = '.';
>  		} else if (perf_guest) {
> @@ -440,7 +463,29 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
>  {
>  	struct perf_evsel *evsel = iter->evsel;
>  	struct perf_sample *sample = iter->sample;
> +	struct hist_entry **he_cache = iter->priv;
>  	struct hist_entry *he;
> +	struct hist_entry he_tmp = {
> +		.cpu = al->cpu,
> +		.thread = al->thread,
> +		.comm = thread__comm(al->thread),
> +		.ip = al->addr,
> +		.ms = {
> +			.map = al->map,
> +			.sym = al->sym,
> +		},
> +		.parent = iter->parent,
> +	};
> +	int i;
> +
> +	/*
> +	 * Check if there's duplicate entries in the callchain.
> +	 * It's possible that it has cycles or recursive calls.
> +	 */
> +	for (i = 0; i < iter->curr; i++) {
> +		if (hist_entry__cmp(he_cache[i], &he_tmp) == 0)

we need here:
			iter->he = he_cache[i];

> +			return 0;
> +	}

otherwise iter->he and al are not in sync and 
hist_entry__inc_addr_samples fails in hist_iter_cb

jirka
