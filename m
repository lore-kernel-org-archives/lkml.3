Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaKKRxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:53:46 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:45319 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaKKRxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:53:45 -0500
MIME-Version: 1.0
In-Reply-To: <1415721852-10193-1-git-send-email-sudeep.holla@arm.com>
References: <1415721852-10193-1-git-send-email-sudeep.holla@arm.com>
Date: Tue, 11 Nov 2014 23:23:44 +0530
Message-ID: <CAJe_ZhdFa7tDHMoWwaV2+h+qVbWvKgNUGN6cJDQkvPYeg6N69w@mail.gmail.com>
Subject: Re: [PATCH] mailbox: add tx_prepare client callback
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 November 2014 21:34, Sudeep Holla <sudeep.holla@arm.com> wrote:
> If the mailbox controller expects the payload is in place before
> initiating the transmit, then it's impossible to reuse the list
> maintained by core mailbox code currently. Maintaining another list
> for sending the message in the controller seems totally unnecessary
> as core mailbox library already provides that feature.
>
> This patch introduces tx_prepare callback in mbox_client which
> can be used by the core mailbox library before initiating the
> transaction through mbox->ops->send_data. The client driver can
> implement this callback to ensure the payload is copied to the
> shared memory.
>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Jassi Brar <jaswinder.singh@linaro.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/mailbox/mailbox.c      | 2 ++
>  include/linux/mailbox_client.h | 1 +
>  2 files changed, 3 insertions(+)
>
> diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
> index afcb430508ec..4b4044f47b45 100644
> --- a/drivers/mailbox/mailbox.c
> +++ b/drivers/mailbox/mailbox.c
> @@ -76,6 +76,8 @@ static void msg_submit(struct mbox_chan *chan)
>
>         data = chan->msg_data[idx];
>
> +       if (chan->cl->tx_prepare)
> +               chan->cl->tx_prepare(chan->cl, data);
>         /* Try to submit a message to the MBOX controller */
>         err = chan->mbox->ops->send_data(chan, data);
>         if (!err) {
> diff --git a/include/linux/mailbox_client.h b/include/linux/mailbox_client.h
> index 307d9cab2026..5a1a6db63e96 100644
> --- a/include/linux/mailbox_client.h
> +++ b/include/linux/mailbox_client.h
> @@ -34,6 +34,7 @@ struct mbox_client {
>         bool knows_txdone;
>
>         void (*rx_callback)(struct mbox_client *cl, void *mssg);
> +       void (*tx_prepare)(struct mbox_client *cl, void *mssg);
>         void (*tx_done)(struct mbox_client *cl, void *mssg, int r);
>  };
>
Please add some documentation for tx_prepare() as well.

Thanks
Jassi
