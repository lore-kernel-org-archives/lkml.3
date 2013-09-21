Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3IUXwc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 19:52:32 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:39142 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab3IUXwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 19:52:31 -0400
Date: Sat, 21 Sep 2013 18:52:26 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] printk: report boot console names during cut-over
Message-ID: <20130921235217.GB12132@localhost.localdomain>
References: <20130920153400.GA32516@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130920153400.GA32516@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 08:34:01AM -0700, Kees Cook wrote:
> This reports the names of boot consoles as they're being disabled to
> help identify which is which during cut-over. Helps answer the question
> "which boot console actually got activated?" once the regular console
> is running, mostly when debugging boot console failures.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  kernel/printk/printk.c |   16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index b4e8500..0dc54c9 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2361,14 +2361,18 @@ void register_console(struct console *newcon)
>  	if (bcon &&
>  	    ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV) &&
>  	    !keep_bootcon) {
> -		/* we need to iterate through twice, to make sure we print
> -		 * everything out, before we unregister the console(s)
> +		/* We need to iterate through all boot consoles, to make
> +		 * sure we print everything out, before we unregister them.
>  		 */
> -		printk(KERN_INFO "console [%s%d] enabled, bootconsole disabled\n",
> -			newcon->name, newcon->index);
> -		for_each_console(bcon)
> -			if (bcon->flags & CON_BOOT)
> +		for_each_console(bcon) {
> +			if (bcon->flags & CON_BOOT) {
> +				printk(KERN_INFO "console [%s%d] enabled, "
> +					"bootconsole [%s%d] disabled\n",
> +					newcon->name, newcon->index,
> +					bcon->name, bcon->index);
>  				unregister_console(bcon);

Looks useful! But I think the "console %foo disabled" message should move to unregister_console()
instead. That way it also handles printk_late_init() and all other console unregisters.

Thanks.
