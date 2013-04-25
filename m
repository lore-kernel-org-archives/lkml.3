Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab3DYHNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 03:13:31 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:16011 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab3DYHNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 03:13:30 -0400
Message-ID: <5178D765.9080506@hp.com>
Date: Thu, 25 Apr 2013 15:12:37 +0800
From: ZhenHua <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130117 Thunderbird/19.0
MIME-Version: 1.0
To: stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
CC: "Li, Zhen-Hua" <zhen-hual@hp.com>, tom.vaden@hp.com
Subject: Re: [PATCH 1/1] driver,usb: Fix a warning in uhci-hcd driver
References: <1366873869-17446-1-git-send-email-zhen-hual@hp.com>
In-Reply-To: <1366873869-17446-1-git-send-email-zhen-hual@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I send out this patch for the second time.
Changed try to int. And modified the comment.

On 04/25/2013 03:11 PM, Li, Zhen-Hua wrote:
> This patch is trying to fix this bug on SLES11 SP2:
>      https://bugzilla.novell.com/show_bug.cgi?id=817035
>
> On a large HP system with 64T memory and 60 logical cpus, when usb
> driver inits the iLo Virtual USB Controller, there comes a warning
> "Controller not stopped yet!". It is because driver does not wait
> enough time. So driver should wait and retry if found controller
>   not stopped.
>
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> Signed-off-by: Tom Vaden <tom.vaden@hp.com>
> ---
>   drivers/usb/host/uhci-hcd.c |   17 ++++++++++++++++-
>   1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
> index 4a86b63..d592e22 100644
> --- a/drivers/usb/host/uhci-hcd.c
> +++ b/drivers/usb/host/uhci-hcd.c
> @@ -277,6 +277,9 @@ static int global_suspend_mode_is_broken(struct uhci_hcd *uhci)
>   		uhci->global_suspend_mode_is_broken(uhci) : 0;
>   }
>   
> +#define UHCI_SUSPENDRH_RETRY_MAX      10
> +#define UHCI_SUSPENDRH_RETRY_DELAY    100
> +
>   static void suspend_rh(struct uhci_hcd *uhci, enum uhci_rh_state new_state)
>   __releases(uhci->lock)
>   __acquires(uhci->lock)
> @@ -284,6 +287,8 @@ __acquires(uhci->lock)
>   	int auto_stop;
>   	int int_enable, egsm_enable, wakeup_enable;
>   	struct usb_device *rhdev = uhci_to_hcd(uhci)->self.root_hub;
> +	int try;
> +	u16 stopped;
>   
>   	auto_stop = (new_state == UHCI_RH_AUTO_STOPPED);
>   	dev_dbg(&rhdev->dev, "%s%s\n", __func__,
> @@ -355,7 +360,17 @@ __acquires(uhci->lock)
>   		if (uhci->dead)
>   			return;
>   	}
> -	if (!(uhci_readw(uhci, USBSTS) & USBSTS_HCH))
> +
> +	for (try = 0; try < UHCI_SUSPENDRH_RETRY_MAX; try++) {
> +		/* For some devices, for example, HP iLo usb controller,
> +		 * we need to wait for more time and retry.
> +		 */
> +		stopped = uhci_readw(uhci, USBSTS) & USBSTS_HCH;
> +		if (stopped)
> +			break;
> +		udelay(UHCI_SUSPENDRH_RETRY_DELAY);
> +	}
> +	if (!stopped)
>   		dev_warn(uhci_dev(uhci), "Controller not stopped yet!\n");
>   
>   	uhci_get_current_frame_number(uhci);

