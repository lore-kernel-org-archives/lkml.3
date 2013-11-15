Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3KOO5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:57:45 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:54402 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab3KOO5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:57:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Amit Pundir <amit.pundir@linaro.org>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH v3] epoll: drop EPOLLWAKEUP if PM_SLEEP is disabled
Date: Fri, 15 Nov 2013 16:10:06 +0100
Message-ID: <4921878.yXb9shUEsy@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1384500391-20513-1-git-send-email-amit.pundir@linaro.org>
References: <1384500391-20513-1-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 15, 2013 12:56:31 PM Amit Pundir wrote:
> Drop EPOLLWAKEUP from epoll events mask if CONFIG_PM_SLEEP is disabled.
> 
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Or am I supposed to take care of this?

> ---
> Changes in v3:
>  Renamed ep_epollwakeup_check() to ep_take_care_of_epollwakeup().
>  Didn't update ep_create_wakeup_source() to return -ENOSYS if PM_SLEEP is unset.
> ---
>  fs/eventpoll.c                 |    3 +--
>  include/uapi/linux/eventpoll.h |   13 ++++++++++++-
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 473e09d..dbf382b 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1820,8 +1820,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
>  		goto error_tgt_fput;
>  
>  	/* Check if EPOLLWAKEUP is allowed */
> -	if ((epds.events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
> -		epds.events &= ~EPOLLWAKEUP;
> +	ep_take_care_of_epollwakeup(&epds);
>  
>  	/*
>  	 * We have to check that the file structure underneath the file descriptor
> diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
> index 2c267bc..bc81fb2 100644
> --- a/include/uapi/linux/eventpoll.h
> +++ b/include/uapi/linux/eventpoll.h
> @@ -61,5 +61,16 @@ struct epoll_event {
>  	__u64 data;
>  } EPOLL_PACKED;
>  
> -
> +#ifdef CONFIG_PM_SLEEP
> +static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
> +{
> +	if ((epev->events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
> +		epev->events &= ~EPOLLWAKEUP;
> +}
> +#else
> +static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
> +{
> +	epev->events &= ~EPOLLWAKEUP;
> +}
> +#endif
>  #endif /* _UAPI_LINUX_EVENTPOLL_H */
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
