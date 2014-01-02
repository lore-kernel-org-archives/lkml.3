Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaABQEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 11:04:25 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:53149 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaABQEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 11:04:20 -0500
MIME-Version: 1.0
In-Reply-To: <1388664474-1710039-29-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
	<1388664474-1710039-29-git-send-email-arnd@arndb.de>
Date: Thu, 2 Jan 2014 10:04:17 -0600
Message-ID: <CAPp3RGrQCr0bbe-q2GCgUMFj1_DLGSZRKQkRhRdOOS37TzgwfA@mail.gmail.com>
Subject: Re: [PATCH, RFC 28/30] sgi-xp: open-code interruptible_sleep_on_timeout
From: Robin Holt <robinmholt@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Cliff Whickman <cpw@sgi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Robin Holt <robinmholt@gmail.com>

On Thu, Jan 2, 2014 at 6:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> interruptible_sleep_on_timeout is deprecated and going away soon.
> The use in the sgi-xp driver leaves me puzzled, so I'd prefer not
> to touch it. This patch replaces it with an open-coded prepare_to_wait
> and finish_wait pair, which should be completely equivalent, so it
> doesn't fix an existing race, but lets us get away with removing
> the function so we can not get any new users.
>
> In order to remove the typical sleep_on race, one would have to
> replace the call with wait_event_interruptible_timeout and add
> a condition to wait for. The fact that there is a one-jiffy timeout
> suggests that we don't actually expect to get woken up properly
> and the caller just uses this as a short sleeping function
> if it doesn't wake up properly.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Cliff Whickman <cpw@sgi.com>
> Cc: Robin Holt <robinmholt@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/misc/sgi-xp/xpc_channel.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/misc/sgi-xp/xpc_channel.c b/drivers/misc/sgi-xp/xpc_channel.c
> index 652593f..128d561 100644
> --- a/drivers/misc/sgi-xp/xpc_channel.c
> +++ b/drivers/misc/sgi-xp/xpc_channel.c
> @@ -828,6 +828,7 @@ enum xp_retval
>  xpc_allocate_msg_wait(struct xpc_channel *ch)
>  {
>         enum xp_retval ret;
> +       DEFINE_WAIT(wait);
>
>         if (ch->flags & XPC_C_DISCONNECTING) {
>                 DBUG_ON(ch->reason == xpInterrupted);
> @@ -835,7 +836,9 @@ xpc_allocate_msg_wait(struct xpc_channel *ch)
>         }
>
>         atomic_inc(&ch->n_on_msg_allocate_wq);
> -       ret = interruptible_sleep_on_timeout(&ch->msg_allocate_wq, 1);
> +       prepare_to_wait(&ch->msg_allocate_wq, &wait, TASK_INTERRUPTIBLE);
> +       ret = schedule_timeout(1);
> +       finish_wait(&ch->msg_allocate_wq, &wait);
>         atomic_dec(&ch->n_on_msg_allocate_wq);
>
>         if (ch->flags & XPC_C_DISCONNECTING) {
> --
> 1.8.3.2
>
