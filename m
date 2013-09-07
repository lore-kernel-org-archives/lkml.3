Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab3IGOUQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 10:20:16 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:56811 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3IGOUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 10:20:14 -0400
Message-ID: <522B361A.6030209@gmail.com>
Date: Sat, 07 Sep 2013 08:20:10 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 1/2] perf tools: fix id pos in perf_evlist__open()
References: <1378496412-2424-1-git-send-email-adrian.hunter@intel.com> <1378496412-2424-2-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1378496412-2424-2-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/6/13 1:40 PM, Adrian Hunter wrote:
> Ensure the id_pos is correct when perf_evlist__open()
> is used.

The commit log should reference 7556257 and breakage of 'kvm stat live'; 
helps identify patches when backporting.

Other than that this patch fixes the problem.

Tested-by and Acked-by David Ahern <dsahern@gmail.com>

>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   tools/perf/util/evlist.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index b8727ae..005c0eb 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -64,6 +64,16 @@ void perf_evlist__set_id_pos(struct perf_evlist *evlist)
>   	evlist->is_pos = first->is_pos;
>   }
>
> +static void perf_evlist__update_id_pos(struct perf_evlist *evlist)
> +{
> +	struct perf_evsel *evsel;
> +
> +	list_for_each_entry(evsel, &evlist->entries, node)
> +		perf_evsel__calc_id_pos(evsel);
> +
> +	perf_evlist__set_id_pos(evlist);
> +}
> +
>   static void perf_evlist__purge(struct perf_evlist *evlist)
>   {
>   	struct perf_evsel *pos, *n;
> @@ -915,6 +925,8 @@ int perf_evlist__open(struct perf_evlist *evlist)
>   	struct perf_evsel *evsel;
>   	int err;
>
> +	perf_evlist__update_id_pos(evlist);
> +
>   	list_for_each_entry(evsel, &evlist->entries, node) {
>   		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads);
>   		if (err < 0)
>

