Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbaFHUaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 16:30:20 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58887 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbaFHUaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 16:30:15 -0400
Date: Sun, 8 Jun 2014 13:30:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lothar Felten <l-felten@ti.com>,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (ina2xx) Change register cache to
 signed
Message-ID: <20140608203007.GA6265@roeck-us.net>
References: <1402174021-25857-1-git-send-email-fabio.baltieri@gmail.com>
 <20140608201600.GA30953@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140608201600.GA30953@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2014 at 01:16:00PM -0700, Guenter Roeck wrote:
> On Sat, Jun 07, 2014 at 09:47:01PM +0100, Fabio Baltieri wrote:
> > All devices supported by the ina2xx driver are bidirectional and reports
> > the measured value as a signed 16 bit, but the current driver
> > implementation caches the number as an u16, leading to an incorrect sign
> > extension when reporting to the userspace in ina2xx_get_value().
> > 
> > This patch fixes the problem by using a s16 instead, and has been tested
> > on an INA219.
> > 
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> 
> Applied.
> 
Actually, no, this won't work. The statement above is only correct for current
and shunt voltage measurements, but not for power measurements and not for bus
voltage measurements. Changing the register to s16 won't help; conversion needs
to be done in ina2xx_get_value() for shunt voltage and current measurement only.
Otherwise we just move the bug from current/shunt voltage measurements to
power / bus voltage measurements.

Even more interesting, the power is supposed to be the product of Bus voltage
and current, and the latter can be negative. However, the power register
description does not suggest that the upper bit would be a sign bit. So there
is some discrepancy in the datasheet, and we'll need some real-world data to
understand if the upper power bit is signed or not.

Guenter
