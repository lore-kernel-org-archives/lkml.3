Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaJGAoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:44:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34225 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaJGAoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:44:37 -0400
Date: Mon, 6 Oct 2014 17:44:35 -0700
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] toshiba_acpi: Adapt kbd_bl_timeout_store to the new
 kbd type
Message-ID: <20141007004434.GA26764@vmdeb7>
References: <1412445741-7719-1-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412445741-7719-1-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Azael,

On Sat, Oct 04, 2014 at 12:02:21PM -0600, Azael Avalos wrote:
> With the introduccion of the new keyboard backlight

introduction

> implementation, the *_timeout_store function is
> broken, as it only supports the first kbd_type.
> 
> This patch adapt such function for the new kbd_type,

adapts

> as well as convert from using sscanf to kstrtoint.

converts

>

Functional changes look good to me, thank you.

I've made a couple minor formatting corrections in the interest of time. In
the future, please check your patches with checkpatch.pl and consider using a
spell checker in your $EDITOR for commit messages. Using git am to apply your
own patches would also have caught the whitespace error.

> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>

Queued to testing, I'll push to for-next tomorrow(ish), which should give us
enough time to make 3.18 since Linus pushed out the merge window a bit.

> ---
> Changes since v1:
> - Check for timeout values depending on kbd_type
> - Removed some misleading comments
> 
> Note: I'll be out of town until the next weekend,
> in case something else needs to be changed, I'll
> catch up whenever I'm back.
> 
>  drivers/platform/x86/toshiba_acpi.c | 38 ++++++++++++++++++++++++++++---------
>  1 file changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index 5d509ea..f360dac 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -1453,18 +1453,38 @@ static ssize_t toshiba_kbd_bl_timeout_store(struct device *dev,
>  					    const char *buf, size_t count)
>  {
>  	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
> -	int time = -1;
> +	int time;
> +	int ret;
>  
> -	if (sscanf(buf, "%i", &time) != 1 && (time < 0 || time > 60))
> -		return -EINVAL;
> +	ret = kstrtoint(buf, 0, &time);
> +	if (ret)
> +		return ret;
>  
> -	/* Set the Keyboard Backlight Timeout: 0-60 seconds */
> -	if (time != -1 && toshiba->kbd_time != time) {
> +	/* Check for supported values depending on kbd_type */
> +	if (toshiba->kbd_type == 1) {
> +		if (time < 0 || time > 60)
> +			return -EINVAL;
> +	} else if (toshiba->kbd_type == 2) {
> +		if (time < 1 || time > 60)
> +			return -EINVAL;
> +	}
> +
> +	/* Set the Keyboard Backlight Timeout */
> +	

 ^ Tab at beginning of otherwise empty line.

Thanks,

Darren

> +	/* Only make a change if the actual timeout has changed */
> +	if (toshiba->kbd_time != time) {
> +		/* Shift the time to "base time" (0x3c0000 == 60 seconds) */
>  		time = time << HCI_MISC_SHIFT;
> -		time = (toshiba->kbd_mode == SCI_KBD_MODE_AUTO) ?
> -							time + 1 : time + 2;
> -		if (toshiba_kbd_illum_status_set(toshiba, time) < 0)
> -			return -EIO;
> +		/* OR the "base time" to the actual method format */
> +		if (toshiba->kbd_type == 1)
> +			time |= SCI_KBD_MODE_FNZ;
> +		else if (toshiba->kbd_type == 2)
> +			time |= SCI_KBD_MODE_AUTO;
> +
> +		ret = toshiba_kbd_illum_status_set(toshiba, time);
> +		if (ret)
> +			return ret;
> +
>  		toshiba->kbd_time = time >> HCI_MISC_SHIFT;
>  	}
>  
> -- 
> 2.0.0
> 
> 

-- 
Darren Hart
Intel Open Source Technology Center
