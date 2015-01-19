Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbbASOkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:40:45 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36114 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbbASOkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:40:40 -0500
MIME-Version: 1.0
In-Reply-To: <1419110952.2843.8.camel@spandruv-hsb-test>
References: <1418923002-901-1-git-send-email-daniel.baluta@intel.com>
	<5494A3D6.60607@gmx.de>
	<CAEnQRZABxH5MuWEnS=RHmQqGUN0QhFTtXxnM1uyrLxvP2a-Rmg@mail.gmail.com>
	<1419110796.2843.6.camel@spandruv-hsb-test>
	<1419110952.2843.8.camel@spandruv-hsb-test>
Date: Mon, 19 Jan 2015 16:40:38 +0200
X-Google-Sender-Auth: ZeK6LDc3Cgp4dM9CNEGpU38i73Q
Message-ID: <CAEnQRZC_SR_p2oYq9EpDDfBi2nCAAWvYmf0tR7V7WPZRZEp79g@mail.gmail.com>
Subject: Re: [RFC PATCH] iio: ak8975: Make sure chipset is always initialized
From: Daniel Baluta <daniel.baluta@intel.com>
To: "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>
Cc: "Baluta, Daniel" <daniel.baluta@intel.com>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "knaack.h@gmx.de" <knaack.h@gmx.de>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "Purdila, Octavian" <octavian.purdila@intel.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "pmeerw@pmeerw.net" <pmeerw@pmeerw.net>,
        "beomho.seo@samsung.com" <beomho.seo@samsung.com>,
        "gwendal@chromium.org" <gwendal@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Dec 20, 2014 at 11:29 PM, Pandruvada, Srinivas
<srinivas.pandruvada@intel.com> wrote:
> +Mika
>
> On Sat, 2014-12-20 at 13:26 -0800, Srinivas Pandruvada wrote:
>> On Sat, 2014-12-20 at 00:25 +0200, Daniel Baluta wrote:
>> > On Sat, Dec 20, 2014 at 12:16 AM, Hartmut Knaack <knaack.h@gmx.de> wrote:
>> > > Daniel Baluta schrieb am 18.12.2014 um 18:16:
>> > >> When using ACPI, if acpi_match_device fails then chipset enum will be
>> > >> uninitialized and &ak_def_array[chipset] will point to some bad address.
>> > >>
>> I am missing something. You are enumerated over i2c device, which was
>> created from ACPI PNP resource. There is a valid handle or and the
>> device has an ACPI companion at the least. If this failing, I have to
>> check the code for acpi i2c.
>> Can you check why this check failed? We may have bug in i2c handling.

You are right about this. Under normal circumstances, if probe is called
then acpi_match_device will not fail. I even tried to remove the
device after probe
but before acpi_match_device, anyhow acpi_match_device was still successful :)

This is more a matter of code correctness.

In ak8975_match_acpi_device we have:

»       const struct acpi_device_id *id;

»       id = acpi_match_device(dev->driver->acpi_match_table, dev);
»       if (!id)
»       »       return NULL;
»       *chipset = (int)id->driver_data;

Compiler complains on the fact that chipset might be uninitialized
if this returns NULL, and we shouldn't ignore this warning even this case
will never happen.

We could use some code injection techniques to force acpi_match_device
to return NULL tough.

>> > >> This fixes the following compilation warning:
>> > >>
>> > >> drivers/iio/magnetometer/ak8975.c: In function ‘ak8975_probe’:
>> > >> drivers/iio/magnetometer/ak8975.c:788:14: warning: ‘chipset’ may be used
>> > >> uninitialized in this function [-Wmaybe-uninitialized]
>> > >>   data->def =ak_def_array[chipset];
>> > >>
>> > >> Reported-by: Octavian Purdila <octavian.purdila@intel.com>
>> > >> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
>> > >> ---
>> > >> This is a RFC because while I'm pretty sure that chipset should be initialized
>> > >> with AK_MAX_TYPE in ak8975_match_acpi_device, I am not sure if we can live with
>> > >> a NULL return value of ak8975_match_acpi_device. Current implementation ignores
>> > >> return value of ak8975_match_acpi_device.
>> > > This seems to be the actual problem: these _match_acpi_device functions return
>> > > NULL on failure, and this should be checked for.
>> >
>> > Ok, so this would acceptable?
>> >
>> > diff --git a/drivers/iio/magnetometer/ak8975.c
>> > b/drivers/iio/magnetometer/ak8975.c
>> > index 0d10a4b..68d99e9 100644
>> > --- a/drivers/iio/magnetometer/ak8975.c
>> > +++ b/drivers/iio/magnetometer/ak8975.c
>> > @@ -776,8 +776,9 @@ static int ak8975_probe(struct i2c_client *client,
>> >                 name = id->name;
>> >         } else if (ACPI_HANDLE(&client->dev))
>> >                 name = ak8975_match_acpi_device(&client->dev, &chipset);
>> > -       else
>> > -               return -ENOSYS;
>> > +
>> > +       if (!name)
>> > +               return -ENODEV;
>> >
>> >
>> > I still have some doubts about return code in case of error.
>> >
>> > For ak8975 we use -ENOSYS, but for kxcjk-1013 we use -ENODEV.
>> >
>> > I will send a patch after we clear this out.
>> >
>> > thanks,
>> > Daniel.
>>
>
