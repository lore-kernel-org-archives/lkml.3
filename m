Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab3LKT0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:26:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:18487 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751339Ab3LKT0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:26:41 -0500
Date: Wed, 11 Dec 2013 14:26:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ian Webster <ian@planetaryresources.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Add record --clock option to specify a trace
 clock
Message-ID: <20131211142639.09527db9@gandalf.local.home>
In-Reply-To: <20131211190832.GA8513@planetaryresources.com>
References: <20131211190832.GA8513@planetaryresources.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013 11:08:32 -0800
Ian Webster <ian@planetaryresources.com> wrote:

> This change adds a --clock option to trace-cmd record. It simply writes
> trace_clock on debugfs. Examples of valid choices on most systems are: local,
> global, counter, and any other choice compatible with ftrace.
> 
> This complements Yoshihiro Yunomae's change 8c9867c (trace-cmd: Add support for
> extracting trace_clock in report).
> 
> Signed-off-by: Ian Webster <ian@planetaryresources.com>
> ---
> Documentation/trace-cmd-record.1.txt |    5 +++++
> trace-record.c                       |   19 +++++++++++++++++++
> trace-usage.c                        |    1 +
> 3 files changed, 25 insertions(+)
> 
> diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
> index 832a257..201be2b 100644
> --- a/Documentation/trace-cmd-record.1.txt
> +++ b/Documentation/trace-cmd-record.1.txt
> @@ -240,6 +240,11 @@ OPTIONS
>      timestamp to gettimeofday which will allow wall time output from the
>      timestamps reading the created 'trace.dat' file.
> 
> +*--clock* 'clock_name'::
> +    When an event is recorded into the ring buffer, a timestamp is added. This
> +    stamp comes from the specified clock. Ftrace uses the "local" clock by
> +    default. Other common clocks include: global, counter, uptime, perf, x86-tsc.
> +
> EXAMPLES
> --------
> 
> diff --git a/trace-record.c b/trace-record.c
> index 0199627..18de026 100644
> --- a/trace-record.c
> +++ b/trace-record.c
> @@ -399,6 +399,20 @@ static int set_ftrace(int set, int use_proc)
>   return 0;
> }
> 
> +static void set_trace_clock(char *clock_choice)

Should be const char *clock_choice.

> +{
> + FILE *fp;
> + char *path;
> +
> + path = tracecmd_get_tracing_file("trace_clock");
> + fp = fopen(path, "w");
> + if (!fp)
> +   die("writing to '%s'", path);
> + tracecmd_put_tracing_file(path);
> + fwrite(clock_choice, 1, strlen(clock_choice), fp);
> + fclose(fp);

Whitespace damage here.

I like the change, but the patch needs to be fixed. The tabs turned to
spaces and the clock_choice above needs to be const.

Thanks,

-- Steve


> +}
> +
> static char *
> get_instance_file(struct buffer_instance *instance, const char *file)
> {
> @@ -2279,6 +2293,7 @@ static void record_all_events(void)
> }
> 
> enum {
> + OPT_clock = 252,
>   OPT_nosplice  = 253,
>   OPT_funcstack = 254,
>   OPT_date  = 255,
> @@ -2351,6 +2366,7 @@ void trace_record (int argc, char **argv)
>       {"func-stack", no_argument, NULL, OPT_funcstack},
>       {"nosplice", no_argument, NULL, OPT_nosplice},
>       {"help", no_argument, NULL, '?'},
> +     {"clock", required_argument, NULL, OPT_clock},
>       {NULL, 0, NULL, 0}
>     };
> 
> @@ -2530,6 +2546,9 @@ void trace_record (int argc, char **argv)
>     case OPT_nosplice:
>       recorder_flags |= TRACECMD_RECORD_NOSPLICE;
>       break;
> +   case OPT_clock:
> +     set_trace_clock(optarg);
> +     break;
>     default:
>       usage(argv);
>     }
> diff --git a/trace-usage.c b/trace-usage.c
> index b8f26e6..54dbb85 100644
> --- a/trace-usage.c
> +++ b/trace-usage.c
> @@ -46,6 +46,7 @@ static struct usage_help usage_help[] = {
>     "          -i do not fail if an event is not found\n"
>     "          --func-stack perform a stack trace for function tracer\n"
>     "             (use with caution)\n"
> +   "          --clock change the method used to produce trace timestamps\n"
>   },
>   {
>     "start",
> --
> 1.7.9.5
> 

