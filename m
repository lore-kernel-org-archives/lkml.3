Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaJBScW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:32:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33004 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaJBScV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:32:21 -0400
Date: Thu, 2 Oct 2014 11:32:30 -0700
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] toshiba_acpi: Adapt kbd_bl_timeout_store to the new kbd
 type
Message-ID: <20141002183230.GA1108@vmdeb7>
References: <1412045824-3515-1-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412045824-3515-1-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 08:57:04PM -0600, Azael Avalos wrote:
> With the introduccion of the new keyboard backlight
> implementation, the *_timeout_store function is
> broken, as it only supports the first kbd_type.
> 
> This patch adapt such function for the new kbd_type,
> as well as convert from using sscanf to kstrtoint.
> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> ---
>  drivers/platform/x86/toshiba_acpi.c | 33 +++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index 5d509ea..13ee56b 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -1453,18 +1453,35 @@ static ssize_t toshiba_kbd_bl_timeout_store(struct device *dev,
>  					    const char *buf, size_t count)
>  {
>  	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
> -	int time = -1;
> +	int time;
> +	int ret;
> +
> +	ret = kstrtoint(buf, 0, &time);
> +	if (ret)
> +		return ret;
>  
> -	if (sscanf(buf, "%i", &time) != 1 && (time < 0 || time > 60))
> +	if (time < 1 || time > 60)
>  		return -EINVAL;

If I'm parsing this correctly, previously a time==0 was valid, and now it will
return -EINVAL. Is that intentional?

>  
> -	/* Set the Keyboard Backlight Timeout: 0-60 seconds */
> -	if (time != -1 && toshiba->kbd_time != time) {
> +	/* Set the Keyboard Backlight Timeout: 1-60 seconds */

So the time range change appears intentional. Why is that?

> +	
> +	/* Only make a change if the actual timeout has changed */
> +	if (toshiba->kbd_time != time) {
> +		/* Shift the time to "base time" (0x3c0000 == 60 seconds)*/
>  		time = time << HCI_MISC_SHIFT;
> -		time = (toshiba->kbd_mode == SCI_KBD_MODE_AUTO) ?
> -							time + 1 : time + 2;
> -		if (toshiba_kbd_illum_status_set(toshiba, time) < 0)
> -			return -EIO;
> +		/* OR the "base time" to the actual method format */
> +		if (toshiba->kbd_type == 1) {
> +			/* Type 1 requires the oposite mode */

opposite

Is it "opposite" or "current"?

> +			time |= SCI_KBD_MODE_FNZ;
> +		} else if (toshiba->kbd_type == 2) {
> +			/* Type 2 requires the actual mode */

actual... as in the mode you are changing to or the mode you are changing from?

>From the previous keyboard backlight type patch:

toshiba_acpi: Support new keyboard backlight type

There are several keyboard modes, why do we have only 2 of them here? Is it
because by setting the timeout we are always changing to _AUTO? Even if that's
the case, shouldn't one of these be OR'ing in the current mode - whatever it is,
instead of a fixed one?

> +			time |= SCI_KBD_MODE_AUTO;
> +		}
> +
> +		ret = toshiba_kbd_illum_status_set(toshiba, time);
> +		if (ret)
> +			return ret;
> +

So here you are changing the sysfs API as you can now return -ENODEV in addition
to -EIO. We *can* do this, but it is a risk, and if a regression is reported, I
will be forced to revert this patch.

-- 
Darren Hart
Intel Open Source Technology Center
