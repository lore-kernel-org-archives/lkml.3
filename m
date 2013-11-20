Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3KTNEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:04:36 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:59308 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3KTNEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:04:30 -0500
Date: Wed, 20 Nov 2013 14:04:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf script: Print callchains and symbols if they exist
 - v2
Message-ID: <20131120130426.GB308@localhost.localdomain>
References: <1384920457-5986-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384920457-5986-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 09:07:37PM -0700, David Ahern wrote:
> The intent of perf-script is to dump the events and information
> in the file. H/W, S/W and raw events all dump callchains if they
> are present; might as well make that the default for tracepoints
> too.
> 
> v2: Only add options for sym, dso and ip if callchains are present
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>

Thanks, looks good, just a few things:

> ---
>  tools/perf/builtin-script.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index b392770766dd..9f3ba4404a14 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -280,6 +280,30 @@ static int perf_session__check_output_opt(struct perf_session *session)
>  		set_print_ip_opts(&evsel->attr);
>  	}
>  
> +	/*
> +	 * set default for tracepoints to print symbols only
> +	 * if callchains are present
> +	 */
> +	if (symbol_conf.use_callchain &&
> +	    !output[PERF_TYPE_TRACEPOINT].user_set) {
> +		struct perf_event_attr *attr;
> +
> +		j = PERF_TYPE_TRACEPOINT;
> +		evsel = perf_session__find_first_evtype(session, j);
> +		if (evsel == NULL)
> +			goto out;
> +
> +		attr = &evsel->attr;
> +
> +		if (attr->sample_type & PERF_SAMPLE_CALLCHAIN) {
> +			output[j].fields |= PERF_OUTPUT_IP;
> +			output[j].fields |= PERF_OUTPUT_SYM;
> +			output[j].fields |= PERF_OUTPUT_DSO;
> +			set_print_ip_opts(attr);

We probably want to avoid DSO and IP for most tracepoints. For kernel
tracepoints dso is going to be the kernel anyway and IP is often not that relevant
either.

tracepoint already carries a lot of informations and it's better to avoid any noise.

Thanks.

> +		}
> +	}
> +
> +out:
>  	return 0;
>  }
>  
> -- 
> 1.8.3.4 (Apple Git-47)
> 
