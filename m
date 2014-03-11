Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaCKO10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:27:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaCKO1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:27:24 -0400
Date: Tue, 11 Mar 2014 15:26:30 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: Re: [PATCH 7/8] perf, tools, record: Always allow to overide default
 period
Message-ID: <20140311142630.GH22678@krava.redhat.com>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
 <1394048978-15909-8-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394048978-15909-8-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 11:49:37AM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Fix the logic to allow overriding event default periods with -c or -F
> on the command line. I'm not sure what the previous if was supposed
> to do, it didn't work and seemed bogus. I just remove the extra
> check and unconditionally allow overiding when the user set
> an option.
> 
> This fixed specifying -c / -F with json event list events,
> which have a default period. It should do the same
> for trace point events.
> 
> Cc: fweisbec@gmail.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/util/evsel.c | 18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index adc94dd..ca4b976 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -561,19 +561,15 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
>  	}
>  
>  	/*
> -	 * We default some events to a 1 default interval. But keep
> -	 * it a weak assumption overridable by the user.
> +	 * Let the user override any default periods.
>  	 */
> -	if (!attr->sample_period || (opts->user_freq != UINT_MAX &&
> -				     opts->user_interval != ULLONG_MAX)) {
> -		if (opts->freq) {
> -			perf_evsel__set_sample_bit(evsel, PERIOD);
> -			attr->freq		= 1;
> -			attr->sample_freq	= opts->freq;
> -		} else {
> -			attr->sample_period = opts->default_interval;
> -		}
> +	if (opts->user_freq != UINT_MAX) {
> +		perf_evsel__set_sample_bit(evsel, PERIOD);
> +		attr->freq		= 1;
> +		attr->sample_freq	= opts->freq;
>  	}
> +	if (opts->user_interval != ULLONG_MAX)
> +		attr->sample_period = opts->default_interval;

and this also makes the default frequency not be set ;-)

  $ ./perf record ls
  ...
  $ ./perf report -D | grep SAMPLE
  $

and 'perf test attr' fails for this reason:
  $ ./perf test attr
  13: struct perf_event_attr setup                           :FAILED './tests/attr/test-record-branch-filter-k' - match failure
 FAILED!


jirka
