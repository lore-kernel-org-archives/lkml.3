Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab3FXRNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:13:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab3FXRNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:13:15 -0400
Date: Mon, 24 Jun 2013 19:08:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] epoll_wait: fix EINTR leak
Message-ID: <20130624170856.GA475@redhat.com>
References: <1372087913-7854-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372087913-7854-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Denys Vlasenko wrote:
>
> Usage of EINTR is wrong.

I agree, this is not nice. However "fix EINTR leak" doesn't look
accurate, -EINTR is fine as an error code. Just the syscall should
restart if possible.

> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1598,7 +1598,7 @@ fetch_events:
>  			if (ep_events_available(ep) || timed_out)
>  				break;
>  			if (signal_pending(current)) {
> -				res = -EINTR;
> +				res = -ERESTARTNOHAND;

This and other similar changes do look right.

Say, sys_epoll_wait(). With this patch it can sleep, then return
ERESTARTNOHAND.

And we restart it with the same timeout again. If you want to
make it restartable, you need ERESTART_RESTARTBLOCK and
do_restart_epoll_wait() which we do not have.

See for example sys_poll() which implements this logic.

Oleg.

