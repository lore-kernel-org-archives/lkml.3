Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbbARSqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 13:46:51 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:42798 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbbARSqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 13:46:50 -0500
Date: Sun, 18 Jan 2015 10:46:48 -0800
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] toshiba_acpi: Add support for USB Sleep and Charge
 function
Message-ID: <20150118184648.GD56582@vmdeb7>
References: <1421271621-8330-1-git-send-email-coproscefalo@gmail.com>
 <1421271621-8330-2-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421271621-8330-2-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 02:40:18PM -0700, Azael Avalos wrote:
> Newer Toshiba models now come with a feature called Sleep and Charge,
> where the computer USB ports remain powered when the computer is
> asleep or turned off.
> 
> This patch adds support to such feature, creating a sysfs entry
> called "usb_sleep_charge" to set the desired charging mode or to
> disable it.
> 
> The sysfs entry accepts three parameters, 0x0, 0x9 and 0x21, beign
> disabled, alternate and auto respectively.
> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> ---
>  drivers/platform/x86/toshiba_acpi.c | 112 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 112 insertions(+)
> 
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index 71ac7c12..b03129d 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -122,6 +122,7 @@ MODULE_LICENSE("GPL");
>  #define HCI_ECO_MODE			0x0097
>  #define HCI_ACCELEROMETER2		0x00a6
>  #define SCI_ILLUMINATION		0x014e
> +#define SCI_USB_SLEEP_CHARGE		0x0150
>  #define SCI_KBD_ILLUM_STATUS		0x015c
>  #define SCI_TOUCHPAD			0x050e
>  
> @@ -146,6 +147,10 @@ MODULE_LICENSE("GPL");
>  #define SCI_KBD_MODE_ON			0x8
>  #define SCI_KBD_MODE_OFF		0x10
>  #define SCI_KBD_TIME_MAX		0x3c001a
> +#define SCI_USB_CHARGE_MODE_MASK	0xff
> +#define SCI_USB_CHARGE_DISABLED		0x30000
> +#define SCI_USB_CHARGE_ALTERNATE	0x30009
> +#define SCI_USB_CHARGE_AUTO		0x30021
>  
>  struct toshiba_acpi_dev {
>  	struct acpi_device *acpi_dev;
> @@ -177,6 +182,7 @@ struct toshiba_acpi_dev {
>  	unsigned int touchpad_supported:1;
>  	unsigned int eco_supported:1;
>  	unsigned int accelerometer_supported:1;
> +	unsigned int usb_sleep_charge_supported:1;
>  	unsigned int sysfs_created:1;
>  
>  	struct mutex mutex;
> @@ -761,6 +767,53 @@ static int toshiba_accelerometer_get(struct toshiba_acpi_dev *dev,
>  	return 0;
>  }
>  
> +/* Sleep (Charge and Music) utilities support */
> +static int toshiba_usb_sleep_charge_get(struct toshiba_acpi_dev *dev,
> +					u32 *mode)
> +{
> +	u32 result;
> +
> +	if (!sci_open(dev))
> +		return -EIO;
> +
> +	result = sci_read(dev, SCI_USB_SLEEP_CHARGE, mode);
> +	sci_close(dev);
> +	if (result == TOS_FAILURE) {
> +		pr_err("ACPI call to set USB S&C mode failed\n");
> +		return -EIO;
> +	} else if (result == TOS_NOT_SUPPORTED) {
> +		pr_info("USB Sleep and Charge not supported\n");
> +		return -ENODEV;
> +	} else if (result == TOS_INPUT_DATA_ERROR) {
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int toshiba_usb_sleep_charge_set(struct toshiba_acpi_dev *dev,
> +					u32 mode)
> +{
> +	u32 result;
> +
> +	if (!sci_open(dev))
> +		return -EIO;
> +
> +	result = sci_write(dev, SCI_USB_SLEEP_CHARGE, mode);
> +	sci_close(dev);
> +	if (result == TOS_FAILURE) {
> +		pr_err("ACPI call to set USB S&C mode failed\n");
> +		return -EIO;
> +	} else if (result == TOS_NOT_SUPPORTED) {
> +		pr_info("USB Sleep and Charge not supported\n");
> +		return -ENODEV;
> +	} else if (result == TOS_INPUT_DATA_ERROR) {
> +		return -EIO;

Personally I would feel more comfortable relying on our own data input
validation than that of the AML.

We can also present the user with an abstracted interface, we don't need to have
them send in register values that match the underlying hardware. In fact, should
the firmware in future machines change, you will be faced with having to remap
values should they mean different things. I would suggest defining a user
visible namespace for these, consider:

0: Disabled
1: Auto
2: Alternate (what does this mean anyway?)

Also, per Documentation/sysfs-rules.txt, which I believe I added based on
previous review with you?, -EIO is typically returned by sysfs itself from some
sort of general failure, like a NULL read or store pointer.

When the read or store operation fails as above, -ENXIO is the preferred error
code.

-- 
Darren Hart
Intel Open Source Technology Center
