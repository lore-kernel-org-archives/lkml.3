Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaDXTza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:55:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaDXTz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:55:28 -0400
Date: Thu, 24 Apr 2014 12:58:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, cxie@redhat.com,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] printk: Print cpu number along with time
Message-ID: <20140424195821.GA3092@kroah.com>
References: <20140423125352.704f9fb2@annuminas.surriel.com>
 <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
 <20140424005247.GA17713@logfs.org>
 <20140424194024.GA25446@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140424194024.GA25446@logfs.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 03:40:24PM -0400, Jörn Engel wrote:
> On Wed, 23 April 2014 20:52:47 -0400, Jörn Engel wrote:
> > 
> > I use the patch below for some time now.  While it doesn't avoid the
> > log pollution in the first place, it lessens the impact somewhat.
> 
> Added a config option and ported it to current -linus.  Andrew, would
> you take this patch?
> 
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

%02x for a cpu?  What happens on machines with 8k cpus?

And is this really an issue?  Debugging by using printk is fun, but not
really something that people need to add a cpu number to.  Why not just
use a tracepoint in your code to get the needed information instead?

thanks,

greg k-h
