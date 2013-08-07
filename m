Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab3HGQoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:44:38 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:47635 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab3HGQof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:44:35 -0400
Date: Wed, 7 Aug 2013 09:44:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wei Ni <wni@nvidia.com>, Alexander Shiyan <shc_work@mail.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] hwmon: (lm90) Add power control
Message-ID: <20130807164438.GA14397@roeck-us.net>
References: <1375858358-15070-1-git-send-email-wni@nvidia.com>
 <5201FC2C.4030908@roeck-us.net>
 <52020047.1080705@nvidia.com>
 <1375865105.562600640@f434.i.mail.ru>
 <520214C9.1010200@nvidia.com>
 <52027086.1090608@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52027086.1090608@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 10:06:30AM -0600, Stephen Warren wrote:
> On 08/07/2013 03:35 AM, Wei Ni wrote:
> > On 08/07/2013 04:45 PM, Alexander Shiyan wrote:
> >>> On 08/07/2013 03:50 PM, Guenter Roeck wrote:
> >>>> On 08/07/2013 12:32 AM, Wei Ni wrote:
> >>>>> On 08/07/2013 03:27 PM, Alexander Shiyan wrote:
> >>>>>>> The device lm90 can be controlled by the vdd rail.
> >>>>>>> Adding the power control support to power on/off the vdd rail.
> >>>>>>> And make sure that power is enabled before accessing the device.
> >>>>>>>
> >>>>>>> Signed-off-by: Wei Ni <wni@nvidia.com>
> >>>>>>> ---
> >>>>>>>   drivers/hwmon/lm90.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >>>>>> [...]
> >>>>>>> +	if (!data->lm90_reg) {
> >>>>>>> +		data->lm90_reg = regulator_get(&client->dev, "vdd");
> >>>>>>> +		if (IS_ERR_OR_NULL(data->lm90_reg)) {
> >>>>>>> +			if (PTR_ERR(data->lm90_reg) == -ENODEV)
> >>>>>>> +				dev_info(&client->dev,
> >>>>>>> +					 "No regulator found for vdd. Assuming vdd is always powered.");
> >>>>>>> +			else
> >>>>>>> +				dev_warn(&client->dev,
> >>>>>>> +					 "Error [%ld] in getting the regulator handle for vdd.\n",
> >>>>>>> +					 PTR_ERR(data->lm90_reg));
> >>>>>>> +			data->lm90_reg = NULL;
> >>>>>>> +			mutex_unlock(&data->update_lock);
> >>>>>>> +			return -ENODEV;
> >>>>>>> +		}
> >>>>>>> +	}
> >>>>>>> +	if (is_enable) {
> >>>>>>> +		ret = regulator_enable(data->lm90_reg);
> >>>>>>> +		msleep(POWER_ON_DELAY);
> >>>>>>
> >>>>>> Can this delay be handled directly from regulator?
> >>>>>
> >>>>> I think it should be handled in the device driver.
> >>>>> Because there have different delay time to wait devices stable.
> >>>>>
> >>>>
> >>>> Then why does no other caller of regulator_enable() need this ?
> >>>> I don't think lm90 is so much different to other users of regulator
> >>>> functionality.
> >>>
> >>> May be I'm wrong. I noticed that in lm90 SPEC, the max of "SMBus Clock
> >>> Low Time" is 25ms, so I supposed that it may need about 20ms to stable
> >>> after power on.
> >>>
> >>> Anyway, if I remove this delay, the driver also works fine, so I will
> >>> remove it in my next patch.
> >>
> >> I originally had in mind that regulator API contain own delay option.
> >> E.g. reg-fixed-voltage && gpio-regulator contains "startup-delay-us" property.
> > 
> > As I know the "startup-delay-us" is used for the regulator device, not
> > the consumer devices.
> 
> Yes, the regulator should encoded its own startup delay. Each individual
> device should handle its own requirements for delay after power is stable.
> 
> > In this patch, msleep(POWER_ON_DELAY) was used to wait the lm90 stable,
> > but it seems it's unnecessary now :)
> 
> No, the driver needs to handle this properly. If the datasheet says a
> delay is needed, it is.
> 
Yes but, if at all, only if it is known that the supply has just been turned on.
Imposing the delay on every user of the driver is unacceptable.

Guenter
