Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaDHHSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:18:42 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59116 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaDHHSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:18:41 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        peterz@infradead.org, eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 05/15 V3] perf, c2c: Rework setup code to prepare for features
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
	<1395689826-215033-6-git-send-email-dzickus@redhat.com>
Date: Tue, 08 Apr 2014 16:18:39 +0900
In-Reply-To: <1395689826-215033-6-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 15:36:56 -0400")
Message-ID: <871tx8xp9s.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 15:36:56 -0400, Don Zickus wrote:
> A basic patch that re-arranges some of the c2c code and adds a couple
> of small features to lay the ground work for the rest of the patch
> series.
>
> Changes include:
>
> o reworking the report path
> o replace preprocess_sample with simpler calls
> o rework raw output to handle separators
> o remove phys id gunk
> o add some generic options

[SNIP]
>
> +	return fprintf(fp, fmt,
> +		       tag,				sep,
> +		       reason ?: "valid record",	sep,
> +		       sample->pid,			sep,
> +		       sample->tid,			sep,
> +		       sample->cpu,			sep,
> +		       sample->ip,			sep,
> +		       sample->addr,			sep,
> +		       sample->weight,			sep,
> +		       sample->data_src,		sep,
> +		       data_src,			sep,
> +		       map ? (map->dso ? map->dso->long_name : "???") : "???",

How about using this instead?

		(map && map->dso) ? map->dso->long_name : "???".


> +		       mi->iaddr.sym ? mi->iaddr.sym->name : "???");
>  }
>  
>  static int perf_c2c__process_load_store(struct perf_c2c *c2c,
> +					struct addr_location *al,
>  					struct perf_sample *sample,
> -					struct addr_location *al)
> +					struct perf_evsel *evsel)
>  {
> -	if (c2c->raw_records)
> -		perf_sample__fprintf(sample, ' ', "raw input", al, stdout);
> +	struct mem_info *mi;
> +
> +	mi = sample__resolve_mem(sample, al);
> +	if (!mi)
> +		return -ENOMEM;
> +
> +	if (c2c->raw_records) {
> +		perf_sample__fprintf(sample, ' ', "raw input", mi, stdout);
> +		free(mi);
> +		return 0;
> +	}

It seems the 'mi' should be freed here as well?

>  
>  	return 0;
>  }


[SNIP]
> +static int perf_c2c__process_events(struct perf_session *session,
> +				    struct perf_c2c *c2c)
> +{
> +	int err = -1;

No need to set.

> +
> +	err = perf_session__process_events(session, &c2c->tool);
> +	if (err) {
> +		pr_err("Failed to process count events, error %d\n", err);
> +		goto err;

Unnecessary goto.

Thanks,
Namhyung


>  	}
>  
> +err:
>  	return err;
>  }
