Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965992AbaLLKV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:21:57 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:47684 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856AbaLLKVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:21:55 -0500
MIME-Version: 1.0
In-Reply-To: <1418242572-20998-1-git-send-email-ashwin.chaugule@linaro.org>
References: <1418242572-20998-1-git-send-email-ashwin.chaugule@linaro.org>
Date: Fri, 12 Dec 2014 15:51:54 +0530
Message-ID: <CAJe_ZhcxQffJ16SczB9VRXoDMp7VMAR6fK8JrN=ogniv4tnfnA@mail.gmail.com>
Subject: Re: [PATCH] Mailbox: Complete wait event only if Tx was successful
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Ashwin Chaugule <ashwin.chaugule@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 December 2014 at 01:46, Ashwin Chaugule
<ashwin.chaugule@linaro.org> wrote:
> If a wait_for_completion_timeout() call returns due to a timeout,
> the mbox code can still call complete() after returning from the wait.
> This can cause subsequent transmissions on a channel to fail, since
> the wait_for_completion_timeout() sees the completion variable
> is !=0, caused by the erroneous complete() call, and immediately
> returns without waiting for the time as expected by the client.
>
> Fix this by calling complete() only if the TX was successful.
>
> Signed-off-by: Ashwin Chaugule <ashwin.chaugule@linaro.org>
> ---
>  drivers/mailbox/mailbox.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
> index 17e9e4a..4acaddb 100644
> --- a/drivers/mailbox/mailbox.c
> +++ b/drivers/mailbox/mailbox.c
> @@ -101,7 +101,7 @@ static void tx_tick(struct mbox_chan *chan, int r)
>         if (mssg && chan->cl->tx_done)
>                 chan->cl->tx_done(chan->cl, mssg, r);
>
> -       if (chan->cl->tx_block)
> +       if ((!r) && chan->cl->tx_block)
>                 complete(&chan->tx_complete);
>
Thanks for finding the bug.
However the fix is flawed. complete() could also be done from
mbox_chan_txdone() calling tx_tick(). And if the controller returned
error, we could never pass on that error code to the user (timeout
fires and then we will move on with -EIO).
Since we could never prevent the controller from returning -EIO as the
error, I think we have to explicitly tell tx_tick() if it needs to
complete() or not.

-Jassi
