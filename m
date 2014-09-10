Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190AbaIJELu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:11:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51914 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaIJELt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:11:49 -0400
Date: Tue, 9 Sep 2014 21:11:45 -0700
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] toshiba_acpi: Support new keyboard backlight type
Message-ID: <20140910041145.GD39541@vmdeb7>
References: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
 <1409937247-2525-5-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409937247-2525-5-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 11:14:06AM -0600, Azael Avalos wrote:

Hi Azael,

Apologies for the delay. I'm still recovering from a couple weeks of travel and
a nasty conference bug. Thanks for being patient.

> Newer Toshiba models now come with a new (and different) keyboard
> backlight implementation whith three modes of operation: TIMER,
> ON and OFF, and the LED is controlled internally by the firmware.
> 
> This patch adds support for that type of backlight, changing the
> existing code to accomodate the new implementation.
> 
> The timeout value range is now 1-60 seconds, and the accepted
> modes are now: 0 (OFF), 1 (ON or FN-Z) and 2 (AUTO or TIMER), and
> the keyboard_backlight_mode entry now displays two values, the
> keyboard backlight type (either 1 or 2) and the current mode.


Wouldn't adding a new entry make more sense than multiplexing an existing one? I
was fairly sure that was contrary to the goals of sys...


> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>


On testing, were you able to verify on new as well as previous models that this
continues to work?


