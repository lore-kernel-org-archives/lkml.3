Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaATRPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:15:45 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:48805 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbaATRPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:15:43 -0500
Message-ID: <1390238130.3865.20.camel@localhost.localdomain>
Subject: Re: [PATCHv5 5/7] fanotify: enable close-on-exec on events' fd when
 requested in fanotify_init()
From: Yann Droneaud <ydroneaud@opteya.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 20 Jan 2014 18:15:30 +0100
In-Reply-To: <3d9591f81e62a78a726721c8052b3910870db35e.1388952061.git.ydroneaud@opteya.com>
References: <cover.1388952061.git.ydroneaud@opteya.com>
	 <3d9591f81e62a78a726721c8052b3910870db35e.1388952061.git.ydroneaud@opteya.com>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lino,

I've recently sent this patch which may fix a bug in the way fanotify
creates its file descriptors.

I failed to noticed you've been working recently on fanotify subsystem
and miss the opportunity to add you in the Cc:s. 

Please have a look to this patch and help to get it merged.

Le dimanche 05 janvier 2014 à 21:36 +0100, Yann Droneaud a écrit :
> According to commit 80af258867648, file descriptor created as part
> of file access notification events inherit flags from the event_f_flags
> argument passed to syscall fanotify_init(2).
> 
> So while it is legal for userspace to call fanotify_init() with O_CLOEXEC
> as part of its second argument, O_CLOEXEC is currently silently ignored.
> 
> Indeed event_f_flags are only given to dentry_open(), which only
> seems to care about O_ACCMODE and O_PATH in do_dentry_open(), O_DIRECT
> in open_check_o_direct() and O_LARGEFILE in generic_file_open().
> 
> More, there's no effective check on event_f_flags value that would
> catch unknown / unsupported values, unlike the one on f_flags argument
> of the syscall (see FAN_ALL_INIT_FLAGS in include/uapi/linux/fanotify.h).

...

> But it seems logical to set close-on-exec flag on the file descriptor
> if userspace is allowed to request it with O_CLOEXEC.
> 

...

> So this patch replaces call to macro get_unused_fd() by a call to
> function get_unused_fd_flags() with event_f_flags value as argument.
> This way O_CLOEXEC flag in the second argument of fanotify_init(2)
> syscall is interpreted so that close-on-exec get enabled.

...

> Cc: Eric Paris <eparis@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: stable@vger.kernel.org
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> Link:
> http://lkml.kernel.org/r/cover.1388952061.git.ydroneaud@opteya.com
> 
> ---
>  fs/notify/fanotify/fanotify_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 57d7c083cb4b..6d0eaabba02e 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -71,7 +71,7 @@ static int create_fd(struct fsnotify_group *group,
>  
>  	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
>  
> -	client_fd = get_unused_fd();
> +	client_fd = get_unused_fd_flags(group->fanotify_data.f_flags);
>  	if (client_fd < 0)
>  		return client_fd;
>  

Regards.

-- 
Yann Droneaud
OPTEYA



