Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3LPELG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 23:11:06 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34336 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab3LPELC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 23:11:02 -0500
X-AuditID: 85900ec0-d3b2cb9000001514-c2-52ae7d530c12
Message-ID: <52AE7D4C.2000101@hitachi.com>
Date: Mon, 16 Dec 2013 13:10:52 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Ian Webster <ian@planetaryresources.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] trace-cmd: Add record --clock option to specify
 a trace clock
References: <20131211190832.GA8513@planetaryresources.com> <20131211142639.09527db9@gandalf.local.home> <20131212233024.GA8669@planetaryresources.com>
In-Reply-To: <20131212233024.GA8669@planetaryresources.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

(2013/12/13 8:30), Ian Webster wrote:
> This change adds a --clock option to trace-cmd record. It simply writes
> trace_clock on debugfs. Examples of valid choices on most systems are: local,
> global, counter, and any other choice compatible with ftrace.

Nice work!
Please see my following comments.

> This complements Yoshihiro Yunomae's change 8c9867c (trace-cmd: Add support for
> extracting trace_clock in report).
>
> Signed-off-by: Ian Webster <ian@planetaryresources.com>
>
> ---
> Changes per Steven's comments:
>    * add missing const
>    * preserve tab whitespace
>
>   Documentation/trace-cmd-record.1.txt |    5 +++++
>   trace-record.c                       |   19 +++++++++++++++++++
>   trace-usage.c                        |    1 +
>   3 files changed, 25 insertions(+)
>
> diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
> index 832a257..5e83454 100644
> --- a/Documentation/trace-cmd-record.1.txt
> +++ b/Documentation/trace-cmd-record.1.txt
> @@ -240,6 +240,11 @@ OPTIONS
>       timestamp to gettimeofday which will allow wall time output from the
>       timestamps reading the created 'trace.dat' file.
>
> +*--clock* 'clock_name'::
> +    When an event is recorded into the ring buffer, a timestamp is added. This
> +    stamp comes from the specified clock. Ftrace uses the "local" clock by
> +    default. Other common clocks include: global, counter, uptime, perf, x86-tsc.
> +
>   EXAMPLES
>   --------
>
> diff --git a/trace-record.c b/trace-record.c
> index 0199627..2143080 100644
> --- a/trace-record.c
> +++ b/trace-record.c
> @@ -399,6 +399,20 @@ static int set_ftrace(int set, int use_proc)
>   	return 0;
>   }
>
> +static void set_trace_clock(const char *clock_choice)
> +{
> +	FILE *fp;
> +	char *path;
> +
> +	path = tracecmd_get_tracing_file("trace_clock");
> +	fp = fopen(path, "w");
> +	if (!fp)
> +		die("writing to '%s'", path);
> +	tracecmd_put_tracing_file(path);
> +	fwrite(clock_choice, 1, strlen(clock_choice), fp);

Please add an error check for fwrite(). If clock_choice is invalid,
trace-cmd would better output the error report and die.

> +	fclose(fp);
> +}
> +
>   static char *
>   get_instance_file(struct buffer_instance *instance, const char *file)
>   {
> @@ -2279,6 +2293,7 @@ static void record_all_events(void)
>   }
>
>   enum {
> +	OPT_clock = 252,
>   	OPT_nosplice	= 253,
>   	OPT_funcstack	= 254,
>   	OPT_date	= 255,
> @@ -2351,6 +2366,7 @@ void trace_record (int argc, char **argv)
>   			{"func-stack", no_argument, NULL, OPT_funcstack},
>   			{"nosplice", no_argument, NULL, OPT_nosplice},
>   			{"help", no_argument, NULL, '?'},
> +			{"clock", required_argument, NULL, OPT_clock},
>   			{NULL, 0, NULL, 0}
>   		};
>
> @@ -2530,6 +2546,9 @@ void trace_record (int argc, char **argv)
>   		case OPT_nosplice:
>   			recorder_flags |= TRACECMD_RECORD_NOSPLICE;
>   			break;
> +		case OPT_clock:
> +			set_trace_clock(optarg);
> +			break;

This implementation does not support multiple buffers.
trace_clock had better be changed after sub-buffers are created, I
think.

Example:
trace-cmd record -e sched --clock local -B foo -e block --clock x86-tsc

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


