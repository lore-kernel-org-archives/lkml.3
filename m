Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbaKRJK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:10:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaKRJKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:10:25 -0500
Date: Tue, 18 Nov 2014 10:10:22 +0100
From: Jan Kara <jack@suse.cz>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, bobby.prani@gmail.com, pmladek@suse.cz,
        jack@suse.cz, mcgrof@suse.com, rostedt@goodmis.org, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: drop logbuf_cpu volatile qualifier
Message-ID: <20141118091022.GA19318@quack.suse.cz>
References: <1415992771-9071-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415992771-9071-1-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 14-11-14 13:19:31, Alex Elder wrote:
> Pranith Kumar posted a patch in which removed the "volatile"
> qualifier for the "logbuf_cpu" variable in vprintk_emit().
>     https://lkml.org/lkml/2014/11/13/894
> In his patch, he used ACCESS_ONCE() for all references to
> that symbol to provide whatever protection was intended.
> 
> There was some discussion that followed, and in the end
> Stephen Rostedt concluded that not only was "volatile" not
> needed, neither was it required to use ACCESS_ONCE().  I
> offered an elaborate description that concluded Stephen
> was right, and Pranith asked me to submit an alternative
> patch.  And this is it.
> 
> The basic reason "volatile" is not needed is that "logbuf_cpu" has
> static storage duration, and vprintk_emit() is an exported
> interface.  This means that the value of logbuf_cpu must be read
> from memory the first time it is used in a particular call of
> vprintk_emit().  The variable's value is read only once in that
> function, when it's read it'll be the copy from memory (or cache).
> 
> In addition, the value of "logbuf_cpu" is only ever written under
> protection of a spinlock.  So the value that is read is the "real"
> value (and not an out-of-date cached one).  If its value is not
> UINT_MAX, it is the current CPU's processor id, and it will have
> been last written by the running CPU.
> 
> Reported-by: Pranith Kumar <bobby.prani@gmail.com>
> Fix-suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> 	Note!!!  I am not able to stress test this patch.
  The patch looks good to me. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

  BTW, stress-testing this is tough. I never saw printk recursion happening
in practice - only when I screwed up something in printk code when
experimenting.

								Honza

>  kernel/printk/printk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index ced2b84..fefc8d0 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1627,7 +1627,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	int printed_len = 0;
>  	bool in_sched = false;
>  	/* cpu currently holding logbuf_lock in this function */
> -	static volatile unsigned int logbuf_cpu = UINT_MAX;
> +	static unsigned int logbuf_cpu = UINT_MAX;
>  
>  	if (level == SCHED_MESSAGE_LOGLEVEL) {
>  		level = -1;
> -- 
> 1.9.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
