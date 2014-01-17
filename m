Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaAQKwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 05:52:07 -0500
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3238 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaAQKwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 05:52:05 -0500
Message-ID: <52D90B42.90206@xs4all.nl>
Date: Fri, 17 Jan 2014 11:51:46 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH, RFC 08/30] [media] arv: fix sleep_on race
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <1388664474-1710039-9-git-send-email-arnd@arndb.de>
In-Reply-To: <1388664474-1710039-9-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 01:07 PM, Arnd Bergmann wrote:
> interruptible_sleep_on is racy and going away. In the arv driver that
> race has probably never caused problems since it would require a whole
> video frame to be captured before the read function has a chance to
> go to sleep, but using wait_event_interruptible lets us kill off the
> old interface. In order to do this, we have to slightly adapt the
> meaning of the ar->start_capture field to distinguish between not having
> started a frame and having completed it.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/platform/arv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/arv.c b/drivers/media/platform/arv.c
> index e346d32d..32f6d70 100644
> --- a/drivers/media/platform/arv.c
> +++ b/drivers/media/platform/arv.c
> @@ -307,11 +307,11 @@ static ssize_t ar_read(struct file *file, char *buf, size_t count, loff_t *ppos)
>  	/*
>  	 * Okay, kick AR LSI to invoke an interrupt
>  	 */
> -	ar->start_capture = 0;
> +	ar->start_capture = -1;

start_capture is defined as an unsigned. Can you make a new patch that changes
the type of start_capture to int?

Otherwise it looks fine.

Regards,

	Hans

>  	ar_outl(arvcr1 | ARVCR1_HIEN, ARVCR1);
>  	local_irq_restore(flags);
>  	/* .... AR interrupts .... */
> -	interruptible_sleep_on(&ar->wait);
> +	wait_event_interruptible(ar->wait, ar->start_capture == 0);
>  	if (signal_pending(current)) {
>  		printk(KERN_ERR "arv: interrupted while get frame data.\n");
>  		ret = -EINTR;
> 


