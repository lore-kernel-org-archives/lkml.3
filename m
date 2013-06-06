Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab3FFBbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:31:47 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64403 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950Ab3FFBbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:31:45 -0400
Message-ID: <51AFE67C.5030807@gmail.com>
Date: Wed, 05 Jun 2013 19:31:40 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v3 1/4] perf util: Add parse_nsec_time() function
References: <51ACBA6C.9010902@gmail.com> <1370310629-9642-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1370310629-9642-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/13 7:50 PM, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> The parse_nsec_time() function is for parsing a string of time into
> 64-bit nsec value.  It's a preparation of time filtering in some of
> perf commands.
>
> Cc: David Ahern <dsahern@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-Tested-by: David Ahern <dsahern@gmail.com>

> ---
>   tools/perf/util/util.c | 33 +++++++++++++++++++++++++++++++++
>   tools/perf/util/util.h |  2 ++
>   2 files changed, 35 insertions(+)
>
> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
> index 59d868add275..205972f6addb 100644
> --- a/tools/perf/util/util.c
> +++ b/tools/perf/util/util.c
> @@ -269,3 +269,36 @@ void perf_debugfs_set_path(const char *mntpt)
>   	snprintf(debugfs_mountpoint, strlen(debugfs_mountpoint), "%s", mntpt);
>   	set_tracing_events_path(mntpt);
>   }
> +
> +int parse_nsec_time(const char *str, u64 *ptime)
> +{
> +	u64 time_sec, time_nsec;
> +	char *end;
> +
> +	time_sec = strtoul(str, &end, 10);
> +	if (*end != '.' && *end != '\0')
> +		return -1;
> +
> +	if (*end == '.') {
> +		int i;
> +		char nsec_buf[10];
> +
> +		if (strlen(++end) > 9)
> +			return -1;
> +
> +		strncpy(nsec_buf, end, 9);
> +		nsec_buf[9] = '\0';
> +
> +		/* make it nsec precision */
> +		for (i = strlen(nsec_buf); i < 9; i++)
> +			nsec_buf[i] = '0';
> +
> +		time_nsec = strtoul(nsec_buf, &end, 10);
> +		if (*end != '\0')
> +			return -1;
> +	} else
> +		time_nsec = 0;
> +
> +	*ptime = time_sec * NSEC_PER_SEC + time_nsec;
> +	return 0;
> +}
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index 7a484c97e500..6c8baf312c8a 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -204,6 +204,8 @@ static inline int has_extension(const char *filename, const char *ext)
>   #define NSEC_PER_MSEC	1000000L
>   #endif
>
> +int parse_nsec_time(const char *str, u64 *ptime);
> +
>   extern unsigned char sane_ctype[256];
>   #define GIT_SPACE		0x01
>   #define GIT_DIGIT		0x02
>

