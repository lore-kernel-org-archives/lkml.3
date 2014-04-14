Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbaDNRWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:22:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42344 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaDNRWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:22:01 -0400
Message-ID: <534C193A.2000806@gmail.com>
Date: Mon, 14 Apr 2014 11:22:02 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/5] perf tools: Reference count map_groups objects
References: <1397490723-1992-1-git-send-email-jolsa@redhat.com> <1397490723-1992-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397490723-1992-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/14/14, 9:52 AM, Jiri Olsa wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> We will share it among threads in the same process.
>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>   tools/perf/util/map.c    | 7 +++++++
>   tools/perf/util/map.h    | 9 +++++++++
>   tools/perf/util/thread.c | 2 +-
>   3 files changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index ae4c5e1..ba5f5c0c 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -323,6 +323,7 @@ void map_groups__init(struct map_groups *mg)
>   		INIT_LIST_HEAD(&mg->removed_maps[i]);
>   	}
>   	mg->machine = NULL;
> +	mg->refcnt = 1;
>   }
>
>   static void maps__delete(struct rb_root *maps)
> @@ -374,6 +375,12 @@ void map_groups__delete(struct map_groups *mg)
>   	free(mg);
>   }
>
> +void map_groups__put(struct map_groups *mg)
> +{
> +	if (--mg->refcnt == 0)
> +		map_groups__delete(mg);
> +}
> +
>   void map_groups__flush(struct map_groups *mg)
>   {
>   	int type;
> diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
> index 1073e2d..d6445b2 100644
> --- a/tools/perf/util/map.h
> +++ b/tools/perf/util/map.h
> @@ -59,11 +59,20 @@ struct map_groups {
>   	struct rb_root	 maps[MAP__NR_TYPES];
>   	struct list_head removed_maps[MAP__NR_TYPES];
>   	struct machine	 *machine;
> +	int		 refcnt;
>   };


atomic for refcnt? This is part of a libperf; would be good to support 
multithreaded users.

David
