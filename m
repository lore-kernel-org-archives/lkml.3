Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaDXUY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 16:24:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbaDXUYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 16:24:25 -0400
Date: Thu, 24 Apr 2014 22:24:22 +0200
From: Jan Kara <jack@suse.cz>
To: Will Woods <wwoods@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fanotify: fix -EOVERFLOW with large files on 64-bit
Message-ID: <20140424202422.GG13573@quack.suse.cz>
References: <1398359724-10057-1-git-send-email-wwoods@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398359724-10057-1-git-send-email-wwoods@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24-04-14 13:15:24, Will Woods wrote:
> On 64-bit systems, O_LARGEFILE is automatically added to flags inside
> the open() syscall (also openat(), blkdev_open(), etc).
> Userspace therefore defines O_LARGEFILE to be 0 - you can use it,
> but it's a no-op. Everything should be O_LARGEFILE by default.
> 
> But: when fanotify does create_fd() it uses dentry_open(), which skips
> all that. And userspace can't set O_LARGEFILE in fanotify_init() because
> it's defined to 0. So if fanotify gets an event regarding a large file,
> the read() will just fail with -EOVERFLOW.
> 
> This patch adds O_LARGEFILE to fanotify_init()'s event_f_flags on 64-bit
> systems, using the same test as open()/openat()/etc.
> 
> Resolves: https://bugzilla.redhat.com/show_bug.cgi?id=696821
> 
> Acked-by: Eric Paris <eparis@redhat.com>
> Signed-off-by: Will Woods <wwoods@redhat.com>
  Looks good to me. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

I've added Andrew to CC since he merges fanotify patches these days...

								Honza
> ---
>  fs/notify/fanotify/fanotify_user.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 4e565c8..732648b 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -698,6 +698,8 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
>  	}
>  	group->overflow_event = &oevent->fse;
>  
> +	if (force_o_largefile())
> +		event_f_flags |= O_LARGEFILE;
>  	group->fanotify_data.f_flags = event_f_flags;
>  #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
>  	spin_lock_init(&group->fanotify_data.access_lock);
> -- 
> 1.9.0
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
