Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaHCP7G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 11:59:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbaHCP7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 11:59:04 -0400
Date: Sun, 3 Aug 2014 17:59:01 +0200
From: Jean Delvare <jdelvare@suse.de>
To: kreijack@inwind.it
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, bryan@whatroute.net
Subject: Re: [PATCH 4/4] Return the fan speed via sysfs
Message-ID: <20140803175901.27519306@endymion.delvare>
In-Reply-To: <53DE54D5.2050806@inwind.it>
References: <1406901650-20841-1-git-send-email-kreijack@inwind.it>
	<1406901650-20841-5-git-send-email-kreijack@inwind.it>
	<20140803161738.485f3f60@endymion.delvare>
	<53DE54D5.2050806@inwind.it>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Aug 2014 17:27:17 +0200, Goffredo Baroncelli wrote:
> On 08/03/2014 04:17 PM, Jean Delvare wrote:
> > On Fri,  1 Aug 2014 14:00:50 +0000, Goffredo Baroncelli wrote:
> >> Return the fan speed via sysfs:
> >> /sys/devices/temperature/fan_level
> > 
> > Good idea. Even better would be if the driver would expose a standard
> > hwmon interface for the temperature values. Fan level could go in
> > attribute "pwm1" after proper scaling.
> 
> I tought the same. But until now the value logged is an integer value
> between 1 and 11. So I preferred to leave it as is.
> 
> The thing that I can do is to *add* a further attribute called pwm1.
> ( I have to check how adm1031.c computes its pwm), because is a 
> more standard interface.

The temperature attributes in hwmon would need different names and
units too (temp1_input and temp2_input, in millidegree C.) The
advantage is that all monitoring applications out there would pick up
these values automatically.

> I even thought to allow to change the fan speed from user space....

Ben will never let you do that ;-)

> >> @@ -265,6 +271,7 @@ setup_hardware( void )
> >>  
> >>  	err = device_create_file( &x.of_dev->dev, &dev_attr_cpu_temperature );
> >>  	err |= device_create_file( &x.of_dev->dev, &dev_attr_case_temperature );
> >> +	err |= device_create_file( &x.of_dev->dev, &dev_attr_fan_level );
> >>  	if (err)
> >>  		printk(KERN_WARNING
> >>  			"Failed to create temperature attribute file(s).\n");
> > 
> > That's not your fault but please note that this construct is broken.
> > You can't "or" error codes together, the result if two or more calls
> > fail with different error codes is pretty random. Instead, each error
> > must be tested individually. I know checkpatch.pl will complain if you
> > do that but you can ignore it as is it the right thing to do in that
> > case.
> 
> The really question is what we should do if the 2nd device_create_file()
> would fail: we should fails the driver initialization ? or we should
> continue, because even if there aren't some sysfs attributes the driver
> work enough ?

I would log a warning and continue because it's a secondary feature of
the driver. Exactly as the driver already does - no change here.

In practice it's never going to happen so it doesn't really matter. I
just wanted to point out that the construct used in the driver was
dangerous. In this specific case it's harmless because the value of
"err" is never used (other than the fact that it's non-zero.) But if
the error code was included in the log message for example (which is
recommended), it would possibly make no sense.

Feel free to ignore this problem in this patch, it's not so important.

-- 
Jean Delvare
SUSE L3 Support
