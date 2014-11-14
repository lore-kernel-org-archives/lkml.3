Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161766AbaKNTpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:45:19 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:11061 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751402AbaKNTpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:45:18 -0500
Date: Fri, 14 Nov 2014 14:45:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, bobby.prani@gmail.com, pmladek@suse.cz,
        jack@suse.cz, mcgrof@suse.com, joe@perches.com,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] printk: drop logbuf_cpu volatile qualifier
Message-ID: <20141114144515.5b3e7d32@gandalf.local.home>
In-Reply-To: <1415992771-9071-1-git-send-email-elder@linaro.org>
References: <1415992771-9071-1-git-send-email-elder@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 13:19:31 -0600
Alex Elder <elder@linaro.org> wrote:

> Pranith Kumar posted a patch in which removed the "volatile"
> qualifier for the "logbuf_cpu" variable in vprintk_emit().
>     https://lkml.org/lkml/2014/11/13/894
> In his patch, he used ACCESS_ONCE() for all references to
> that symbol to provide whatever protection was intended.
> 
> There was some discussion that followed, and in the end
> Stephen Rostedt concluded that not only was "volatile" not

I don't know of a Stephen Rostedt. J

> needed, neither was it required to use ACCESS_ONCE().  I
> offered an elaborate description that concluded Stephen

Who is this Stephen you talk about?

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

Ah, I know of him!


> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> 	Note!!!  I am not able to stress test this patch.

I know the guys at SuSE are stressing printk a bit. Maybe they can come
up with something. (Cc'd).

Thanks,

-- Steve

> 
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

