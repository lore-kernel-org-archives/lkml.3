Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbaEDGjm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 02:39:42 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56102 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbaEDGjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 02:39:40 -0400
Message-ID: <5365E0A5.6040302@gmail.com>
Date: Sun, 04 May 2014 08:39:33 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Heinrich Schuchardt <xypron.glpk@gmx.de>, Eric Paris <eparis@redhat.com>
CC: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/1] fanotify: check file flags passed in fanotify_init
References: <1398958532-11221-1-git-send-email-xypron.glpk@gmx.de>
In-Reply-To: <1398958532-11221-1-git-send-email-xypron.glpk@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heinrich,

On 05/01/2014 05:35 PM, Heinrich Schuchardt wrote:
> Without this patch fanotify_init does not validate the value passed in
> event_f_flags.
> 
> When a fanotify event is read from the fanotify file descriptor a new file
> descriptor is created where file.f_flags = event_f_flags.
> 
> Internal and external open flags are stored together in field f_flags of
> struct file. Hence, an application might create file descriptors with
> internal flags like FMODE_EXEC, FMODE_NOCMTIME set.
> 
> With the patch the value of event_f_flags is checked. Only external open flags
> are allowed. When specifying an invalid value error EINVAL is returned.

Probably, with this patch, it's best to reference the past conversation 
on the topic, where Eric and Jan agree with you that there is a problem:

http://marc.info/?t=139739799900002&r=1&w=2

I agree with the idea of this patch, but the implementation needs work. 

For example, it seems to me very easy that someone would add a new 
open flag and fail to update FANOTIFY_INIT_ALL_EVENT_F_FLAGS, which
would result in some inconsistency that might not be found for a while.
But, that point may be mitigated by the following:

Do we need to allow all of the open flags, or just a subset? 
Certainly,it seems incorrect to allow file creation flags such 
as O_CREAT, which are meaningless in this context. (Quoting open(2),
the file creation flags are O_CLOEXEC, O_CREAT, O_DIRECTORY, O_EXCL,
O_NOCTTY, O_NOFOLLOW, O_TRUNC, and O_TTY_INIT. Furthermore, allowing
flags such as __O_TMPFILE, O_PATH, FASYNC, O_DIRECT, O_NDELAY seems
of dubious value. And I kind of wonder whether O_DIRECT is useful.
I'm unsure about O_SYNC, O_DSYNC, O_NOATIME, O_APPEND; perhaps 
there is a use case.

So, I suspect the allowed set of file status flags might be as small
as (or even smaller than):

     __O_SYNC | O_DSYNC | O_LARGEFILE | O_NOATIME | O_CLOEXEC

Finally, note that O_RDONLY, O_WRONLY, and O_RDWR are not bit masks
(see open(e)) so you can't just  OR those bits, See the definition of
O_ACCMODE in include/uapi/asm-generic/fcntl.h ; there's probably some 
suitable macro based on that constant that you can use.
Basically, you should I think be ANDing against O_ACCMODE
and texting whether the result of the AND matches O_RDONLY or matches 
O_WRONLY or matches O_RDWR.

Cheers,

Michael

> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> ---
>  fs/notify/fanotify/fanotify_user.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 4e565c8..3e456d7 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -25,6 +25,21 @@
>  #define FANOTIFY_DEFAULT_MAX_MARKS	8192
>  #define FANOTIFY_DEFAULT_MAX_LISTENERS	128
>  
> +/*
> + * All flags that may be specified in parameter event_f_flags of fanotify_init.
> + * 
> + * Internal and external open flags are stored together in field f_flags of
> + * struct file. Only external open flags shall be allowed in event_f_flags.
> + * Internal flags like FMODE_EXEC shall be excluded.
> + */
> +#define FANOTIFY_INIT_ALL_EVENT_F_FLAGS				( \
> +		O_RDONLY	| O_WRONLY	| O_RDWR	| \
> +		O_CREAT		| O_EXCL	| O_NOCTTY	| \
> +		O_TRUNC		| O_APPEND	| O_NONBLOCK	| \
> +		__O_SYNC	| O_DSYNC	| FASYNC	| \
> +		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	| \
> +		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	| \
> +		O_PATH		| __O_TMPFILE	| O_NDELAY	)
>  extern const struct fsnotify_ops fanotify_fsnotify_ops;
>  
>  static struct kmem_cache *fanotify_mark_cache __read_mostly;
> @@ -669,6 +684,9 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
>  	if (flags & ~FAN_ALL_INIT_FLAGS)
>  		return -EINVAL;
>  
> +	if (event_f_flags & ~FANOTIFY_INIT_ALL_EVENT_F_FLAGS)
> +		return -EINVAL;
> +
>  	user = get_current_user();
>  	if (atomic_read(&user->fanotify_listeners) > FANOTIFY_DEFAULT_MAX_LISTENERS) {
>  		free_uid(user);
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
