Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab3EISDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 14:03:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab3EISDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 14:03:35 -0400
Date: Thu, 9 May 2013 11:03:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Cc: zbr@ioremap.net, linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH V2] w1: ds2408: add magic sequence to disable P0 test
 mode
Message-Id: <20130509110333.f6ba3b4cc22e87c7adb30993@linux-foundation.org>
In-Reply-To: <1367935248-12118-1-git-send-email-jeff.dagenais@gmail.com>
References: <1367930422-25972-2-git-send-email-jeff.dagenais@gmail.com>
	<1367935248-12118-1-git-send-email-jeff.dagenais@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 May 2013 10:00:48 -0400 Jean-Francois Dagenais <jeff.dagenais@gmail.com> wrote:

> V2: use the new bus_mutex
> 
> extract from http://datasheets.maximintegrated.com/en/ds/DS2408.pdf:
> 
> Power-up timing
> The DS2408 is sensitive to the power-on slew rate and can inadvertently
> power up with a test mode feature enabled. When this occurs, the P0 port
> does not respond to the Channel Access Write command.
> For most reliable operation, it is recommended to disable the test mode
> after every power-on reset using the Disable Test Mode sequence shown
> below. The 64-bit ROM code must be transmitted in the same bit sequence
> as with the Match ROM command, i.e., least significant bit first. This
> precaution is recommended in parasite power mode (VCC pin connected to
> GND) as well as with VCC power.
> 
> Disable Test Mode:
> RST,PD,96h,<64-bit DS2408 ROM Code>,3Ch,RST,PD
> 
> ...
>
> --- a/drivers/w1/slaves/w1_ds2408.c
> +++ b/drivers/w1/slaves/w1_ds2408.c
> @@ -301,7 +301,32 @@ error:
>  	return -EIO;
>  }
>  
> +/**

/** is used to introduce kerneldoc comments, but this isn't a kerneldoc
comment.  Just use /* here.

> + * This is a special sequence we must do to ensure the P0 output is not stuck
> + * in test mode. This is described in rev 2 of the ds2408's datasheet
> + * (http://datasheets.maximintegrated.com/en/ds/DS2408.pdf) under
> + * "APPLICATION INFORMATION/Power-up timing".
> + */
> +static int w1_f29_disable_test_mode(struct w1_slave *sl)
> +{
> +	int res;
> +	u8 magic[10] = {0x96, };
> +	u64 rn = le64_to_cpu(*((u64*)&sl->reg_num));
> +	memcpy(&magic[1], &rn, 8);
> +	magic[9] = 0x3C;

(please put a blank line between end-of-locals and start-of-code)

The casting looks decidedly dodgy.  I guess it won't cause an unalignned
exception due to reg_num's alignment, but it appears to defeat the
endianness handling in the definotion of `struct w1_reg_num'.

Are you sure this will work OK with all architectures and both
__LITTLE_ENDIAN_BITFIELD and __BIG_ENDIAN_BITFIELD?

> +	mutex_lock(&sl->master->bus_mutex);
>  
> +	res = w1_reset_bus(sl->master);
> +	if (res)
> +		goto out;
> +	w1_write_block(sl->master, magic, ARRAY_SIZE(magic));
> +
> +	res = w1_reset_bus(sl->master);
> +out:
> +	mutex_unlock(&sl->master->bus_mutex);
> +	return res;
> +}
>  
>  static struct bin_attribute w1_f29_sysfs_bin_files[] = {
>  	{
> @@ -362,6 +387,10 @@ static int w1_f29_add_slave(struct w1_slave *sl)
>  	int err = 0;
>  	int i;
>  
> +	err = w1_f29_disable_test_mode(sl);
> +	if (err)
> +		return err;
> +
>  	for (i = 0; i < ARRAY_SIZE(w1_f29_sysfs_bin_files) && !err; ++i)
>  		err = sysfs_create_bin_file(
>  			&sl->dev.kobj,

