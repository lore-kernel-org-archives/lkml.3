Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbbALQlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:41:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbbALQln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:41:43 -0500
Date: Mon, 12 Jan 2015 17:40:50 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Kan Liang <kan.liang@intel.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH 5/7] perf tools: Pass struct perf_hpp_fmt to its callbacks
Message-ID: <20150112164050.GB18267@krava.brq.redhat.com>
References: <1420677949-6719-1-git-send-email-namhyung@kernel.org>
 <1420677949-6719-6-git-send-email-namhyung@kernel.org>
 <20150112162140.GK12406@kernel.org>
 <20150112162736.GL12406@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150112162736.GL12406@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 01:27:36PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jan 12, 2015 at 01:21:40PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Thu, Jan 08, 2015 at 09:45:46AM +0900, Namhyung Kim escreveu:
> > > Currently ->cmp, ->collapse and ->sort callbacks doesn't pass
> > > corresponding fmt.  But it'll be needed by upcoming changes in
> > > perf diff command.
> > > 
> > > Suggested-by: Jiri Olsa <jolsa@kernel.org>
> > 
> > 
> >   CC       /tmp/build/perf/builtin-evlist.o
> > builtin-diff.c: In function ‘data__hpp_register’:
> > builtin-diff.c:1036:11: error: assignment from incompatible pointer type [-Werror]
> >   fmt->cmp    = hist_entry__cmp_nop;
> >            ^
> > builtin-diff.c:1037:16: error: assignment from incompatible pointer type [-Werror]
> >   fmt->collapse = hist_entry__cmp_nop;
> >                 ^
> > builtin-diff.c:1043:13: error: assignment from incompatible pointer type [-Werror]
> >    fmt->sort  = hist_entry__cmp_baseline;
> >              ^
> > builtin-diff.c:1047:13: error: assignment from incompatible pointer type [-Werror]
> >    fmt->sort  = hist_entry__cmp_delta;
> >              ^
> > builtin-diff.c:1051:13: error: assignment from incompatible pointer type [-Werror]
> >    fmt->sort  = hist_entry__cmp_ratio;
> >              ^
> > builtin-diff.c:1055:13: error: assignment from incompatible pointer type [-Werror]
> >    fmt->sort  = hist_entry__cmp_wdiff;
> >              ^
> > builtin-diff.c:1058:13: error: assignment from incompatible pointer type [-Werror]
> >    fmt->sort  = hist_entry__cmp_nop;
> >              ^
> > cc1: all warnings being treated as errors
> >   LINK     plugin_kvm.so
> > make[1]: *** [/tmp/build/perf/builtin-diff.o] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> >   LINK     plugin_mac80211.so
> 
> Am I missing something? Lemme continue trying applying the rest of the
> kit...

hum,
looks like those (= hist_entry__cmp_delta,.. functions) are fixed (=added fmt param)
later in patch 6/7 of this series.. which is wrong, should be updated in this patch,
as you did below

jirka


> 
> - Arnaldo
>  
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index ae8f62151b34..4816989a84b0 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -554,14 +554,16 @@ hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
>  }
>  
>  static int64_t
> -hist_entry__cmp_nop(struct hist_entry *left __maybe_unused,
> +hist_entry__cmp_nop(struct perf_hpp_fmt *fmt __maybe_unused,
> +		    struct hist_entry *left __maybe_unused,
>  		    struct hist_entry *right __maybe_unused)
>  {
>  	return 0;
>  }
>  
>  static int64_t
> -hist_entry__cmp_baseline(struct hist_entry *left, struct hist_entry *right)
> +hist_entry__cmp_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
> +			 struct hist_entry *left, struct hist_entry *right)
>  {
>  	if (sort_compute)
>  		return 0;
> @@ -572,19 +574,22 @@ hist_entry__cmp_baseline(struct hist_entry *left, struct hist_entry *right)
>  }
>  
>  static int64_t
> -hist_entry__cmp_delta(struct hist_entry *left, struct hist_entry *right)
> +hist_entry__cmp_delta(struct perf_hpp_fmt *fmt __maybe_unused,
> +		      struct hist_entry *left, struct hist_entry *right)
>  {
>  	return hist_entry__cmp_compute(right, left, COMPUTE_DELTA);
>  }
>  
>  static int64_t
> -hist_entry__cmp_ratio(struct hist_entry *left, struct hist_entry *right)
> +hist_entry__cmp_ratio(struct perf_hpp_fmt *fmt __maybe_unused,
> +		      struct hist_entry *left, struct hist_entry *right)
>  {
>  	return hist_entry__cmp_compute(right, left, COMPUTE_RATIO);
>  }
>  
>  static int64_t
> -hist_entry__cmp_wdiff(struct hist_entry *left, struct hist_entry *right)
> +hist_entry__cmp_wdiff(struct perf_hpp_fmt *fmt __maybe_unused,
> +		      struct hist_entry *left, struct hist_entry *right)
>  {
>  	return hist_entry__cmp_compute(right, left, COMPUTE_WEIGHTED_DIFF);
>  }
