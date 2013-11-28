Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3K1I4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:56:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:32646 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab3K1I4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:56:41 -0500
X-IronPort-AV: E=Sophos;i="4.93,789,1378828800"; 
   d="scan'208";a="9145388"
Message-ID: <5297BBB0.8030104@cn.fujitsu.com>
Date: Thu, 28 Nov 2013 16:54:56 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, dsahern@gmail.com, adrian.hunter@intel.com,
        jolsa@redhat.com, namhyung@kernel.org, acme@ghostprotocols.net,
        mingo@redhat.com, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] perf target: Move what map fucntion to call check into
 function.
References: <1385667174-16181-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1385667174-16181-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/28 16:56:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/28 16:56:43,
	Serialize complete at 2013/11/28 16:56:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will resend the correct one. Sorry for the bother.

On 11/28/2013 02:32 PM, Dongsheng Yang wrote:
> Check for cpu_map__dummy_new() or cpu_map__new() to be called in
> perf_evlist__create_maps() is more complicated. This patch moves
> the checking work into target.h, combining two conditions and making
> perf_evlist__create_maps() more readable.
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>   tools/perf/util/evlist.c |  8 +-------
>   tools/perf/util/target.h | 13 +++++++++++++
>   2 files changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 76fa764..7bb6ee1 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -819,13 +819,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
>   	if (evlist->threads == NULL)
>   		return -1;
>   
> -	if (target->default_per_cpu)
> -		evlist->cpus = target->per_thread ?
> -					cpu_map__dummy_new() :
> -					cpu_map__new(target->cpu_list);
> -	else if (target__has_task(target))
> -		evlist->cpus = cpu_map__dummy_new();
> -	else if (!target__has_cpu(target) && !target->uses_mmap)
> +	if (target__uses_dummy_map(target))
>   		evlist->cpus = cpu_map__dummy_new();
>   	else
>   		evlist->cpus = cpu_map__new(target->cpu_list);
> diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
> index 31dd2e9..7381b1c 100644
> --- a/tools/perf/util/target.h
> +++ b/tools/perf/util/target.h
> @@ -63,4 +63,17 @@ static inline bool target__none(struct target *target)
>   	return !target__has_task(target) && !target__has_cpu(target);
>   }
>   
> +static inline bool target__uses_dummy_map(struct target *target)
> +{
> +	bool use_dummy = false;
> +
> +	if (target->default_per_cpu)
> +		use_dummy = target->per_thread ? true : false;
> +	else if (target__has_task(target) ||
> +	         (!target__has_cpu(target) && !target->uses_mmap))
> +		use_dummy = true;
> +
> +	return use_dummy;
> +}
> +
>   #endif /* _PERF_TARGET_H */

