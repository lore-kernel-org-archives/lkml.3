Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaJPTTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:19:05 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41157 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaJPTTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:19:04 -0400
Date: Thu, 16 Oct 2014 12:18:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: atull <atull@opensource.altera.com>
Cc: jdelvare@suse.de, lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v6 3/4] pmbus: add regulator support
Message-ID: <20141016191857.GA22237@roeck-us.net>
References: <1413399310-19277-1-git-send-email-atull@opensource.altera.com>
 <1413399310-19277-4-git-send-email-atull@opensource.altera.com>
 <20141016183501.GA21253@roeck-us.net>
 <alpine.DEB.2.02.1410161339450.28663@atx-linux-37>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1410161339450.28663@atx-linux-37>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 01:40:23PM -0500, atull wrote:
> On Thu, 16 Oct 2014, Guenter Roeck wrote:
> 
> > On Wed, Oct 15, 2014 at 01:55:09PM -0500, atull@opensource.altera.com wrote:
> > > From: Alan Tull <atull@opensource.altera.com>
> > > 
> > > Add support for simple on/off control of each channel.
> > > 
> > > To add regulator support, the pmbus part driver needs to add
> > > regulator_desc information and number of regulators to its
> > > pmbus_driver_info struct.
> > > 
> > > regulator_desc can be declared using default macro for a
> > > regulator (PMBUS_REGULATOR) that is in pmbus.h
> > > 
> > > The regulator_init_data can be initialized from either
> > > platform data or the device tree.
> > > 
> > > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > > Reviewed-by: Mark Brown <broonie@kernel.org>
> > > Cc: Guenter Roeck <linux@roeck-us.net>
> > 
> > Hi Alan,
> > 
> > I am still seeing lots of the following:
> > 
> > vout0: Failed to create debugfs directory
> > vout1: Failed to create debugfs directory
> > vout2: Failed to create debugfs directory
> > vout3: Failed to create debugfs directory
> > vout4: Failed to create debugfs directory
> > vout5: Failed to create debugfs directory
> > vout6: Failed to create debugfs directory
> > vout7: Failed to create debugfs directory
> > 
> > I thought there was a problem in the regulator core, but after looking
> > into it concluded that the regulator core _should_ prepend the names
> > with the device name when creating the debugfs entries, unless no device
> > name is specified. So something must be missing. We'll need to sort
> > this out before I can accept the code.
> > 
> > Thanks,
> > Guenter
> > 
> 
> Hi Guenter,
> 
> OK, I will look into it.
> 
Hi Alan,

I tracked it down a bit further. It is a regulator core problem after all.
Turns out the parent device name is not _always_ used when creating
debugfs directories. The culprit is rdev_init_debugfs, which just takes
rdev_get_name() to create the name. I am currently playing with it.

Problem is that if I just prepend the parent device name (if available)
in rdev_init_debugfs, I get something like the following.

2-005c-pmb-vout0     5-005d-vout6  5-005f-vout5  5-0061-vout4
2-005c-pmb-vout1     5-005d-vout7  5-005f-vout6  5-0061-vout5
2-005c-pmb-vout2     5-005e-vout0  5-005f-vout7  5-0061-vout6
2-005c-vout3         5-005e-vout1  5-0060-vout0  5-0061-vout7
2-005c-vout4         5-005e-vout2  5-0060-vout1  5-0062-vout0
2-005c-vout5         5-005e-vout3  5-0060-vout2  5-0062-vout1
2-005c-vout6         5-005e-vout4  5-0060-vout3  5-0062-vout2
2-005c-vout7         5-005e-vout5  5-0060-vout4  5-0062-vout3
3p3v.11-3P3V         5-005e-vout6  5-0060-vout5  5-0062-vout4
5-005d-fpc-5d-vout0  5-005e-vout7  5-0060-vout6  5-0062-vout5
5-005d-fpc-5d-vout1  5-005f-vout0  5-0060-vout7  5-0062-vout6
5-005d-vout2         5-005f-vout1  5-0061-vout0  5-0062-vout7
5-005d-vout3         5-005f-vout2  5-0061-vout1  reg-dummy-regulator-dummy
5-005d-vout4         5-005f-vout3  5-0061-vout2  supply_map
5-005d-vout5         5-005f-vout4  5-0061-vout3

This is a bit better but creates names such as "3p3v.11-3P3V"
and "reg-dummy-regulator-dummy" which doesn't make much sense
either. So I think we'll need something better than that.

Guenter
