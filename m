Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbbARTAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 14:00:15 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:43335 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbbARTAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 14:00:13 -0500
Date: Sun, 18 Jan 2015 11:00:12 -0800
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] toshiba_acpi: Add support for USB Rapid Charge
Message-ID: <20150118190012.GG56582@vmdeb7>
References: <1421271621-8330-1-git-send-email-coproscefalo@gmail.com>
 <1421271621-8330-4-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421271621-8330-4-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 02:40:20PM -0700, Azael Avalos wrote:
> Newer Toshiba laptops equipped with USB 3.0 ports now have the
> functionality of rapid charging devices connected to their USB hubs.
> 
> This patch adds support to use such feature by creating a sysfs entry
> named "usb_rapid_charge", accepting only two values, 0 to disable and
> one to enable, however, the machine needs a restart everytime the

s/one/1//

> function is toggled.
> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> ---
>  drivers/platform/x86/toshiba_acpi.c | 107 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 107 insertions(+)
> 
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index 9e054c5..eba5f9e 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -155,6 +155,7 @@ MODULE_LICENSE("GPL");
>  #define SCI_USB_CHARGE_BAT_LVL_OFF	0x1
>  #define SCI_USB_CHARGE_BAT_LVL_ON	0x4
>  #define SCI_USB_CHARGE_BAT_LVL		0x0200
> +#define SCI_USB_CHARGE_RAPID_DSP	0x0300
>  
>  struct toshiba_acpi_dev {
>  	struct acpi_device *acpi_dev;
> @@ -188,6 +189,7 @@ struct toshiba_acpi_dev {
>  	unsigned int eco_supported:1;
>  	unsigned int accelerometer_supported:1;
>  	unsigned int usb_sleep_charge_supported:1;
> +	unsigned int usb_rapid_charge_supported:1;
>  	unsigned int sysfs_created:1;
>  
>  	struct mutex mutex;
> @@ -874,6 +876,60 @@ static int toshiba_sleep_functions_status_set(struct toshiba_acpi_dev *dev,
>  	return 0;
>  }
>  
> +static int toshiba_usb_rapid_charge_get(struct toshiba_acpi_dev *dev,
> +					u32 *state)
> +{
> +	u32 in[TCI_WORDS] = { SCI_GET, SCI_USB_SLEEP_CHARGE, 0, 0, 0, 0 };
> +	u32 out[TCI_WORDS];
> +	acpi_status status;
> +
> +	if (!sci_open(dev))
> +		return -EIO;
> +
> +	in[5] = SCI_USB_CHARGE_RAPID_DSP;
> +	status = tci_raw(dev, in, out);
> +	sci_close(dev);
> +	if (ACPI_FAILURE(status) || out[0] == TOS_FAILURE) {
> +		pr_err("ACPI call to get USB S&C battery level failed\n");
> +		return -EIO;
> +	} else if (out[0] == TOS_NOT_SUPPORTED ||
> +		   out[0] == TOS_INPUT_DATA_ERROR) {
> +		pr_info("USB Sleep and Charge not supported\n");
> +		return -ENODEV;
> +	}
> +

Same comment on return codes.

Although, on looking through the existing driver, I only see EIO, and internally
consistency is important.... we can stick with EIO for this driver.
-- 
Darren Hart
Intel Open Source Technology Center
