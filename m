Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab3GDHpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 03:45:45 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52333 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab3GDHpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:45:44 -0400
X-AuditID: 9c930179-b7b7fae000002142-0d-51d528261ae0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2 1/4] perf util: Add parse_nsec_time() function
References: <1370234653-31582-1-git-send-email-namhyung@kernel.org>
Date: Thu, 04 Jul 2013 16:45:42 +0900
In-Reply-To: <1370234653-31582-1-git-send-email-namhyung@kernel.org> (Namhyung
	Kim's message of "Mon, 3 Jun 2013 13:44:10 +0900")
Message-ID: <87li5mzs2h.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

Could you pick these up or give a comment?

Thanks,
Namhyung


On Mon,  3 Jun 2013 13:44:10 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> The parse_nsec_time() function is for parsing a string of time into
> 64-bit nsec value.  It's a preparation of time filtering in some of
> perf commands.
>
> Cc: David Ahern <dsahern@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/util.c | 30 ++++++++++++++++++++++++++++++
>  tools/perf/util/util.h |  2 ++
>  2 files changed, 32 insertions(+)
>
> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
> index 59d868add275..4a207c40d7bc 100644
> --- a/tools/perf/util/util.c
> +++ b/tools/perf/util/util.c
> @@ -269,3 +269,33 @@ void perf_debugfs_set_path(const char *mntpt)
>  	snprintf(debugfs_mountpoint, strlen(debugfs_mountpoint), "%s", mntpt);
>  	set_tracing_events_path(mntpt);
>  }
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
> +		strncpy(nsec_buf, end + 1, 9);
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
>  #define NSEC_PER_MSEC	1000000L
>  #endif
>  
> +int parse_nsec_time(const char *str, u64 *ptime);
> +
>  extern unsigned char sane_ctype[256];
>  #define GIT_SPACE		0x01
>  #define GIT_DIGIT		0x02
