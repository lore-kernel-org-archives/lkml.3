Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3KKVKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:10:40 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:50246 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab3KKVKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:10:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Amit Pundir <amit.pundir@linaro.org>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [RFC][PATCH] epoll: allow EPOLLWAKEUP flag if PM_SLEEP is enabled
Date: Mon, 11 Nov 2013 22:22:55 +0100
Message-ID: <7789635.0eeyCxz2tM@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1384192591-20916-1-git-send-email-amit.pundir@linaro.org>
References: <1384192591-20916-1-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 11, 2013 11:26:31 PM Amit Pundir wrote:
> I stumbled upon ENOMEM error from epoll_ctl() while bringing up Android-4.4 
> on a device that does not yet support PM_SLEEP.

Well, Android depends on PM_SLEEP which is a known fact.

> While looking into the problem, I found that ep_create_wakeup_source()
> reports ENOMEM if wakeup_source_register() returns NULL.
> ep_create_wakeup_source() assumes that NULL is only returned if we run
> into ENOMEM but NULL is also returned when CONFIG_PM_SLEEP is disabled.

So the error value should not be ENOMEM.

> If CONFIG_PM_SLEEP is disabled, stripping the EPOLLWAKEUP flag seems to
> be a reasonable solution here, allowing the call to succeed, while
> dropping the wakeup logic.  While returning EINVAL might also be a good
> solution, stripping the flag seems to follow the established behavior,
> as is done when the process doesn't have sufficient capabilities to
> block suspend.

Which is a different thing.

> I'd appreciate any thoughts or feedback!
>
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
>  fs/eventpoll.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 473e09d..7a83079 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1820,7 +1820,8 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
>  		goto error_tgt_fput;
>  
>  	/* Check if EPOLLWAKEUP is allowed */
> -	if ((epds.events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
> +	if ((epds.events & EPOLLWAKEUP) &&
> +		(!capable(CAP_BLOCK_SUSPEND) || !IS_ENABLED(CONFIG_PM_SLEEP)))

I don't particularly like mixing the checking of CONFIG_ symbols with code like
this.

I'd create a static inline function taking a pointer to epds.events that would
do the

	if ((epds.events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
 		epds.events &= ~EPOLLWAKEUP;

for CONFIG_PM_SLEEP set and

  		epds.events &= ~EPOLLWAKEUP;

unconditionally for CONFIG_PM_SLEEP unset.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
