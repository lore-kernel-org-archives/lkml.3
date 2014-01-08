Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbaAHV3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:29:19 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:56946 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320AbaAHV3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:29:16 -0500
Date: Wed, 8 Jan 2014 16:30:17 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [patch] perf tools: perf list broken on ARM
In-Reply-To: <alpine.DEB.2.10.1312301536150.28814@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1401081629200.4410@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1312301536150.28814@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


just checking on the status of this patch.  Am I sending it to the wrong 
place?  Did it get lost in the post-holiday e-mail purges?  

The bug is annoying if you're trying to use perf on ARM systems.

Vince

On Mon, 30 Dec 2013, Vince Weaver wrote:

> 
> "perf list" listing of hardware events doesn't work on older ARM devices.
> The change enabling event detection:
> 
>  commit b41f1cec91c37eeea6fdb15effbfa24ea0a5536b
>  Author: Namhyung Kim <namhyung.kim@lge.com>
>  Date:   Tue Aug 27 11:41:53 2013 +0900
> 
>      perf list: Skip unsupported events
> 
> 
> uses the following code in tools/perf/util/parse-events.c:
> 
>         struct perf_event_attr attr = {
>                 .type = type,
>                 .config = config,
>                 .disabled = 1,
>                 .exclude_kernel = 1,
>         };
> 
> On ARM machines pre-dating the Cortex-A15 this doesn't work, as
> these machines don't support .exclude_kernel.  So starting with 3.12
> "perf list" does not report any hardware events at all on older
> machines (seen on Rasp-Pi, Pandaboard, Beagleboard, etc).
> 
> This version of the patch makes changes suggested by Namhyung Kim
> to check for EACCESS and retry (instead of just dropping
> the exclude_kernel) so we can properly handle machines where 
> /proc/sys/kernel/perf_event_paranoid is set to 2.
> 
> Reported-by: Chad Paradis <chad.paradis@umit.maine.edu>
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
> Acked-by: Namhyung Kim <namhyung@kernel.org>
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 6de6f89..1fa98b9 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -1082,12 +1082,12 @@ int is_valid_tracepoint(const char *event_string)
>  static bool is_event_supported(u8 type, unsigned config)
>  {
>  	bool ret = true;
> +	int open_return;
>  	struct perf_evsel *evsel;
>  	struct perf_event_attr attr = {
>  		.type = type,
>  		.config = config,
>  		.disabled = 1,
> -		.exclude_kernel = 1,
>  	};
>  	struct {
>  		struct thread_map map;
> @@ -1099,7 +1099,20 @@ static bool is_event_supported(u8 type, unsigned config)
>  
>  	evsel = perf_evsel__new(&attr);
>  	if (evsel) {
> -		ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
> +		open_return = perf_evsel__open(evsel, NULL, &tmap.map);
> +		ret = open_return >= 0;
> +
> +		if (open_return == -EACCES) {
> +			/*
> +			 * This happens if the paranoid value
> +			 * /proc/sys/kernel/perf_event_paranoid is set to 2
> +			 * Re-run with exclude_kernel set; we don't do that
> +			 * by default as some ARM machines do not support it.
> +			 *
> +			 */
> +			evsel->attr.exclude_kernel = 1;
> +			ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
> +		}
>  		perf_evsel__delete(evsel);
>  	}
>  
> 

Vince Weaver
vincent.weaver@maine.edu
http://www.eece.maine.edu/~vweaver/
