Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbaGIQ3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:29:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbaGIQ3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:29:38 -0400
Date: Wed, 9 Jul 2014 18:29:35 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, ak@linux.intel.com, bp@suse.de, jack@suse.cz,
        john.stultz@linaro.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] printk: miscellaneous cleanups
Message-ID: <20140709162935.GB26508@pathway.suse.cz>
References: <1404911056-29064-1-git-send-email-elder@linaro.org>
 <1404911056-29064-5-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404911056-29064-5-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sending once again as a correct reply. I am sorry for the
confusion. I think that it is high time for me to go home and sleep :-)

On Wed 2014-07-09 08:04:16, Alex Elder wrote:
> This patch contains some small cleanups to kernel/printk/printk.c.
> None of them should cause any change in behavior.
>   - When CONFIG_PRINTK is defined, parenthesize the value of LOG_LINE_MAX.
>   - When CONFIG_PRINTK is *not* defined, there is an extra LOG_LINE_MAX
>     definition; delete it.
>   - Pull an assignment out of a conditional expression in console_setup().
>   - Use isdigit() in console_setup() rather than open coding it.
>   - In update_console_cmdline(), drop a NUL-termination assignment;
>     the strlcpy() call that precedes it guarantees it's not needed.
>   - Simplify some logic in printk_timed_ratelimit().
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  kernel/printk/printk.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 6f75e8a..909029e 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -45,6 +45,7 @@
>  #include <linux/poll.h>
>  #include <linux/irq_work.h>
>  #include <linux/utsname.h>
> +#include <linux/ctype.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -257,7 +258,7 @@ static u64 clear_seq;
>  static u32 clear_idx;
>  
>  #define PREFIX_MAX		32
> -#define LOG_LINE_MAX		1024 - PREFIX_MAX
> +#define LOG_LINE_MAX		(1024 - PREFIX_MAX)
>  
>  /* record buffer */
>  #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
> @@ -1794,7 +1795,7 @@ EXPORT_SYMBOL(printk);
>  
>  #define LOG_LINE_MAX		0
>  #define PREFIX_MAX		0
> -#define LOG_LINE_MAX 0
> +
>  static u64 syslog_seq;
>  static u32 syslog_idx;
>  static u64 console_seq;
> @@ -1895,7 +1896,8 @@ static int __init console_setup(char *str)
>  		strncpy(buf, str, sizeof(buf) - 1);
>  	}
>  	buf[sizeof(buf) - 1] = 0;
> -	if ((options = strchr(str, ',')) != NULL)
> +	options = strchr(str, ',');
> +	if (options)
>  		*(options++) = 0;
>  #ifdef __sparc__
>  	if (!strcmp(str, "ttya"))
> @@ -1904,7 +1906,7 @@ static int __init console_setup(char *str)
>  		strcpy(buf, "ttyS1");
>  #endif
>  	for (s = buf; *s; s++)
> -		if ((*s >= '0' && *s <= '9') || *s == ',')
> +		if (isdigit(*s) || *s == ',')
>  			break;
>  	idx = simple_strtoul(s, NULL, 10);
>  	*s = 0;
> @@ -1943,7 +1945,6 @@ int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, cha
>  	     i++, c++)
>  		if (strcmp(c->name, name) == 0 && c->index == idx) {
>  			strlcpy(c->name, name_new, sizeof(c->name));
> -			c->name[sizeof(c->name) - 1] = 0;
>  			c->options = options;
>  			c->index = idx_new;
>  			return i;
> @@ -2611,14 +2612,13 @@ EXPORT_SYMBOL(__printk_ratelimit);
>  bool printk_timed_ratelimit(unsigned long *caller_jiffies,
>  			unsigned int interval_msecs)
>  {
> -	if (*caller_jiffies == 0
> -			|| !time_in_range(jiffies, *caller_jiffies,
> -					*caller_jiffies
> -					+ msecs_to_jiffies(interval_msecs))) {
> -		*caller_jiffies = jiffies;
> -		return true;
> -	}
> -	return false;
> +	unsigned long elapsed = jiffies - *caller_jiffies;

I wondered if the deduction might be negative. Well, it should not be
if none manipulates *caller_jiffies in a strange way. If it happens,
the following condition will most likely fail and *caller_jiffies will
get reset to jiffies. It looks reasonable to me.

Reviewed-by: Petr Mladek <pmladek@suse.cz>

> +	if (*caller_jiffies && elapsed <= msecs_to_jiffies(interval_msecs))
> +		return false;
> +
> +	*caller_jiffies = jiffies;
> +	return true;
>  }
>  EXPORT_SYMBOL(printk_timed_ratelimit);

Best Regards,
Petr
