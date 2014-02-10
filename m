Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaBJRJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:09:55 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64677 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbaBJRJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:09:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMwXhNr27fwwhr=Fb996b1DtSb0R6xiasMY2PsbTwVNe2qgOQ@mail.gmail.com>
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
	<20140210160842.GB26997@lee--X1>
	<20140210173811.04ba5964@endymion.delvare>
	<CAOMwXhNr27fwwhr=Fb996b1DtSb0R6xiasMY2PsbTwVNe2qgOQ@mail.gmail.com>
Date: Mon, 10 Feb 2014 17:09:45 +0000
X-Google-Sender-Auth: UyRWbUNhftq4D4XC9YrEnNfiLo8
Message-ID: <CAOMwXhP6F0OL3DyCmrhMf0_eQG0+5YzzRLKDycNEigWwkWs8fg@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Rename the device ids to
 contain the hwmon suffix
From: Laszlo Papp <lpapp@kde.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 5:06 PM, Laszlo Papp <lpapp@kde.org> wrote:
> On Mon, Feb 10, 2014 at 4:38 PM, Jean Delvare <jdelvare@suse.de> wrote:
>> Hi Lee, Laszlo,
>>
>> On Mon, 10 Feb 2014 16:08:42 +0000, Lee Jones wrote:
>>> > In the preparation of creating an mfd driver and then refactor this one into a
>>> > platform driver in order to add some pinctrl functionality to the chip, it is
>>> > necessary to start the series with this change so that the mfd driver can refer
>>> > to the proper name in the subsequent change without making changes in more than
>>> > one driver later.
>>> >
>>> > This was a request from Lee Jones, the MFD subsystem maintainer.
>>> >
>>> > Signed-off-by: Laszlo Papp <lpapp@kde.org>
>>> > ---
>>> >  drivers/hwmon/max6650.c | 4 ++--
>>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>>> >
>>> > diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
>>> > index 0cafc39..3c36edc 100644
>>> > --- a/drivers/hwmon/max6650.c
>>> > +++ b/drivers/hwmon/max6650.c
>>> > @@ -116,8 +116,8 @@ static struct max6650_data *max6650_update_device(struct device *dev);
>>> >   */
>>> >
>>> >  static const struct i2c_device_id max6650_id[] = {
>>> > -   { "max6650", 1 },
>>> > -   { "max6651", 4 },
>>> > +   { "max6650-hwmon", 1 },
>>> > +   { "max6651-hwmon", 4 },
>>
>> No, this is not acceptable, sorry. This will change the name of the
>> hwmon device as seen from user-space, breaking any configuration file
>> referring to it. Additionally, dashes are explicitly forbidden in hwmon
>> device names. And lastly this will break any explicit instantiation of
>> theses devices (which is the only way, as the driver doesn't support
>> device auto-detection), be it in the kernel itself or from user-space.
>>
>> The change doesn't make sense anyway. If you move to the MFD framework,
>> the core driver will be an I2C driver binding to the I2C device, and it
>> will spawn the logical devices, presumably in the form of platform
>> devices. That's what the current max6650 driver would have to bind to.
>> Just renaming the device won't work, you also need to change the type.
>
> Hmm, this paragraph seems to indicate that you have not seen my
> previous patch set. I tried to summarize in this commit message that
> the type in this subdriver would need to change, yes.
>
> I am fine with not renaming, but appending if such a thing is
> possible. What does not make sense to me is acquiring a "global"
> max665x name in a sub-device driver. The children have to be
> distinguished somehow!
>
>> If you want to turn this into an MFD driver, I believe you must first
>> convert the hwmon part to register using
>> devm_hwmon_device_register_with_groups(). This will dissociate the i2c
>> device name from the hwmon device name and create a clean name-space
>> for each function. Guenter, maybe you had a plan to do so already
>> anyway?
>>
>> That being said, going with MFD in this case seems quite overkill to
>> me. MFD makes a lot of sense when each function has its own resources.
>> As this isn't the case here, a single driver registering both an hwmon
>> interface and a pinctrl interface would seem sufficient to me. But I
>> think Guenter already discussed this in the past so I'll let him
>> continue and decide.
>
> Exactly. This had been overdiscussed. I took my personal preference
> without any technical drawback. I prefer clean separation just like
> several other mfd drivers are doing, really.
>
> Tell me this is unacceptable, and I will stop helping with getting the
> required functionality into the kernel. Frankly, I am getting tired of
> having worked on it for a few months now, and we are still at
> discussing personal preferences rather than getting features in ...

Moreover, I really do not see how this is an overkill. In my opinion,
quite the opposite, putting MFD functionality for different areas into
one particular area is more than peculiar.

Even more, Guenter has been included in the long
gpio/pinctrl/mfd/hwmon patchset discussions. Could you please make up
your mind finally? I am sorry if this sounds harsh, but I hope you
understand my position. Trying to help this stuff moving forward, and
even after months of discussion we are still hitting the same
opinionated gates.
