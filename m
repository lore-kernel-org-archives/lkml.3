Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaAGOH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:07:59 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:57800 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaAGOHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:07:55 -0500
Date: Tue, 7 Jan 2014 11:07:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 1/5] tools lib traceevent: Add WARN and WARN_ONCE macros
Message-ID: <20140107140747.GA3845@ghostprotocols.net>
References: <1389063612-18173-1-git-send-email-namhyung@kernel.org>
 <1389063612-18173-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389063612-18173-2-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 07, 2014 at 12:00:08PM +0900, Namhyung Kim escreveu:
> They're copied from the perf code and will be used to print error
> message during trace_seq_printf() and friends.
> 
> Suggested-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

We could take this opportunity and come up with
tools/lib/{bug,compiler}.h, matching the files in include/linux/ where
those helpers come from, no?

Then make both tools/perf/ and tools/lib/traceevent/ use it, instead of
creating the third copy (kernel proper, perf, libtraceevent).

Then, does anybody know why likely/unlikely is guarded inside __KERNEL__
in include/linux/compiler.h? I think the best thing would be for us to
just use:

#include <linux/compiler.h> 

just like kernel code and be done with it :-\

- Arnaldo

> ---
>  tools/lib/traceevent/event-utils.h | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/tools/lib/traceevent/event-utils.h b/tools/lib/traceevent/event-utils.h
> index e76c9acb92cd..5dc0aec5ab50 100644
> --- a/tools/lib/traceevent/event-utils.h
> +++ b/tools/lib/traceevent/event-utils.h
> @@ -38,6 +38,28 @@ void __vdie(const char *fmt, ...);
>  void __vwarning(const char *fmt, ...);
>  void __vpr_stat(const char *fmt, ...);
>  
> +#define likely(x)	__builtin_expect(!!(x), 1)
> +#define unlikely(x)	__builtin_expect(!!(x), 0)
> +
> +#define __WARN_printf(arg...)	do { fprintf(stderr, arg); } while (0)
> +
> +#define WARN(condition, format...) ({		\
> +	int __ret_warn_on = !!(condition);	\
> +	if (unlikely(__ret_warn_on))		\
> +		__WARN_printf(format);		\
> +	unlikely(__ret_warn_on);		\
> +})
> +
> +#define WARN_ONCE(condition, format...)	({	\
> +	static int __warned;			\
> +	int __ret_warn_once = !!(condition);	\
> +						\
> +	if (unlikely(__ret_warn_once))		\
> +		if (WARN(!__warned, format)) 	\
> +			__warned = 1;		\
> +	unlikely(__ret_warn_once);		\
> +})
> +
>  #define min(x, y) ({				\
>  	typeof(x) _min1 = (x);			\
>  	typeof(y) _min2 = (y);			\
> -- 
> 1.7.11.7
