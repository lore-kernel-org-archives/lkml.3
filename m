Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbbAGHpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:45:05 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:33672 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbbAGHpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:45:04 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Wed, 7 Jan 2015 16:42:58 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/5] perf diff: Fix output ordering to honor next column
Message-ID: <20150107074258.GE849@sejong>
References: <1419656793-32756-1-git-send-email-namhyung@kernel.org>
 <1419656793-32756-4-git-send-email-namhyung@kernel.org>
 <20150104181640.GB29388@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150104181640.GB29388@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sun, Jan 04, 2015 at 07:16:40PM +0100, Jiri Olsa wrote:
> On Sat, Dec 27, 2014 at 02:06:32PM +0900, Namhyung Kim wrote:
> 
> SNIP
> 
> >  	if (!pairs_left || !pairs_right)
> >  		return pairs_left ? -1 : 1;
> >  
> > -	p_left  = get_pair_data(left,  &data__files[sort_compute]);
> > -	p_right = get_pair_data(right, &data__files[sort_compute]);
> > +	p_left  = get_pair_data(left,  &data__files[sort_idx]);
> > +	p_right = get_pair_data(right, &data__files[sort_idx]);
> >  
> >  	if (!p_left && !p_right)
> >  		return 0;
> > @@ -555,8 +560,13 @@ hist_entry__cmp_nop(struct hist_entry *left __maybe_unused,
> >  static int64_t
> >  hist_entry__cmp_baseline(struct hist_entry *left, struct hist_entry *right)
> >  {
> > -	if (sort_compute)
> > -		return 0;
> > +	/*
> > +	 * This function will be called first for each entry to resort
> > +	 * output.  Next compare-functions use this idx to find their
> > +	 * data and increase it for next data so we need to initialize
> > +	 * it everytime.
> > +	 */
> > +	data_idx = 0;
> 
> hum, could we omit the global 'data_idx' variable usage by passing
> 'struct perf_hpp_fmt' into color fmt callbacks? (like hist_entry__cmp_delta..)
> 
> we could get the data_idx from 'struct diff_hpp_fmt'::idx

Right, I thought that too.  But it requires adding '__maybe_unused
fmt' argument to all callbacks so I just decided to use a quick
solution.  I'll convert to pass the fmt argument as it'll make
possible future changes easier.

Thanks,
Namhyung
