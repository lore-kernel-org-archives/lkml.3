Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaHCORm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 10:17:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaHCORl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 10:17:41 -0400
Date: Sun, 3 Aug 2014 16:17:38 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, bryan@whatroute.net,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 4/4] Return the fan speed via sysfs
Message-ID: <20140803161738.485f3f60@endymion.delvare>
In-Reply-To: <1406901650-20841-5-git-send-email-kreijack@inwind.it>
References: <1406901650-20841-1-git-send-email-kreijack@inwind.it>
	<1406901650-20841-5-git-send-email-kreijack@inwind.it>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  1 Aug 2014 14:00:50 +0000, Goffredo Baroncelli wrote:
> Return the fan speed via sysfs:
> /sys/devices/temperature/fan_level

Good idea. Even better would be if the driver would expose a standard
hwmon interface for the temperature values. Fan level could go in
attribute "pwm1" after proper scaling.

Please follow scripts/checkpatch.pl's advice to fix the coding style.

> This patch is copied from the Bryan Christianson's patch (see
> debian bug #741663)
> 
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> ---
>  drivers/macintosh/therm_windtunnel.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
> index 0c4eb85..a2af7db 100644
> --- a/drivers/macintosh/therm_windtunnel.c
> +++ b/drivers/macintosh/therm_windtunnel.c
> @@ -111,9 +111,15 @@ show_case_temperature( struct device *dev, struct device_attribute *attr, char *
>  	return sprintf(buf, "%d.%d\n", x.casetemp>>8, (x.casetemp & 255)*10/256 );
>  }
>  
> +static ssize_t
> +show_fan_level( struct device *dev, struct device_attribute *attr, char *buf )
> +{
> +	return sprintf(buf, "%d\n", 11 - x.fan_level );
> +}
> +
>  static DEVICE_ATTR(cpu_temperature, S_IRUGO, show_cpu_temperature, NULL );
>  static DEVICE_ATTR(case_temperature, S_IRUGO, show_case_temperature, NULL );
> -
> +static DEVICE_ATTR(fan_level, S_IRUGO, show_fan_level, NULL );
>  
>  
>  /************************************************************************/
> @@ -265,6 +271,7 @@ setup_hardware( void )
>  
>  	err = device_create_file( &x.of_dev->dev, &dev_attr_cpu_temperature );
>  	err |= device_create_file( &x.of_dev->dev, &dev_attr_case_temperature );
> +	err |= device_create_file( &x.of_dev->dev, &dev_attr_fan_level );
>  	if (err)
>  		printk(KERN_WARNING
>  			"Failed to create temperature attribute file(s).\n");

That's not your fault but please note that this construct is broken.
You can't "or" error codes together, the result if two or more calls
fail with different error codes is pretty random. Instead, each error
must be tested individually. I know checkpatch.pl will complain if you
do that but you can ignore it as is it the right thing to do in that
case.

> @@ -275,6 +282,7 @@ restore_regs( void )
>  {
>  	device_remove_file( &x.of_dev->dev, &dev_attr_cpu_temperature );
>  	device_remove_file( &x.of_dev->dev, &dev_attr_case_temperature );
> +	device_remove_file( &x.of_dev->dev, &dev_attr_fan_level );
>  
>  	write_reg( x.fan, 0x01, x.r1, 1 );
>  	write_reg( x.fan, 0x20, x.r20, 1 );


-- 
Jean Delvare
SUSE L3 Support
