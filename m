Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967211AbaFTUkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:40:45 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48715 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730AbaFTUkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:40:41 -0400
Message-ID: <c878c725f6789ec6625914e4a5a1b674.squirrel@www.codeaurora.org>
In-Reply-To: <4277a609d7431f34663d19a006a5ada6.squirrel@www.codeaurora.org>
References: <4277a609d7431f34663d19a006a5ada6.squirrel@www.codeaurora.org>
Date: Fri, 20 Jun 2014 20:40:39 -0000
Subject: Re: [PATCH] spi: spidev: Fix user-space memory access.
From: dsneddon@codeaurora.org
To: linux-spi@vger.kernel.org
Cc: broonie@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just noticed this patch breaks when CONFIG_COMPAT isn't defined.  Please
ignore this patch for now.

> When the spidev module tries to access the user space memory passed in via
> an IOCTL the compat_ptr function should be called to ensure
> compatibility between kernel space and user space.
>
> Signed-off-by: Dan Sneddon <dsneddon@codeaurora.org>
> ---
>  drivers/spi/spidev.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
> index e3bc23b..3a45158 100644
> --- a/drivers/spi/spidev.c
> +++ b/drivers/spi/spidev.c
> @@ -252,14 +252,16 @@ static int spidev_message(struct spidev_data
> *spidev,
>                 if (u_tmp->rx_buf) {
>                         k_tmp->rx_buf = buf;
>                         if (!access_ok(VERIFY_WRITE, (u8 __user *)
> -                                               (uintptr_t) u_tmp->rx_buf,
> +                                               (uintptr_t)compat_ptr( +
>                                                     u_tmp->rx_buf),
>                                                 u_tmp->len))
>                                 goto done;
>                 }
>                 if (u_tmp->tx_buf) {
>                         k_tmp->tx_buf = buf;
>                         if (copy_from_user(buf, (const u8 __user *)
> -                                               (uintptr_t) u_tmp->tx_buf,
> +                                               (uintptr_t)compat_ptr( +
>                                                     u_tmp->tx_buf),
>                                         u_tmp->len))
>                                 goto done;
>                 }
> @@ -294,8 +296,8 @@ static int spidev_message(struct spidev_data *spidev,
>         for (n = n_xfers, u_tmp = u_xfers; n; n--, u_tmp++) {
>                 if (u_tmp->rx_buf) {
>                         if (__copy_to_user((u8 __user *)
> -                                       (uintptr_t) u_tmp->rx_buf, buf, -
>                                      u_tmp->len)) {
> +
> (uintptr_t)compat_ptr(u_tmp->rx_buf),
> +                                       buf, u_tmp->len)) {
>                                 status = -EFAULT;
>                                 goto done;
>                         }
> --
> 1.8.4
>
>
>
>
>
>
> ---
> sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
---
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

