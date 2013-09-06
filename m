Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3IFMxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:53:16 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:58747 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3IFMxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:53:15 -0400
Date: Fri, 6 Sep 2013 09:53:04 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf kvm: fix sample_type manipulation
Message-ID: <20130906125304.GA29064@ghostprotocols.net>
References: <1378450134-28982-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378450134-28982-1-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 06, 2013 at 09:48:54AM +0300, Adrian Hunter escreveu:
> Manipulating the sample_type of an evsel requires
> the use of:
> 	perf_evsel__set_sample_bit()
> and	perf_evsel__reset_sample_bit()

Fine, but...
 
> Manipulating the sample type of an evlist requires
> the id position to be recalculated.

... can't we hide this detail? I.e. we could do it like we do with the
alloc_{mmap,poll}() evlist methods in perf_evlist__mmap(), checking if it was
already done, etc.

This we reduce the contact surface for tools using evlists and evsels.

I.e., this sequence:

 
+	perf_evlist__set_id_pos(evlist);
+
 	err = perf_evlist__open(evlist);

Could remain just:

	err = perf_evlist__open(evlist);

I'm auditing the other calls to evlist now, to check if there are other cases.

Thanks for the patch!

- Arnaldo

 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/builtin-kvm.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index 47b3540..0b7c5a9 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -1165,16 +1165,16 @@ static int kvm_live_open_events(struct perf_kvm_stat *kvm)
>  		struct perf_event_attr *attr = &pos->attr;
>  
>  		/* make sure these *are* set */
> -		attr->sample_type |= PERF_SAMPLE_TID;
> -		attr->sample_type |= PERF_SAMPLE_TIME;
> -		attr->sample_type |= PERF_SAMPLE_CPU;
> -		attr->sample_type |= PERF_SAMPLE_RAW;
> +		perf_evsel__set_sample_bit(pos, TID);
> +		perf_evsel__set_sample_bit(pos, TIME);
> +		perf_evsel__set_sample_bit(pos, CPU);
> +		perf_evsel__set_sample_bit(pos, RAW);
>  		/* make sure these are *not*; want as small a sample as possible */
> -		attr->sample_type &= ~PERF_SAMPLE_PERIOD;
> -		attr->sample_type &= ~PERF_SAMPLE_IP;
> -		attr->sample_type &= ~PERF_SAMPLE_CALLCHAIN;
> -		attr->sample_type &= ~PERF_SAMPLE_ADDR;
> -		attr->sample_type &= ~PERF_SAMPLE_READ;
> +		perf_evsel__reset_sample_bit(pos, PERIOD);
> +		perf_evsel__reset_sample_bit(pos, IP);
> +		perf_evsel__reset_sample_bit(pos, CALLCHAIN);
> +		perf_evsel__reset_sample_bit(pos, ADDR);
> +		perf_evsel__reset_sample_bit(pos, READ);
>  		attr->mmap = 0;
>  		attr->comm = 0;
>  		attr->task = 0;
> @@ -1188,6 +1188,8 @@ static int kvm_live_open_events(struct perf_kvm_stat *kvm)
>  		attr->disabled = 1;
>  	}
>  
> +	perf_evlist__set_id_pos(evlist);
> +
>  	err = perf_evlist__open(evlist);
>  	if (err < 0) {
>  		printf("Couldn't create the events: %s\n", strerror(errno));
> -- 
> 1.7.11.7
