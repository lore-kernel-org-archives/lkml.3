Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460Ab3GSMLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:11:42 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51443 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760421Ab3GSMLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:11:41 -0400
X-AuditID: 9c930179-b7c49ae000000e68-63-51e92cfb3b64
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 15/23] perf tools: Add perf data version 3 header read
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
	<1374083403-14591-16-git-send-email-jolsa@redhat.com>
Date: Fri, 19 Jul 2013 21:11:39 +0900
In-Reply-To: <1374083403-14591-16-git-send-email-jolsa@redhat.com> (Jiri
	Olsa's message of "Wed, 17 Jul 2013 19:49:55 +0200")
Message-ID: <8738rawxz8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 19:49:55 +0200, Jiri Olsa wrote:
> Adding perf data version 3 header read code to load
> data for v3 format.
>
[SNIP]
> +
> +	session = container_of(header, struct perf_session, header);
> +	if (session->evlist)
> +		return 0;

I guess we need version check here.  The v2 format still needs to
process it even though it's session already has a evlist, right?

Thanks,
Namhyung

>  
>  	evlist = read_event_desc(header, fd);
>  	if (!evlist)
> -		return 0;
> +		return -1;
>  
> -	session = container_of(header, struct perf_session, header);
> +	ph = &session->header;
>  
> -	list_for_each_entry(evsel, &evlist->entries, node)
> -		perf_evlist__set_event_name(session->evlist, evsel);
> +	if (ph->version <= PERF_HEADER_VERSION_2) {
> +		list_for_each_entry(evsel, &evlist->entries, node)
> +			perf_evlist__set_event_name(session->evlist, evsel);
> +
> +		perf_evlist__delete(evlist);
> +	} else {
> +		session->evlist = evlist;
> +		symbol_conf.nr_events = evlist->nr_entries;
> +	}
>  
> -	perf_evlist__delete(evlist);
>  	return 0;
>  }
