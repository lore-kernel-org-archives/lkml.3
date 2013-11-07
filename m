Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab3KGID5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:03:57 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:40031 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3KGIDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:03:51 -0500
Date: Thu, 7 Nov 2013 09:03:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/4] perf record: Refactor feature handling into a
 separate function
Message-ID: <20131107080348.GC31926@gmail.com>
References: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
 <1383763297-27066-2-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383763297-27066-2-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> Code move only. No logic changes.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung.kim@lge.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/builtin-record.c | 33 +++++++++++++++++++++------------
>  1 file changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index ea4c04f7437e..2932069ad7a8 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -342,9 +342,28 @@ out:
>  	return rc;
>  }
>  
> +static void perf_record__init_features(struct perf_record *rec)
> +{
> +	struct perf_evlist *evsel_list = rec->evlist;
> +	struct perf_session *session = rec->session;
> +	int feat;
> +
> +	for (feat = HEADER_FIRST_FEATURE; feat < HEADER_LAST_FEATURE; feat++)
> +		perf_header__set_feat(&session->header, feat);
> +
> +	if (rec->no_buildid)
> +		perf_header__clear_feat(&session->header, HEADER_BUILD_ID);
> +
> +	if (!have_tracepoints(&evsel_list->entries))
> +		perf_header__clear_feat(&session->header, HEADER_TRACING_DATA);
> +
> +	if (!rec->opts.branch_stack)
> +		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
> +}
> +
>  static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>  {
> -	int err, feat;
> +	int err;
>  	unsigned long waking = 0;
>  	const bool forks = argc > 0;
>  	struct machine *machine;
> @@ -371,17 +390,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>  
>  	rec->session = session;
>  
> -	for (feat = HEADER_FIRST_FEATURE; feat < HEADER_LAST_FEATURE; feat++)
> -		perf_header__set_feat(&session->header, feat);
> -
> -	if (rec->no_buildid)
> -		perf_header__clear_feat(&session->header, HEADER_BUILD_ID);
> -
> -	if (!have_tracepoints(&evsel_list->entries))
> -		perf_header__clear_feat(&session->header, HEADER_TRACING_DATA);
> -
> -	if (!rec->opts.branch_stack)
> -		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
> +	perf_record__init_features(rec);
>  
>  	if (forks) {
>  		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
> -- 
> 1.8.3.4 (Apple Git-47)

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
