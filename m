Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934130AbaEGQJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:09:34 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48250 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbaEGQJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:09:33 -0400
Date: Wed, 7 May 2014 09:09:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "weichun.pan" <weichun.pan@advantech.com.tw>
Cc: Jean Delvare <jdelvare@suse.de>,
        "Louis.Lu (SW)" <Louis.Lu@advantech.com.tw>,
        "neo.lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: Advantech iManager2 HW Monitor driver for Linux Kernel
Message-ID: <20140507160923.GA27030@roeck-us.net>
References: <AD88CF654E059047976AE20C8E1CB53912027C78DA@TAIPEI01.ADVANTECH.CORP>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AD88CF654E059047976AE20C8E1CB53912027C78DA@TAIPEI01.ADVANTECH.CORP>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 01:24:51PM +0800, weichun.pan wrote:
> Dear Jean and Guenter,
> 
> 
> Advantech's new module comes equipped with "iManager" - an embedded controller (EC), providing embedded features for system integrators to increase reliability and simplify integration.
> 
> 
> 
> This patch add the MFD driver for enabling Advantech iManager V2.0 chipset. Available functions support HW Monitor base on ITE-IT85XX chip. These functions are tested on Advantech SOM-5892 board. All the embedded functions are configured by a utility. Advantech has done all the hard work for user with the release of a suite of Software APIs.
> 
> 
> 
> These provide not only the underlying drivers required but also a rich set of user-friendly, intelligent and integrated interfaces, which speeds development, enhances security and offers add-on value for Advantech platforms.
> 
> 
> 
> The difference as follows:
> 
Hi,

there are a number of things you might want to look into for a
successful submission.

First, look into the relevant guides.

	Documentation/CodingStyle
	Documentation/SubmittingPatches
	Documentation/SubmitChecklist
	Documentation/SubmittingDrivers
	Documentation/hwmon/submitting-patches

There are also tools available to help with the process.
The most important ones in your case are probably
	scripts/Lindent		to ensure basic compliance with kernel
				code formatting rules
	scripts/checkpatch.pl	to check for coding style errors and warnings

checkpatch.pl reports
	total: 494 errors, 402 warnings, 2949 lines checked
which isn't really a good start. We'll want to see no errors,
and if there are warnings you should be ready to explain why you
did not fix it.

The patch itself appears to be corrupted. All lines have an empty line
in between. This makes it extremely difficult to just look at the code,
and makes it all but impossible to really review it.

Couple of comments, from browsing through the code:

- Please split the patch into one patch per subsystem (mfd, hwmon, ...).
- Please no commented out code.
- Please don't use "it85xx". The driver does not support all it85xx chips,
  just one.
- Please avoid introducing new macros (eg SENSOR_DEVICE_ATTR_IN). The added
  complexity is not worth the savings.
- For the hwmon attributes, you might want to consider using is_visible to
  check if an attribute is valid or not. That is much better than copying
  attribute pointers around (and keeping them twice, actually).
- Code such as
	char tmp[5];
	...
	if (tmp == NULL)
		return -ENOMEM;
  really does not make any sense.
- Please use devm_hwmon_device_register_with_groups() or, if that does not
  work for some reason, hwmon_device_register_with_groups() to register
  the hwmon device. That will also take care of the name attribute for you.
- The module alias for the hwmon driver won't work. Use '"platform:" DRV_NAME'.
- Some legal person will need to validate if the license in imanager2_hwm.h
  is acceptable for the kernel. If possible you might want to drop it.
  I would actually suggest to include the file in the hwmon source, as it is
  common with other drivers.
- The mfd code code references an i2c driver which is however not part of the
  submission. Please either provide this driver as well or drop the references
  to it.

Again, this is far from a complete review, just a very basic starting point.

Thanks,
Guenter
