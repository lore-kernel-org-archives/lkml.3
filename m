Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaK2Roi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 12:44:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaK2Roi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:44:38 -0500
Date: Sat, 29 Nov 2014 09:43:15 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Message-ID: <20141129174315.GA32132@kroah.com>
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 05:04:07PM +0100, Pali Rohár wrote:
> This patch adds labels for temperature sensors if SMM function with EAX register
> 0x11a3 reports it. These informations was taken from DOS binary NBSVC.MDM.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  drivers/char/i8k.c |  110 +++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 88 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index e34a019..77af46b 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -42,6 +42,7 @@
>  #define I8K_SMM_GET_FAN		0x00a3
>  #define I8K_SMM_GET_SPEED	0x02a3
>  #define I8K_SMM_GET_TEMP	0x10a3
> +#define I8K_SMM_GET_TEMP_TYPE	0x11a3
>  #define I8K_SMM_GET_DELL_SIG1	0xfea3
>  #define I8K_SMM_GET_DELL_SIG2	0xffa3
>  
> @@ -288,6 +289,14 @@ static int i8k_set_fan(int fan, int speed)
>  	return i8k_smm(&regs) ? : i8k_get_fan_status(fan);
>  }
>  
> +static int i8k_get_temp_type(int sensor)
> +{
> +	struct smm_regs regs = { .eax = I8K_SMM_GET_TEMP_TYPE, };
> +
> +	regs.ebx = sensor & 0xff;
> +	return i8k_smm(&regs) ? : regs.eax & 0xff;
> +}
> +
>  /*
>   * Read the cpu temperature.
>   */
> @@ -493,6 +502,29 @@ static int i8k_open_fs(struct inode *inode, struct file *file)
>   * Hwmon interface
>   */
>  
> +static ssize_t i8k_hwmon_show_temp_label(struct device *dev,
> +				   struct device_attribute *devattr,
> +				   char *buf)
> +{
> +	static const char * const labels[] = {
> +		"CPU",
> +		"GPU",
> +		"SODIMM",
> +		"Other",
> +		"Ambient",
> +		"Other",
> +	};
> +	int index = to_sensor_dev_attr(devattr)->index;
> +	int type;
> +
> +	type = i8k_get_temp_type(index);
> +	if (type < 0)
> +		return type;
> +	if (type >= ARRAY_SIZE(labels))
> +		type = ARRAY_SIZE(labels) - 1;
> +	return sprintf(buf, "%s\n", labels[type]);
> +}

No Documentation/ABI/ entry for your new sysfs file?
