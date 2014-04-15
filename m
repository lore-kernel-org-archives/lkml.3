Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaDOH0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:26:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51500 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbaDOH0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:26:38 -0400
Date: Tue, 15 Apr 2014 09:26:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140415072635.GA5984@pd.tnic>
References: <20140402144219.4cafbe37@gandalf.local.home>
 <20140402221212.GD16570@mguzik.redhat.com>
 <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
 <alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
 <20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org>
 <CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
 <alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz>
 <CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
 <CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

just checking on the status here: what did we decide on this one in
the end?

It works as expected, it is a good idea to have it as a protection
against every user space abuser, maybe we should apply it now that the
merge window is over and things are calming down?

Or should I remind you the next merge window?

Thanks.

On Wed, Apr 02, 2014 at 06:47:57PM -0700, Linus Torvalds wrote:
> On Wed, Apr 2, 2014 at 4:52 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > TOTALLY UNTESTED. But it really isn't complex.
> 
> Oh, and here's a patch that is actually lightly tested. I did
> 
>     while :; do echo hello; done > /dev/kmsg
> 
> (the 'yes' program buffers output, so won't work) and I get
> 
>     [  122.062912] hello
>     [  122.062915] hello
>     [  122.062918] hello
>     [  122.062921] hello
>     [  122.062924] hello
>     [  122.062927] hello
>     [  122.062930] hello
>     [  122.062932] hello
>     [  122.062935] hello
>     [  122.062938] hello
>     [  127.062671] bash: 2104439 callbacks suppressed
> 
> so it works (repeating every five seconds, as expected).
> 
> It's definitely not perfect - if we suppress output, and the process
> then closes the file descriptor rather than continuing to write more,
> you won't  get that "suppressed" message. But it's a usable starting
> point for testing and commentary on the actual limits.
> 
> So we should probably add reporting about suppressed messages at file
> close time, and we should tweak the limits (for example, perhaps not
> limit things if the buffers are largely empty - which happens at
> bootup), but on the whole I think this is a reasonable thing to do.
> 
> Whether it actually fixes the problem that Borislav had is
> questionable, of course. For all I know, systemd debug mode generates
> so much data in *other* ways and then causes feedback loops with the
> kernel debugging that this patch is totally immaterial, and dmesg was
> never the main issue. But unlike the "hide 'debug' from
> /proc/cmdline", I think this patch at least _conceptually_ makes a lot
> of sense, even if systemd gets fixed, so ...
> 
> Borislav?
> 
>                 Linus

>  kernel/printk/printk.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 4dae9cbe9259..b01ba10fb1b9 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -410,6 +410,7 @@ struct devkmsg_user {
>  	u64 seq;
>  	u32 idx;
>  	enum log_flags prev;
> +	struct ratelimit_state rs;
>  	struct mutex lock;
>  	char buf[8192];
>  };
> @@ -421,11 +422,15 @@ static ssize_t devkmsg_writev(struct kiocb *iocb, const struct iovec *iv,
>  	int i;
>  	int level = default_message_loglevel;
>  	int facility = 1;	/* LOG_USER */
> +	struct file *file = iocb->ki_filp;
> +	struct devkmsg_user *user = file->private_data;
>  	size_t len = iov_length(iv, count);
>  	ssize_t ret = len;
>  
> -	if (len > LOG_LINE_MAX)
> +	if (!user || len > LOG_LINE_MAX)
>  		return -EINVAL;
> +	if (!___ratelimit(&user->rs, current->comm))
> +		return ret;
>  	buf = kmalloc(len+1, GFP_KERNEL);
>  	if (buf == NULL)
>  		return -ENOMEM;
> @@ -656,21 +661,22 @@ static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
>  static int devkmsg_open(struct inode *inode, struct file *file)
>  {
>  	struct devkmsg_user *user;
> -	int err;
> -
> -	/* write-only does not need any file context */
> -	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
> -		return 0;
>  
> -	err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
> -				       SYSLOG_FROM_READER);
> -	if (err)
> -		return err;
> +	/* write-only does not need to check read permissions */
> +	if ((file->f_flags & O_ACCMODE) != O_WRONLY) {
> +		int err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
> +					       SYSLOG_FROM_READER);
> +		if (err)
> +			return err;
> +	}
>  
>  	user = kmalloc(sizeof(struct devkmsg_user), GFP_KERNEL);
>  	if (!user)
>  		return -ENOMEM;
>  
> +	/* Configurable? */
> +	ratelimit_state_init(&user->rs, DEFAULT_RATELIMIT_INTERVAL, DEFAULT_RATELIMIT_BURST);
> +
>  	mutex_init(&user->lock);
>  
>  	raw_spin_lock_irq(&logbuf_lock);


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
