Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaFTOpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:45:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:38157 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbaFTOod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:44:33 -0400
Date: Fri, 20 Jun 2014 11:44:27 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] perf kvm: move perf_kvm__mmap_read into session utils
Message-ID: <20140620144427.GF31524@kernel.org>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
 <1403261389-13423-7-git-send-email-stfomichev@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403261389-13423-7-git-send-email-stfomichev@yandex-team.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 20, 2014 at 02:49:48PM +0400, Stanislav Fomichev escreveu:
> It will be reused by perf trace in the following commit.

I know this is needed, but one of the goals when I started builtin-trace
was not to use perf_session at all, as it initially was just about the
live mode.

record/replay came later and ended up needing it, but I'll take a look
at what Jiri is doing on the ordered samples front before getting to 6/7
and 7/7.

Up to 5/7 looks ok and I'm going now to apply and try it.

I.e. what we need from perf_session is just the ordered_samples bits,
perhaps in its current form, perhaps rewritten, see (renewed) discussion
involving David Ahern and Jiri Olsa.

- Arnaldo
 
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  tools/perf/builtin-kvm.c  | 88 +++--------------------------------------------
>  tools/perf/util/session.c | 85 +++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/session.h |  5 +++
>  3 files changed, 94 insertions(+), 84 deletions(-)
> 
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index 0f1e5a2f6ad7..a69ffe7512e5 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -885,89 +885,6 @@ static bool verify_vcpu(int vcpu)
>   */
>  #define PERF_KVM__MAX_EVENTS_PER_MMAP  25
>  
> -static s64 perf_kvm__mmap_read_idx(struct perf_kvm_stat *kvm, int idx,
> -				   u64 *mmap_time)
> -{
> -	union perf_event *event;
> -	struct perf_sample sample;
> -	s64 n = 0;
> -	int err;
> -
> -	*mmap_time = ULLONG_MAX;
> -	while ((event = perf_evlist__mmap_read(kvm->evlist, idx)) != NULL) {
> -		err = perf_evlist__parse_sample(kvm->evlist, event, &sample);
> -		if (err) {
> -			perf_evlist__mmap_consume(kvm->evlist, idx);
> -			pr_err("Failed to parse sample\n");
> -			return -1;
> -		}
> -
> -		err = perf_session_queue_event(kvm->session, event, &sample, 0);
> -		/*
> -		 * FIXME: Here we can't consume the event, as perf_session_queue_event will
> -		 *        point to it, and it'll get possibly overwritten by the kernel.
> -		 */
> -		perf_evlist__mmap_consume(kvm->evlist, idx);
> -
> -		if (err) {
> -			pr_err("Failed to enqueue sample: %d\n", err);
> -			return -1;
> -		}
> -
> -		/* save time stamp of our first sample for this mmap */
> -		if (n == 0)
> -			*mmap_time = sample.time;
> -
> -		/* limit events per mmap handled all at once */
> -		n++;
> -		if (n == PERF_KVM__MAX_EVENTS_PER_MMAP)
> -			break;
> -	}
> -
> -	return n;
> -}
> -
> -static int perf_kvm__mmap_read(struct perf_kvm_stat *kvm)
> -{
> -	int i, err, throttled = 0;
> -	s64 n, ntotal = 0;
> -	u64 flush_time = ULLONG_MAX, mmap_time;
> -
> -	for (i = 0; i < kvm->evlist->nr_mmaps; i++) {
> -		n = perf_kvm__mmap_read_idx(kvm, i, &mmap_time);
> -		if (n < 0)
> -			return -1;
> -
> -		/* flush time is going to be the minimum of all the individual
> -		 * mmap times. Essentially, we flush all the samples queued up
> -		 * from the last pass under our minimal start time -- that leaves
> -		 * a very small race for samples to come in with a lower timestamp.
> -		 * The ioctl to return the perf_clock timestamp should close the
> -		 * race entirely.
> -		 */
> -		if (mmap_time < flush_time)
> -			flush_time = mmap_time;
> -
> -		ntotal += n;
> -		if (n == PERF_KVM__MAX_EVENTS_PER_MMAP)
> -			throttled = 1;
> -	}
> -
> -	/* flush queue after each round in which we processed events */
> -	if (ntotal) {
> -		kvm->session->ordered_samples.next_flush = flush_time;
> -		err = kvm->tool.finished_round(&kvm->tool, NULL, kvm->session);
> -		if (err) {
> -			if (kvm->lost_events)
> -				pr_info("\nLost events: %" PRIu64 "\n\n",
> -					kvm->lost_events);
> -			return err;
> -		}
> -	}
> -
> -	return throttled;
> -}
> -
>  static volatile int done;
>  
>  static void sig_handler(int sig __maybe_unused)
> @@ -1133,7 +1050,10 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
>  	while (!done) {
>  		int rc;
>  
> -		rc = perf_kvm__mmap_read(kvm);
> +		rc = perf_session__mmap_read(&kvm->tool,
> +			    kvm->session,
> +			    kvm->evlist,
> +			    PERF_KVM__MAX_EVENTS_PER_MMAP);
>  		if (rc < 0)
>  			break;
>  
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 4526d966b10a..994846060c5e 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1671,3 +1671,88 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
>  out:
>  	return err;
>  }
> +
> +static s64 perf_session__mmap_read_idx(struct perf_session *session,
> +				       int idx,
> +				       u64 *mmap_time,
> +				       int nr_per_mmap)
> +{
> +	union perf_event *event;
> +	struct perf_sample sample;
> +	s64 n = 0;
> +	int err;
> +
> +	*mmap_time = ULLONG_MAX;
> +	while ((event = perf_evlist__mmap_read(session->evlist, idx)) != NULL) {
> +		err = perf_evlist__parse_sample(session->evlist, event, &sample);
> +		if (err) {
> +			perf_evlist__mmap_consume(session->evlist, idx);
> +			pr_err("Failed to parse sample\n");
> +			return -1;
> +		}
> +
> +		err = perf_session_queue_event(session, event, &sample, 0);
> +		/*
> +		 * FIXME: Here we can't consume the event, as perf_session_queue_event will
> +		 *        point to it, and it'll get possibly overwritten by the kernel.
> +		 */
> +		perf_evlist__mmap_consume(session->evlist, idx);
> +
> +		if (err) {
> +			pr_err("Failed to enqueue sample: %d\n", err);
> +			return -1;
> +		}
> +
> +		/* save time stamp of our first sample for this mmap */
> +		if (n == 0)
> +			*mmap_time = sample.time;
> +
> +		/* limit events per mmap handled all at once */
> +		n++;
> +		if (n == nr_per_mmap)
> +			break;
> +	}
> +
> +	return n;
> +}
> +
> +int perf_session__mmap_read(struct perf_tool *tool,
> +			    struct perf_session *session,
> +			    struct perf_evlist *evlist,
> +			    int nr_per_mmap)
> +{
> +	int i, err, throttled = 0;
> +	s64 n, ntotal = 0;
> +	u64 flush_time = ULLONG_MAX, mmap_time;
> +
> +	for (i = 0; i < evlist->nr_mmaps; i++) {
> +		n = perf_session__mmap_read_idx(session, i, &mmap_time,
> +						nr_per_mmap);
> +		if (n < 0)
> +			return -1;
> +
> +		/* flush time is going to be the minimum of all the individual
> +		 * mmap times. Essentially, we flush all the samples queued up
> +		 * from the last pass under our minimal start time -- that leaves
> +		 * a very small race for samples to come in with a lower timestamp.
> +		 * The ioctl to return the perf_clock timestamp should close the
> +		 * race entirely.
> +		 */
> +		if (mmap_time < flush_time)
> +			flush_time = mmap_time;
> +
> +		ntotal += n;
> +		if (n == nr_per_mmap)
> +			throttled = 1;
> +	}
> +
> +	/* flush queue after each round in which we processed events */
> +	if (ntotal) {
> +		session->ordered_samples.next_flush = flush_time;
> +		err = tool->finished_round(tool, NULL, session);
> +		if (err)
> +			return err;
> +	}
> +
> +	return throttled;
> +}
> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
> index 9494fb68828a..e79da3c1071e 100644
> --- a/tools/perf/util/session.h
> +++ b/tools/perf/util/session.h
> @@ -133,4 +133,9 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
>  extern volatile int session_done;
>  
>  #define session_done()	(*(volatile int *)(&session_done))
> +
> +int perf_session__mmap_read(struct perf_tool *tool,
> +			    struct perf_session *session,
> +			    struct perf_evlist *evlist,
> +			    int nr_per_mmap);
>  #endif /* __PERF_SESSION_H */
> -- 
> 1.8.3.2
