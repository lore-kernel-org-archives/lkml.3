Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbbADSQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 13:16:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbbADSQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 13:16:50 -0500
Date: Sun, 4 Jan 2015 19:16:40 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/5] perf diff: Fix output ordering to honor next column
Message-ID: <20150104181640.GB29388@krava.brq.redhat.com>
References: <1419656793-32756-1-git-send-email-namhyung@kernel.org>
 <1419656793-32756-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419656793-32756-4-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 02:06:32PM +0900, Namhyung Kim wrote:

SNIP

>  	if (!pairs_left || !pairs_right)
>  		return pairs_left ? -1 : 1;
>  
> -	p_left  = get_pair_data(left,  &data__files[sort_compute]);
> -	p_right = get_pair_data(right, &data__files[sort_compute]);
> +	p_left  = get_pair_data(left,  &data__files[sort_idx]);
> +	p_right = get_pair_data(right, &data__files[sort_idx]);
>  
>  	if (!p_left && !p_right)
>  		return 0;
> @@ -555,8 +560,13 @@ hist_entry__cmp_nop(struct hist_entry *left __maybe_unused,
>  static int64_t
>  hist_entry__cmp_baseline(struct hist_entry *left, struct hist_entry *right)
>  {
> -	if (sort_compute)
> -		return 0;
> +	/*
> +	 * This function will be called first for each entry to resort
> +	 * output.  Next compare-functions use this idx to find their
> +	 * data and increase it for next data so we need to initialize
> +	 * it everytime.
> +	 */
> +	data_idx = 0;

hum, could we omit the global 'data_idx' variable usage by passing
'struct perf_hpp_fmt' into color fmt callbacks? (like hist_entry__cmp_delta..)

we could get the data_idx from 'struct diff_hpp_fmt'::idx

jirka
