Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbbAFJ7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 04:59:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:53103 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbbAFJ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 04:59:46 -0500
Date: Tue, 6 Jan 2015 10:59:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150106095930.GK29390@twins.programming.kicks-ass.net>
References: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com>
 <CA+icZUXbbLE-z0SS=0rVnEYq5zFr1f4omOuSS7BL4OpAv0eagA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUXbbLE-z0SS=0rVnEYq5zFr1f4omOuSS7BL4OpAv0eagA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 10:34:30AM +0100, Sedat Dilek wrote:
> I tried to do such a "similiar" (quick) fix analog to the mentioned
> "sched, inotify: Deal with nested sleeps" patch from Peter.
> If I did correct... It does not make the call-trace go away here.

Are you very sure its the same splat and not another? I don't appear to
have anything triggering this on my test boxes (which are very much not
infected with system-disease).

The patch does look about right.

> ---
>  fs/notify/fanotify/fanotify_user.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index c991616..65e96e2 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -14,6 +14,7 @@
>  #include <linux/types.h>
>  #include <linux/uaccess.h>
>  #include <linux/compat.h>
> +#include <linux/wait.h>
>  
>  #include <asm/ioctls.h>
>  
> @@ -259,15 +260,15 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
>  	struct fsnotify_event *kevent;
>  	char __user *start;
>  	int ret;
> -	DEFINE_WAIT(wait);
> +	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>  
>  	start = buf;
>  	group = file->private_data;
>  
>  	pr_debug("%s: group=%p\n", __func__, group);
>  
> +	add_wait_queue(&group->notification_waitq, &wait);
>  	while (1) {
> -		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
>  
>  		mutex_lock(&group->notification_mutex);
>  		kevent = get_one_event(group, count);
> @@ -289,7 +290,7 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
>  
>  			if (start != buf)
>  				break;
> -			schedule();
> +			wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
>  			continue;
>  		}
>  
> @@ -318,8 +319,8 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
>  		buf += ret;
>  		count -= ret;
>  	}
> +	remove_wait_queue(&group->notification_waitq, &wait);
>  
> -	finish_wait(&group->notification_waitq, &wait);
>  	if (start != buf && ret != -EFAULT)
>  		ret = buf - start;
>  	return ret;
> -- 
> 2.2.1
> 

