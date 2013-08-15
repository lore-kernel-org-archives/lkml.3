Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091Ab3HOBiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 21:38:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12496 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab3HOBiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 21:38:20 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=1X_fbBvAaXUA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=u2N__WHdo-IA:10 a=bDvv1EgpFll4P0GfHv8A:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 14 Aug 2013 21:38:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, mhocko@suse.cz
Subject: Re: [PATCH 3/4] printk: Defer printing to irq work when we printed
 too much
Message-ID: <20130814213818.34b3a11e@gandalf.local.home>
In-Reply-To: <1376486908-26063-4-git-send-email-jack@suse.cz>
References: <1376486908-26063-1-git-send-email-jack@suse.cz>
	<1376486908-26063-4-git-send-email-jack@suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013 15:28:27 +0200
Jan Kara <jack@suse.cz> wrote:

> A CPU can be caught in console_unlock() for a long time (tens of seconds
> are reported by our customers) when other CPUs are using printk heavily
> and serial console makes printing slow. Despite serial console drivers
> are calling touch_nmi_watchdog() this triggers softlockup warnings
> because interrupts are disabled for the whole time console_unlock() runs
> (e.g. vprintk() calls console_unlock() with interrupts disabled). Thus
> IPIs cannot be processed and other CPUs get stuck spinning in calls like
> smp_call_function_many(). Also RCU eventually starts reporting lockups.
> 
> In my artifical testing I can also easily trigger a situation when disk
> disappears from the system apparently because commands to / from it
> could not be delivered for long enough. This is why just silencing
> watchdogs isn't a reliable solution to the problem and we simply have to
> avoid spending too long in console_unlock() with interrupts disabled.
> 
> The solution this patch works toward is to postpone printing to a later
> moment / different CPU when we already printed over 1000 characters in
> current console_unlock() invocation. This is a crude heuristic but
> measuring time we spent printing doesn't seem to be really viable - we
> cannot rely on high resolution time being available and with interrupts
> disabled jiffies are not updated. The value 1000 was chosen so that
> things are still bearable with 9600 baud serial console and OTOH it
> shouldn't cause offloading of printing in common cases.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  kernel/printk/printk.c | 62 ++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 52 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 9208e17..28c220a 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2026,31 +2026,49 @@ out:
>  	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
>  }
>  
> +/*
> + * How much characters can we print in one call of printk before offloading
> + * printing work
> + */
> +#define MAX_PRINTK_CHARS 1000

This really needs to be configurable. 1000 may be good for you, but may
not be good for others. Heck, we should be able to disable this
offloading too.

This should probably be added to the printk /proc/sys/kernel/... files.

If it is set to zero, then disable any offloading.

-- Steve


> +
> +/* Should we stop printing on this cpu? */
> +static bool cpu_stop_printing(int printed_chars)
> +{
> +	/* Oops? Print everything now to maximize chances user will see it */
> +	if (oops_in_progress)
> +		return false;
> +	return printed_chars > MAX_PRINTK_CHARS;
> +}
> +
>  /**