> ---
>  drivers/platform/x86/toshiba_acpi.c | 145 ++++++++++++++++++++++++------------
>  1 file changed, 98 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index ac1503c..1738171 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -142,6 +142,8 @@ MODULE_LICENSE("GPL");
>  #define HCI_WIRELESS_BT_POWER		0x80
>  #define SCI_KBD_MODE_FNZ		0x1
>  #define SCI_KBD_MODE_AUTO		0x2
> +#define SCI_KBD_MODE_ON			0x8
> +#define SCI_KBD_MODE_OFF		0x10
>  
>  struct toshiba_acpi_dev {
>  	struct acpi_device *acpi_dev;
> @@ -158,6 +160,7 @@ struct toshiba_acpi_dev {
>  	int force_fan;
>  	int last_key_event;
>  	int key_event_valid;
> +	int kbd_type;

Consider some defines or enum values for the types?

>  	int kbd_mode;
>  	int kbd_time;
>  
> @@ -499,28 +502,36 @@ static enum led_brightness toshiba_illumination_get(struct led_classdev *cdev)
>  }
>  
>  /* KBD Illumination */
> -static int toshiba_kbd_illum_status_set(struct toshiba_acpi_dev *dev, u32 time)
> +static int toshiba_kbd_illum_available(struct toshiba_acpi_dev *dev)
>  {
> -	u32 result;
> +	u32 in[HCI_WORDS] = { SCI_GET, SCI_KBD_ILLUM_STATUS, 0, 0, 0, 0 };
> +	u32 out[HCI_WORDS];
>  	acpi_status status;
>  
>  	if (!sci_open(dev))
> -		return -EIO;
> +		return 0;
>  
> -	status = sci_write(dev, SCI_KBD_ILLUM_STATUS, time, &result);
> +	status = hci_raw(dev, in, out);
>  	sci_close(dev);
> -	if (ACPI_FAILURE(status) || result == SCI_INPUT_DATA_ERROR) {
> -		pr_err("ACPI call to set KBD backlight status failed\n");
> -		return -EIO;
> -	} else if (result == HCI_NOT_SUPPORTED) {
> -		pr_info("Keyboard backlight status not supported\n");
> -		return -ENODEV;
> +	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
> +		pr_err("ACPI call to query kbd illumination support failed\n");
> +		return 0;
> +	} else if (out[0] == HCI_NOT_SUPPORTED) {
> +		pr_info("Keyboard illumination not available\n");
> +		return 0;
>  	}
>  
> -	return 0;
> +	if (out[3] == 0x3c001a)

Do have any information on what this value means? It would be preferable to use
sensible defines here rather than magic hex codes if at all possible.

> +		dev->kbd_type = 2;
> +	else
> +		dev->kbd_type = 1;

A couple enum types would be useful here.

> +	dev->kbd_mode = out[2] & 0x1f;

define TOSHIBA_KBD_MODE_MASK maybe?

> +	dev->kbd_time = out[2] >> HCI_MISC_SHIFT;
> +
> +	return 1;
>  }
>  
> -static int toshiba_kbd_illum_status_get(struct toshiba_acpi_dev *dev, u32 *time)
> +static int toshiba_kbd_illum_status_set(struct toshiba_acpi_dev *dev, u32 time)
>  {
>  	u32 result;
>  	acpi_status status;
> @@ -528,10 +539,10 @@ static int toshiba_kbd_illum_status_get(struct toshiba_acpi_dev *dev, u32 *time)
>  	if (!sci_open(dev))
>  		return -EIO;
>  
> -	status = sci_read(dev, SCI_KBD_ILLUM_STATUS, time, &result);
> +	status = sci_write(dev, SCI_KBD_ILLUM_STATUS, time, &result);
>  	sci_close(dev);
>  	if (ACPI_FAILURE(status) || result == SCI_INPUT_DATA_ERROR) {
> -		pr_err("ACPI call to get KBD backlight status failed\n");
> +		pr_err("ACPI call to set KBD backlight status failed\n");
>  		return -EIO;
>  	} else if (result == HCI_NOT_SUPPORTED) {
>  		pr_info("Keyboard backlight status not supported\n");
> @@ -1264,22 +1275,54 @@ static ssize_t toshiba_kbd_bl_mode_store(struct device *dev,
>  					 const char *buf, size_t count)
>  {
>  	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
> -	int mode = -1;
> -	int time = -1;
> +	int mode;
> +	int time;
> +	int ret;
>  
> -	if (sscanf(buf, "%i", &mode) != 1 && (mode != 2 || mode != 1))
> +	ret = kstrtoint(buf, 0, &mode);
> +	if (ret)
> +		return ret;
> +	if (mode > 2 || mode < 0)
>  		return -EINVAL;


This hunk appears to be unrelated cleanup.


>  	/* Set the Keyboard Backlight Mode where:
> -	 * Mode - Auto (2) | FN-Z (1)
> +	 * Mode - Auto (2) | FN-Z or ON (1) | OFF (0)
>  	 *	Auto - KBD backlight turns off automatically in given time
>  	 *	FN-Z - KBD backlight "toggles" when hotkey pressed
> +	 *	ON   - KBD backlight is always on
> +	 *	OFF  - KBD backlight is always off
> +	 */
> +
> +	/* Convert userspace values to internal ones,
> +	 * depending on the keyboard backlight type detected
>  	 */
> -	if (mode != -1 && toshiba->kbd_mode != mode) {
> +	if (mode == 0)
> +		mode = SCI_KBD_MODE_OFF;
> +	else if (mode == 1 && toshiba->kbd_type == 1)
> +		mode = SCI_KBD_MODE_FNZ;
> +	else if (mode == 1 && toshiba->kbd_type == 2)


The type enums would add some more confidense to this test, as my first thought
was what if kbd_type isn't 1 or 2... which of course it should never be.


> +		mode = SCI_KBD_MODE_ON;
> +	else if (mode == 2)
> +		mode = SCI_KBD_MODE_AUTO;
> +

There are a number of if blocks around mode and type now. I wonder if a simple
array might make this more condensed, but of course you'd have to do bounds
checking (especially with user data as the index) which might nullify the gains.
Something to consider, I'm not insisting on it.

> +	/* Only make a change if the actual mode has changed */
> +	if (toshiba->kbd_mode != mode) {
> +		/* KBD backlight type 1 doesn't support SCI_KBD_MODE_OFF,
> +		 * bailout silently if set to it
> +		 */
> +		if (toshiba->kbd_type == 1 && mode == SCI_KBD_MODE_OFF)
> +			return count;

Why a silent return? Would -EINVAL not be more appropriate?

> +
>  		time = toshiba->kbd_time << HCI_MISC_SHIFT;
> -		time = time + toshiba->kbd_mode;
> -		if (toshiba_kbd_illum_status_set(toshiba, time) < 0)
> -			return -EIO;
> +		if (toshiba->kbd_type == 1)
> +			time |= toshiba->kbd_mode;
> +		else if (toshiba->kbd_type == 2)
> +			time |= mode;
> +

What? :)

I'm not following the concept of OR'ing the mode in, and am also confused by why
we use user data for type 2 and internal values for type 1...

Can you explain? And if an explanation is needed, perhaps this can be cleaned up
to be a bit more readable?

> +		ret = toshiba_kbd_illum_status_set(toshiba, time);
> +		if (ret)
> +			return ret;
> +
>  		toshiba->kbd_mode = mode;
>  	}
>  
> @@ -1291,12 +1334,17 @@ static ssize_t toshiba_kbd_bl_mode_show(struct device *dev,
>  					char *buf)
>  {
>  	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
> -	u32 time;
> +	int mode;
>  
> -	if (toshiba_kbd_illum_status_get(toshiba, &time) < 0)
> -		return -EIO;
> +	if (toshiba->kbd_mode == SCI_KBD_MODE_OFF)
> +		mode = 0;
> +	else if (toshiba->kbd_mode == SCI_KBD_MODE_FNZ ||
> +		 toshiba->kbd_mode == SCI_KBD_MODE_ON)
> +		mode = 1;
> +	else if (toshiba->kbd_mode == SCI_KBD_MODE_AUTO)
> +		mode = 2;
>  
> -	return sprintf(buf, "%i\n", time & 0x07);
> +	return sprintf(buf, "%i %i\n", toshiba->kbd_type, mode);

Why overload the mode==1 to mean two different things? Would it make more sense
to add a user mode value for the new modes and add those?

By adding the type you are already breaking any API, so I'm confused about why
you didn't just add a mode value and not add the type here.

>  }
>  
>  static ssize_t toshiba_kbd_bl_timeout_store(struct device *dev,
> @@ -1304,18 +1352,29 @@ static ssize_t toshiba_kbd_bl_timeout_store(struct device *dev,
>  					    const char *buf, size_t count)
>  {
>  	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
> -	int time = -1;
> +	int time;
> +	int ret;
>  
> -	if (sscanf(buf, "%i", &time) != 1 && (time < 0 || time > 60))
> +	ret = kstrtoint(buf, 0, &time);
> +	if (ret)
> +		return ret;
> +	if (time < 1 || time > 60)
>  		return -EINVAL;


Looks like another (mostly) cleanup block. Perhaps combine with the earlier one
into a patch to remove unecessary assignments and replacing sscanf with
kstrtoint.

Please consider the feedback above in the context of the whole patch and with
how this driver is used and prepare an updated patch.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
