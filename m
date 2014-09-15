Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbaIOT3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:29:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45093 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbaIOT3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:29:35 -0400
Date: Mon, 15 Sep 2014 12:29:27 -0700
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 3/5] toshiba_acpi: Fix accelerometer direction
 reporting
Message-ID: <20140915192923.GA61529@vmdeb7>
References: <1410569437-3066-1-git-send-email-coproscefalo@gmail.com>
 <1410569437-3066-2-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410569437-3066-2-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 06:50:37PM -0600, Azael Avalos wrote:
> The position file on sysfs was reporting absolute values
> for its axes.
> 
> This patch fixes the direction reporting (either negative
> or positive), as well as added a mutex lock to it.
> 

Hi All,

I've added Greg KH, Rafael, and H. Peter Anvin to get some clarity on a topic
which is coming up repeatedly in the platform-drivers-x86 subsystem.
Specifically, whether or not the driver-specific sysfs attributes should be
considered a "stable userspace interface".

The sysfs documentation [1] specfifically calls out the following types of
device properties:

o devpath
o kernel name
o subsystem
o driver
o attributes (the topic of this email)

In the case of this patch, Azael proposes changing the x,y,z attributes from the
absolute values read from the device to relative signed values.

In my opinion, this changes a userspace interface that exists prior to this
development cycle. As such, the attributes must remain as they are and new
attributes should be added if a new interface is wanted/needed. New x_rel,
y_rel, z_rel attributes could be added for this purpose.

I have also suggested this device (2 actually) would be better supported as an
IIO accelerometer device, but even that would change the sysfs interface by
removing these altogether and using the IIO standardized path and accelerometer
interface.

Do we have a policy for this kind of change already in place?

1. Documentation/sysfs-rules.txt 

Thanks,

Darren


> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> ---
> This was: Add accelerometer input polled device
> 
> Changes since v1:
> Dropped polldev and kept the position entry, and simply
> fix the axes direction reporting, the IIO device will
> be added in a future patch instead of the polled device.
> 
>  drivers/platform/x86/toshiba_acpi.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index edd8f3d..a94e5ed 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -124,6 +124,7 @@ MODULE_LICENSE("GPL");
>  #define SCI_TOUCHPAD			0x050e
>  
>  /* field definitions */
> +#define HCI_ACCEL_DIRECTION_MASK	0x8000
>  #define HCI_ACCEL_MASK			0x7fff
>  #define HCI_HOTKEY_DISABLE		0x0b
>  #define HCI_HOTKEY_ENABLE		0x09
> @@ -1527,19 +1528,29 @@ static ssize_t toshiba_position_show(struct device *dev,
>  				     struct device_attribute *attr, char *buf)
>  {
>  	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
> -	u32 xyval, zval, tmp;
> -	u16 x, y, z;
> +	u32 xyval, zval;
> +	int x, y, z;
>  	int ret;
>  
> +	mutex_lock(&dev->mutex);
> +
>  	xyval = zval = 0;
>  	ret = toshiba_accelerometer_get(toshiba, &xyval, &zval);
> -	if (ret < 0)
> +	if (ret) {
> +		mutex_unlock(&dev->mutex);
>  		return ret;
> +	}
>  
> +	/* Accelerometer values */
>  	x = xyval & HCI_ACCEL_MASK;
> -	tmp = xyval >> HCI_MISC_SHIFT;
> -	y = tmp & HCI_ACCEL_MASK;
> +	y = (xyval >> HCI_MISC_SHIFT) & HCI_ACCEL_MASK;
>  	z = zval & HCI_ACCEL_MASK;
> +	/* Movement direction */
> +	x *= xyval & HCI_ACCEL_DIRECTION_MASK ? -1 : 1;
> +	y *= (xyval >> HCI_MISC_SHIFT) & HCI_ACCEL_DIRECTION_MASK ? -1 : 1;
> +	z *= zval & HCI_ACCEL_DIRECTION_MASK ? -1 : 1;
> +
> +	mutex_unlock(&dev->mutex);
>  
>  	return sprintf(buf, "%d %d %d\n", x, y, z);
>  }
> -- 
> 2.0.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Darren Hart
Intel Open Source Technology Center
