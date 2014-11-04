Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaKDGWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 01:22:13 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:59934 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaKDGWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 01:22:09 -0500
Date: Mon, 3 Nov 2014 22:21:37 -0800
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>, rjw@rjwysocki.net,
        linux-acpi@vger.kernel.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nuno Lopes <nunoplopes@sapo.pt>
Subject: Re: [PATCH] toshiba_acpi: Fix regression caused by backlight extra
  check code
Message-ID: <20141104062137.GC56751@vmdeb7>
References: <1415073514-12555-1-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415073514-12555-1-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 08:58:34PM -0700, Azael Avalos wrote:
> Bug 86521 uncovered that some TOS6208 devices also return
> non zero values on a write call to the backlight method,
> thus getting caught and bailed out by the extra check code.
> 
> This patch makes sure that the extra check is being done
> on a TOS1900 device and then make the check for the broken
> backlight code.
> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> ---
>  drivers/platform/x86/toshiba_acpi.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index ef3a190..e3fed12 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -944,9 +944,13 @@ static int set_lcd_brightness(struct toshiba_acpi_dev *dev, int value)
>  	/* Extra check for "incomplete" backlight method, where the AML code
>  	 * doesn't check for HCI_SET or HCI_GET and returns TOS_SUCCESS,
>  	 * the actual brightness, and in some cases the max brightness.
> +	 * Use the SPFC method as an indicator that we're on a TOS1900 device,
> +	 * otherwise some TOS6208 devices might get bailed out, see bug 86521

This needs a clearer description here in this comment, rather than redirecting
the reader to a bug report (which may or may not exist when needed).

>  	 */
> -	if (out[2] > 0  || out[3] == 0xE000)
> -		return -ENODEV;
> +	if (acpi_has_method(dev->acpi_dev->handle, "SPFC")) {

Hrm, this checking for the existence of a specific method seems suspect to me.
We would know if we are on a TOS1900 as we matches the acpi id already. Is the
SPFC significant here, or is it just a "we only see SPFC on TOS1900 so it's a
convenient test"? If the latter, it seems rather fragile and prone to other
breakage to me.

Rafael, any recommendations here?

> +		if (out[2] > 0  || out[3] == 0xE000)
> +			return -ENODEV;
> +	}
>  
>  	return out[0] == TOS_SUCCESS ? 0 : -EIO;
>  }
> -- 
> 2.1.1
> 
> 

-- 
Darren Hart
Intel Open Source Technology Center
