Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaHTT3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:29:23 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:46802 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaHTT3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:29:22 -0400
Date: Wed, 20 Aug 2014 19:29:20 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        NeilBrown <neilb@suse.de>, Jason Baron <jbaron@akamai.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Amit Pundir <amit.pundir@linaro.org>, stable@vger.kernel.org
Subject: Re: [PATCH] eventpoll: fix uninitialized variable in epoll_ctl
Message-ID: <20140820192920.GA25619@dcvr.yhbt.net>
References: <1408469053-9262-1-git-send-email-nicolas.iooss_linux@m4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408469053-9262-1-git-send-email-nicolas.iooss_linux@m4x.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Iooss <nicolas.iooss_linux@m4x.org> wrote:
> When calling epoll_ctl with operation EPOLL_CTL_DEL, structure epds is
> not initialized but ep_take_care_of_epollwakeup reads its event field.
> When this unintialized field has EPOLLWAKEUP bit set, a capability check
> is done for CAP_BLOCK_SUSPEND in ep_take_care_of_epollwakeup.  This
> produces unexpected messages in the audit log, such as (on a system
> running SELinux):
> 
>     type=AVC msg=audit(1408212798.866:410): avc:  denied
>     { block_suspend } for  pid=7754 comm="dbus-daemon" capability=36
>     scontext=unconfined_u:unconfined_r:unconfined_t
>     tcontext=unconfined_u:unconfined_r:unconfined_t
>     tclass=capability2 permissive=1
> 
>     type=SYSCALL msg=audit(1408212798.866:410): arch=c000003e syscall=233
>     success=yes exit=0 a0=3 a1=2 a2=9 a3=7fffd4d66ec0 items=0 ppid=1
>     pid=7754 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
>     fsgid=0 tty=(none) ses=3 comm="dbus-daemon"
>     exe="/usr/bin/dbus-daemon"
>     subj=unconfined_u:unconfined_r:unconfined_t key=(null)
> 
> ("arch=c000003e syscall=233 a1=2" means "epoll_ctl(op=EPOLL_CTL_DEL)")
> 
> Remove use of epds in epoll_ctl when op == EPOLL_CTL_DEL.
> 
> Fixes: 4d7e30d98939 ("epoll: Add a flag, EPOLLWAKEUP, to prevent suspend
> while epoll events are ready")
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>

Looks good to me.  Tested without regressions on several of my
(non-EPOLLWAKEUP) projects.  Adding a few more folks to the Cc: list.

Acked-by: Eric Wong <normalperson@yhbt.net>

> ---
>  fs/eventpoll.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index b10b48c..7bcfff9 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1852,7 +1852,8 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
>  		goto error_tgt_fput;
>  
>  	/* Check if EPOLLWAKEUP is allowed */
> -	ep_take_care_of_epollwakeup(&epds);
> +	if (ep_op_has_event(op))
> +		ep_take_care_of_epollwakeup(&epds);
>  
>  	/*
>  	 * We have to check that the file structure underneath the file descriptor
> -- 
> 1.7.10.4
