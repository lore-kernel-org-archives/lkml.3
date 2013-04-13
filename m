Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3DMLys (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 07:54:48 -0400
Received: from mout.gmx.net ([212.227.17.22]:59372 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab3DMLyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 07:54:47 -0400
X-Authenticated: #41704822
X-Provags-ID: V01U2FsdGVkX1/q6sQ36GTq8sr0vhmb2/VAEcGco1xX7avE/UZYJr
	gTKWgpqIOodHEE
Message-ID: <5169477D.1000400@gmx.de>
Date: Sat, 13 Apr 2013 13:54:37 +0200
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Justin Maggard <jmaggard10@gmail.com>
CC: linux-kernel@vger.kernel.org, eparis@redhat.com, LinoSanfilippo@gmx.de,
        tzvetanc@commtouch.com
Subject: Re: fanotify: fix support of large files
References: <1360862966-6376-1-git-send-email-jmaggard10@gmail.com>
In-Reply-To: <1360862966-6376-1-git-send-email-jmaggard10@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Justin,

looking at the example at
http://www.lanedo.com/~aleksander/fanotify/fanotify-example.c
the large file support is enabled by passing O_LARGEFILE to fanotify_init:

   if ((fanotify_fd = fanotify_init (FAN_CLOEXEC,
                                     O_RDONLY | O_CLOEXEC | 
O_LARGEFILE)) < 0)

Could you, please, check if this solves your issue.

(I am resending this message because HTML was rejected by
linux-kernel@vger.kernel.org).

Best regards

Heinrich Schuchardt

On 14.02.2013 18:29, Justin Maggard wrote:
> Opening a file of>2GB in an area of the filesystem that has been marked for
> fanotify events currently results in an EOVERFLOW error.  This is particularly
> problematic if you are using fanotify permissions checking, because it prevents
> large files from being opened at all.  Fix this by setting the O_LARGEFILE flag
> on the new file handle.
>
> Signed-off-by: Justin Maggard<jmaggard10@gmail.com>
>
> ---
> fs/notify/fanotify/fanotify_user.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 9ff4a5e..ef02b3d 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -64,6 +64,7 @@ static int create_fd(struct fsnotify_group *group,
>   			struct file **file)
>   {
>   	int client_fd;
> +	int f_flags;
>   	struct file *new_file;
>
>   	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
> @@ -82,12 +83,11 @@ static int create_fd(struct fsnotify_group *group,
>   	 * we need a new file handle for the userspace program so it can read even if it was
>   	 * originally opened O_WRONLY.
>   	 */
> +	f_flags = group->fanotify_data.f_flags | FMODE_NONOTIFY | O_LARGEFILE;
>   	/* it's possible this event was an overflow event.  in that case dentry and mnt
>   	 * are NULL;  That's fine, just don't call dentry open */
>   	if (event->path.dentry&&  event->path.mnt)
> -		new_file = dentry_open(&event->path,
> -				       group->fanotify_data.f_flags | FMODE_NONOTIFY,
> -				       current_cred());
> +		new_file = dentry_open(&event->path, f_flags, current_cred());
>   	else
>   		new_file = ERR_PTR(-EOVERFLOW);
>   	if (IS_ERR(new_file)) {
>

