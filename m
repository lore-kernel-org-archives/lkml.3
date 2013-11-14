Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab3KNIjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:39:35 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:46181 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3KNIjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:39:33 -0500
Date: Thu, 14 Nov 2013 09:39:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        thomas.ilsche@tu-dresden.de, linux-kernel@vger.kernel.org,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] Perf: Correct Assumptions about Sample Timestamps in
 Passes
Message-ID: <20131114083930.GC16543@gmail.com>
References: <528484CB.7@tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528484CB.7@tu-dresden.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joseph Schuchart <joseph.schuchart@tu-dresden.de> wrote:

> @@ -549,15 +552,24 @@ static int flush_sample_queue(struct perf_session *s,
>  	return 0;
>  }
>  
> +static inline void set_next_flush(struct perf_session *session)
> +{
> +	int i;
> +	u64 min_max_timestamp = session->ordered_samples.max_timestamps[0];
> +	for (i = 1; i < MAX_NR_CPUS; i++) {
> +		if (min_max_timestamp > session->ordered_samples.max_timestamps[i])
> +			min_max_timestamp = session->ordered_samples.max_timestamps[i];
> +	}
> +	session->ordered_samples.next_flush = min_max_timestamp;
> +}

>  static int process_finished_round(struct perf_tool *tool,
>  				  union perf_event *event __maybe_unused,
>  				  struct perf_session *session)
>  {
> -	int ret = flush_sample_queue(session, tool);
> -	if (!ret)
> -		session->ordered_samples.next_flush = session->ordered_samples.max_timestamp;
> -
> +	int ret;
> +	set_next_flush(session);
> +	ret = flush_sample_queue(session, tool);

Just a quick side note, while I realize that you are 
(rightfully!) concerned about correctness primarily, if that loop 
over MAX_NR_CPUS executes often enough then this might hurt 
performance:

   perf.h:#define MAX_NR_CPUS                      256

So it might be better to maintain a rolling min_max_timestamp in 
this place:

+       os->max_timestamps[sample->cpu] = timestamp;

?

If done that way then AFAICS we could even eliminate the 
->max_timestamps[NR_CPUS] array.

Thanks,

	Ingo
