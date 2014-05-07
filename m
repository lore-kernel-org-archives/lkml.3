Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbaEGOUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:20:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52471 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaEGOUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:20:45 -0400
Message-ID: <536A4138.80603@ti.com>
Date: Wed, 7 May 2014 19:50:40 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <zonque@gmail.com>
Subject: Re: [PATCH 5/5] usb: musb: dsps: Enable sw babble control for newer
 silicon
References: <1399471751-28520-1-git-send-email-george.cherian@ti.com> <1399471751-28520-6-git-send-email-george.cherian@ti.com>
In-Reply-To: <1399471751-28520-6-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please ignore this patch.
It actually doesnot call sw_babble_ control() at all.
It should have.
Will post a fixed version.

On 5/7/2014 7:39 PM, George Cherian wrote:
> Find whether we are running on newer silicon. The babble control
> register reads 0x4 by default in newer silicon as opposed to 0
> in old versions of AM335x. Based on this enable the sw babble
> control logic.
>
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   drivers/usb/musb/musb_dsps.c | 28 +++++++++++++++++++++++++++-
>   1 file changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
> index 6647e7e..da719d7 100644
> --- a/drivers/usb/musb/musb_dsps.c
> +++ b/drivers/usb/musb/musb_dsps.c
> @@ -136,6 +136,7 @@ struct dsps_glue {
>   	const struct dsps_musb_wrapper *wrp; /* wrapper register offsets */
>   	struct timer_list timer;	/* otg_workaround timer */
>   	unsigned long last_timer;    /* last timer data for each instance */
> +	bool sw_babble_enabled;
>   
>   	struct dsps_context context;
>   	struct debugfs_regset32 regset;
> @@ -469,6 +470,16 @@ static int dsps_musb_init(struct musb *musb)
>   	val &= ~(1 << wrp->otg_disable);
>   	dsps_writel(musb->ctrl_base, wrp->phy_utmi, val);
>   
> +	/*
> +	 *  Check whether the dsps version has babble control enabled.
> +	 * In latest silicon revision the babble control logic is enabled.
> +	 * If MUSB_BABBLE_CTL returns 0x4 then we have the babble control
> +	 * logic enabled.
> +	 */
> +	val = dsps_readb(musb->mregs, MUSB_BABBLE_CTL);
> +	if (val == MUSB_BABBLE_RCV_DISABLE)
> +		glue->sw_babble_enabled = true;
> +
>   	ret = dsps_musb_dbg_init(musb, glue);
>   	if (ret)
>   		return ret;
> @@ -591,6 +602,7 @@ static int dsps_musb_reset(struct musb *musb)
>   	struct device *dev = musb->controller;
>   	struct dsps_glue *glue = dev_get_drvdata(dev->parent);
>   	const struct dsps_musb_wrapper *wrp = glue->wrp;
> +	int session_restart = 0;
>   
>   	dsps_writel(musb->ctrl_base, wrp->control, (1 << wrp->reset));
>   	usleep_range(100, 200);
> @@ -598,7 +610,21 @@ static int dsps_musb_reset(struct musb *musb)
>   	usleep_range(100, 200);
>   	usb_phy_init(musb->xceiv);
>   
> -	return 1;
> +	/*
> +	 * In case of new silicon version babble condition can be recovered
> +	 * without resetting the MUSB. But for older silicon versions, MUSB
> +	 * reset is needed
> +	 */
> +	if (session_restart || !glue->sw_babble_enabled) {
> +		dsps_writel(musb->ctrl_base, wrp->control, (1 << wrp->reset));
> +		usleep_range(100, 200);
> +		usb_phy_shutdown(musb->xceiv);
> +		usleep_range(100, 200);
> +		usb_phy_init(musb->xceiv);
> +		session_restart = 1;
> +	}
> +
> +	return session_restart;
>   }
>   
>   static struct musb_platform_ops dsps_ops = {


-- 
-George

