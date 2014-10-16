Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaJPNYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:24:52 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:39654 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaJPNYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:24:51 -0400
Message-ID: <543FC71D.10509@roeck-us.net>
Date: Thu, 16 Oct 2014 06:24:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Octavian Purdila <octavian.purdila@intel.com>, wsa@the-dreams.de
CC: johan@kernel.org, linux-i2c@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATH v3 4/4] i2c: i2c-diolan-u2c: sysfs bus frequency support
References: <1413403411-8895-1-git-send-email-octavian.purdila@intel.com> <1413403411-8895-5-git-send-email-octavian.purdila@intel.com>
In-Reply-To: <1413403411-8895-5-git-send-email-octavian.purdila@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.543FC722.0256,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 01:03 PM, Octavian Purdila wrote:
> Add support for showing and changing the bus frequency via
> sysfs.
>
> Tested on a DLN2 adapter run in U2C-12 compatibility mode.
>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---
>   drivers/i2c/busses/i2c-diolan-u2c.c | 49 +++++++++++++++++++++++++------------
>   1 file changed, 34 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-diolan-u2c.c b/drivers/i2c/busses/i2c-diolan-u2c.c
> index b19a310..ff4e120 100644
> --- a/drivers/i2c/busses/i2c-diolan-u2c.c
> +++ b/drivers/i2c/busses/i2c-diolan-u2c.c
> @@ -71,6 +71,9 @@
>   #define U2C_I2C_FREQ_STD	100000
>   #define U2C_I2C_FREQ(s)		(1000000 / (2 * (s - 1) + 10))
>
> +#define U2C_I2C_MIN_FREQ	U2C_I2C_FREQ(U2C_I2C_SPEED_2KHZ)
> +#define U2C_I2C_MAX_FREQ	U2C_I2C_FREQ_FAST
> +
>   #define DIOLAN_USB_TIMEOUT	100	/* in ms */
>   #define DIOLAN_SYNC_TIMEOUT	20	/* in ms */
>
> @@ -298,31 +301,24 @@ static void diolan_get_serial(struct i2c_diolan_u2c *dev)
>   	}
>   }
>
> -static int diolan_init(struct i2c_diolan_u2c *dev)
> +static int diolan_set_freq(struct i2c_adapter *adapter, unsigned int *frequency)

I really dislike this kind of side-effect programming, where a function
named as _set changes one of its parameters. Not my call to make here,
though, so if the i2c maintainers are fine with it

Acked-by: Guenter Roeck <linux@roeck-us.net>

>   {
> +	struct i2c_diolan_u2c *dev = i2c_get_adapdata(adapter);
>   	int speed, ret;
>
> -	if (frequency >= 200000) {
> +	if (*frequency >= 200000) {
>   		speed = U2C_I2C_SPEED_FAST;
> -		frequency = U2C_I2C_FREQ_FAST;
> -	} else if (frequency >= 100000 || frequency == 0) {
> +		*frequency = U2C_I2C_FREQ_FAST;
> +	} else if (*frequency >= 100000 || *frequency == 0) {
>   		speed = U2C_I2C_SPEED_STD;
> -		frequency = U2C_I2C_FREQ_STD;
> +		*frequency = U2C_I2C_FREQ_STD;
>   	} else {
> -		speed = U2C_I2C_SPEED(frequency);
> +		speed = U2C_I2C_SPEED(*frequency);
>   		if (speed > U2C_I2C_SPEED_2KHZ)
>   			speed = U2C_I2C_SPEED_2KHZ;
> -		frequency = U2C_I2C_FREQ(speed);
> +		*frequency = U2C_I2C_FREQ(speed);
>   	}
>
> -	dev_info(&dev->interface->dev,
> -		 "Diolan U2C at USB bus %03d address %03d speed %d Hz\n",
> -		 dev->usb_dev->bus->busnum, dev->usb_dev->devnum, frequency);
> -
> -	diolan_flush_input(dev);
> -	diolan_fw_version(dev);
> -	diolan_get_serial(dev);
> -
>   	/* Set I2C speed */
>   	ret = diolan_set_speed(dev, speed);
>   	if (ret < 0)
> @@ -336,6 +332,23 @@ static int diolan_init(struct i2c_diolan_u2c *dev)
>   	if (speed != U2C_I2C_SPEED_FAST)
>   		ret = diolan_set_clock_synch_timeout(dev, DIOLAN_SYNC_TIMEOUT);
>
> +	return 0;
> +}
> +
> +static int diolan_init(struct i2c_diolan_u2c *dev)
> +{
> +	int ret;
> +
> +	diolan_flush_input(dev);
> +	diolan_fw_version(dev);
> +	diolan_get_serial(dev);
> +
> +	ret = diolan_set_freq(&dev->adapter, &frequency);
> +
> +	dev_info(&dev->interface->dev,
> +		 "Diolan U2C at USB bus %03d address %03d speed %d Hz\n",
> +		 dev->usb_dev->bus->busnum, dev->usb_dev->devnum, frequency);
> +
>   	return ret;
>   }
>
> @@ -471,6 +484,9 @@ static int diolan_u2c_probe(struct usb_interface *interface,
>   	dev->adapter.owner = THIS_MODULE;
>   	dev->adapter.class = I2C_CLASS_HWMON;
>   	dev->adapter.algo = &diolan_usb_algorithm;
> +	dev->adapter.min_freq = U2C_I2C_MIN_FREQ;
> +	dev->adapter.max_freq = U2C_I2C_MAX_FREQ;
> +	dev->adapter.set_freq = diolan_set_freq;
>   	i2c_set_adapdata(&dev->adapter, dev);
>   	snprintf(dev->adapter.name, sizeof(dev->adapter.name),
>   		 DRIVER_NAME " at bus %03d device %03d",
> @@ -485,6 +501,9 @@ static int diolan_u2c_probe(struct usb_interface *interface,
>   		goto error_free;
>   	}
>
> +	/* set the current bus frequency */
> +	dev->adapter.freq = frequency;
> +
>   	/* and finally attach to i2c layer */
>   	ret = i2c_add_adapter(&dev->adapter);
>   	if (ret < 0) {
>

