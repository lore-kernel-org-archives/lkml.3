Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbbASJrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:47:13 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:34629 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbbASJrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:47:10 -0500
Date: Mon, 19 Jan 2015 09:47:04 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger Tseng <rogerable@realtek.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        wei_wang@realsil.com.cn, micky_ching@realsil.com.cn
Subject: Re: [PATCH 2/2] mfd: rtsx_usb: Defer autosuspend while card exists
Message-ID: <20150119094704.GL21886@x1>
References: <1421306085-32254-1-git-send-email-rogerable@realtek.com>
 <1421306085-32254-3-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421306085-32254-3-git-send-email-rogerable@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015, Roger Tseng wrote:

> A card insertion happens after the lastest polling before reader is
> suspended may never have a chance to be detected. Under current 1-HZ
> polling interval setting in mmc_core, the worst case of such
> undetectablility is about 1 second.
> 
> To further reduce the undetectability, detect card slot again in suspend
> method and defer the autosuspend if the slot is loaded. The default 2
> second autosuspend delay of USB subsystem should let the next polling
> detects the card.
> 
> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> ---
>  drivers/mfd/rtsx_usb.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

Applied, thanks.

> diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
> index 076694126e5d..63883fd025c0 100644
> --- a/drivers/mfd/rtsx_usb.c
> +++ b/drivers/mfd/rtsx_usb.c
> @@ -687,6 +687,20 @@ static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
>  	dev_dbg(&intf->dev, "%s called with pm message 0x%04x\n",
>  			__func__, message.event);
>  
> +	if (PMSG_IS_AUTO(message)) {
> +		if (mutex_trylock(&ucr->dev_mutex)) {
> +			rtsx_usb_get_card_status(ucr, &val);
> +			mutex_unlock(&ucr->dev_mutex);
> +
> +			/* Defer the autosuspend if card exists */
> +			if (val & (SD_CD | MS_CD))
> +				return -EAGAIN;
> +		} else {
> +			/* There is an ongoing operation*/
> +			return -EAGAIN;
> +		}
> +	}
> +
>  	return 0;
>  }
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
