Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbaD1Xlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:41:39 -0400
Received: from longford.logfs.org ([213.229.74.203]:43246 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbaD1Xli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:41:38 -0400
Date: Mon, 28 Apr 2014 19:40:39 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org, cxie@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] printk: Print cpu number along with time
Message-ID: <20140428234039.GC6358@logfs.org>
References: <20140423125352.704f9fb2@annuminas.surriel.com>
 <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
 <20140424005247.GA17713@logfs.org>
 <20140424194024.GA25446@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140424194024.GA25446@logfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 April 2014 15:40:24 -0400, Jörn Engel wrote:
> On Wed, 23 April 2014 20:52:47 -0400, Jörn Engel wrote:
> > 
> > I use the patch below for some time now.  While it doesn't avoid the
> > log pollution in the first place, it lessens the impact somewhat.
> 
> Added a config option and ported it to current -linus.  Andrew, would
> you take this patch?

Andrew?  Did you dislike this patch for some reason or just miss it in
the thread?

> ---
> 
> Sometimes the printk log is heavily interleaving between different cpus.
> This is particularly bad when you have two backtraces at the same time,
> but can be annoying in other cases as well.  With an explicit cpu
> number, a simple grep can disentangle the mess for you.
> 
> Signed-off-by: Joern Engel <joern@logfs.org>
> ---
>  kernel/printk/printk.c | 19 ++++++++++++++++---
>  lib/Kconfig.debug      |  9 +++++++++
>  2 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index a45b50962295..b9e464924825 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -200,6 +200,7 @@ struct printk_log {
>  	u16 len;		/* length of entire record */
>  	u16 text_len;		/* length of text buffer */
>  	u16 dict_len;		/* length of dictionary buffer */
> +	u16 cpu;		/* cpu the message was generated on */
>  	u8 facility;		/* syslog facility */
>  	u8 flags:5;		/* internal record flags */
>  	u8 level:3;		/* syslog level */
> @@ -346,6 +347,7 @@ static void log_store(int facility, int level,
>  	msg->facility = facility;
>  	msg->level = level & 7;
>  	msg->flags = flags & 0x1f;
> +	msg->cpu = smp_processor_id();
>  	if (ts_nsec > 0)
>  		msg->ts_nsec = ts_nsec;
>  	else
> @@ -859,7 +861,7 @@ static bool printk_time;
>  #endif
>  module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
>  
> -static size_t print_time(u64 ts, char *buf)
> +static size_t print_time(u64 ts, u16 cpu, char *buf)
>  {
>  	unsigned long rem_nsec;
>  
> @@ -868,11 +870,20 @@ static size_t print_time(u64 ts, char *buf)
>  
>  	rem_nsec = do_div(ts, 1000000000);
>  
> +#ifdef CONFIG_PRINTK_CPU
> +	if (!buf)
> +		return snprintf(NULL, 0, "[%5lu.000000,%02x] ",
> +				(unsigned long)ts, cpu);
> +
> +	return sprintf(buf, "[%5lu.%06lu,%02x] ",
> +			(unsigned long)ts, rem_nsec / 1000, cpu);
> +#else
>  	if (!buf)
>  		return snprintf(NULL, 0, "[%5lu.000000] ", (unsigned long)ts);
>  
>  	return sprintf(buf, "[%5lu.%06lu] ",
>  		       (unsigned long)ts, rem_nsec / 1000);
> +#endif
>  }
>  
>  static size_t print_prefix(const struct printk_log *msg, bool syslog, char *buf)
> @@ -894,7 +905,7 @@ static size_t print_prefix(const struct printk_log *msg, bool syslog, char *buf)
>  		}
>  	}
>  
> -	len += print_time(msg->ts_nsec, buf ? buf + len : NULL);
> +	len += print_time(msg->ts_nsec, msg->cpu, buf ? buf + len : NULL);
>  	return len;
>  }
>  
> @@ -1391,6 +1402,7 @@ static struct cont {
>  	size_t cons;			/* bytes written to console */
>  	struct task_struct *owner;	/* task of first print*/
>  	u64 ts_nsec;			/* time of first print */
> +	u16 cpu;			/* cpu the message was generated on */
>  	u8 level;			/* log level of first message */
>  	u8 facility;			/* log level of first message */
>  	enum log_flags flags;		/* prefix, newline flags */
> @@ -1440,6 +1452,7 @@ static bool cont_add(int facility, int level, const char *text, size_t len)
>  		cont.facility = facility;
>  		cont.level = level;
>  		cont.owner = current;
> +		cont.cpu = smp_processor_id();
>  		cont.ts_nsec = local_clock();
>  		cont.flags = 0;
>  		cont.cons = 0;
> @@ -1461,7 +1474,7 @@ static size_t cont_print_text(char *text, size_t size)
>  	size_t len;
>  
>  	if (cont.cons == 0 && (console_prev & LOG_NEWLINE)) {
> -		textlen += print_time(cont.ts_nsec, text);
> +		textlen += print_time(cont.ts_nsec, cont.cpu, text);
>  		size -= textlen;
>  	}
>  
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 819ac51202c0..bdec67eca521 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -15,6 +15,15 @@ config PRINTK_TIME
>  	  The behavior is also controlled by the kernel command line
>  	  parameter printk.time=1. See Documentation/kernel-parameters.txt
>  
> +config PRINTK_CPU
> +	bool "Show CPU number along with timing information"
> +	depends on PRINTK_TIME
> +	help
> +	  Selecting this option adds the CPU number to be added to
> +	  timestamps of printk() messages.  This can be useful when
> +	  messages from several CPUs are interleaved, in particular
> +	  for stack traces.
> +
>  config DEFAULT_MESSAGE_LOGLEVEL
>  	int "Default message log level (1-7)"
>  	range 1 7
> -- 
> 2.0.0.rc0.1.g7b2ba98
> 

Jörn

--
The grand essentials of happiness are: something to do, something to
love, and something to hope for.
-- Allan K. Chalmers
