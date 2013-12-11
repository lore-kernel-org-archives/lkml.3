Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab3LKCJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:09:52 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:49443 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3LKCJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:09:51 -0500
X-AuditID: 9c93017d-b7b46ae000000e86-e8-52a7c96e138b
From: Namhyung Kim <namhyung@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Chad Paradis <chad.paradis@umit.maine.edu>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [patch v2] perf tools: perf list broken on ARM
References: <alpine.DEB.2.10.1312101439590.7745@vincent-weaver-1.um.maine.edu>
Date: Wed, 11 Dec 2013 11:09:49 +0900
In-Reply-To: <alpine.DEB.2.10.1312101439590.7745@vincent-weaver-1.um.maine.edu>
	(Vince Weaver's message of "Tue, 10 Dec 2013 14:44:52 -0500 (EST)")
Message-ID: <87a9g8i1ea.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vince,

On Tue, 10 Dec 2013 14:44:52 -0500 (EST), Vince Weaver wrote:
> Hello,
>
> "perf list" listing of hardware events doesn't work on older ARM devices.
> The change enabling event detection:
>
> commit b41f1cec91c37eeea6fdb15effbfa24ea0a5536b
> Author: Namhyung Kim <namhyung.kim@lge.com>
> Date:   Tue Aug 27 11:41:53 2013 +0900
>
>     perf list: Skip unsupported events
>
>
> uses the following code in tools/perf/util/parse-events.c:
>
>        struct perf_event_attr attr = {
>                .type = type,
>                .config = config,
>                .disabled = 1,
>                .exclude_kernel = 1,
>        };
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
>
> Reported-by: Chad Paradis <chad.paradis@umit.maine.edu>
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
>
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 6de6f89..07b6e2d 100644
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
> @@ -1099,8 +1099,24 @@ static bool is_event_supported(u8 type, unsigned config)
>  
>  	evsel = perf_evsel__new(&attr);
>  	if (evsel) {
> -		ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
> +		open_return = perf_evsel__open(evsel, NULL, &tmap.map);
> +		ret = open_return >= 0;
>  		perf_evsel__delete(evsel);
> +
> +		if (open_return == -EACCES) {
> +			/*
> +			 * This happens if the paranoid value
> +			 * /proc/sys/kernel/perf_event_paranoid is set to 2
> +			 * Re-run with exclude_kernel set; we don't do that
> +			 * by default as some ARM machines do not support it.
> +			 *
> +			 */
> +			attr.exclude_kernel = 1;
> +			evsel = perf_evsel__new(&attr);

It seems you need to check the return value.  But I'd rather suggest
re-using existing evsel then. :)

Other than that, it looks good to me.

Thanks,
Namhyung

> +
> +			ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
> +			perf_evsel__delete(evsel);
> +		}
>  	}
>  
>  	return ret;
