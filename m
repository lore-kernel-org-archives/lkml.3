Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaKYWla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:41:30 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:51289 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaKYWl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:41:29 -0500
MIME-Version: 1.0
In-Reply-To: <1926483.B4ieFnCBlM@vostro.rjw.lan>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org>
	<2580837.YI0IvfXqRR@vostro.rjw.lan>
	<20141125202722.GA25261@sirena.org.uk>
	<1926483.B4ieFnCBlM@vostro.rjw.lan>
Date: Tue, 25 Nov 2014 14:41:28 -0800
X-Google-Sender-Auth: 2tIIqxPT08XQwy0R5molUvUo60g
Message-ID: <CAOV7By+7g19p_-4R-sSM_2q04fKCmOq3um+S_L=5z=T5SVdwAw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
From: Ben Zhang <benzh@chromium.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Mark Brown <broonie@kernel.org>,
        Duncan Laurie <dlaurie@google.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        Flove <flove@realtek.com>, Al Stone <al.stone@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Duncan who works on our firmware project.

Please correct me if I'm wrong. Here is the summary of what I understand. Looks
like the recommended practice for passing device platform data is using _DSD and
the new device_property_read_ API from include/linux/property.h

For example, the firmware (coreboot) should specify something like:
Device (CODC)
{
    Name (_HID, "RT5677CE")
    ...
    Name (_DSD, Package () {
        ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
        Package () {
            Package (2) {"realtek,in1-differential", 1},
            Package (2) {"realtek,in2-differential", 0},
            Package (2) {"realtek,gpio-config",  Package (6)  { 0, 0,
0, 0, 0, 2 }},
            ...
        }
    })
    ...
}

And the kernel driver should query with something like:
static void rt5677_read_platform_data(struct rt5677_priv *rt5677,
struct device *dev)
{
    u8 val;

    device_property_read_u8_array(dev, "realtek,in1-differential", &val, 1);
    rt5677->pdata.in1_diff = (bool)val;
    device_property_read_u8_array(dev, "realtek,in2-differential", &val, 1);
    rt5677->pdata.in2_diff = (bool)val;

    device_property_read_u8_array(dev, "realtek,gpio-config",
            rt5677->pdata.gpio_config, RT5677_GPIO_NUM);
    ...
}
And the device property API should work for both DT and ACPI.

Also these device property name keys should be registered with the
ACPI working group
following http://www.uefi.org/sites/default/files/resources/web-page-v2.pdf


On Tue, Nov 25, 2014 at 1:40 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, November 25, 2014 08:27:22 PM Mark Brown wrote:
>>
>> --ReaqsoxgOBHFXBhH
>> Content-Type: text/plain; charset=us-ascii
>> Content-Disposition: inline
>>
>> On Tue, Nov 25, 2014 at 09:31:27PM +0100, Rafael J. Wysocki wrote:
>> > On Tuesday, November 25, 2014 11:07:06 AM Darren Hart wrote:
>>
>> > > This is a current topic with the ACPI working group. We have the
>> > > following document:
>>
>> > > http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
>>
>> > This hasn't been discussed a lot at the meetings I attended.
>>
>> > The bindings management process is being set up within the UEFI Forum, but I'm
>> > not sure if/how the existing DT bindings documented in the kernel tree are
>> > going to be covered by it ATM.
>>
>> Al Stone (CCed) pointed me at the following two documents:
>>
>> http://www.uefi.org/sites/default/files/resources/web-page-v2.pdf
>> http://www.uefi.org/sites/default/files/resources/nic-request-v2.pdf
>>
>> (the first one being the actual process in so far as it exists).  The
>> process appears to be to mail requests in a specific format to the ASWG
>> chairperson (the address is apparently supposed to be awsg@uefi.org).
>> It looks like all the properties are expected to end up in one or more
>> PDF files like the second one.
>>
>> My initial thought would be to require that we send any DT properties
>> defined for devices with ACPI identifiers registered there and hope the
>> volume doesn't DoS them.
>
> We absolutely need to start registering the existing bindings in there, but
> that needs to be rate limited somehow, because the process may not be very
> efficient to start with.
>
>> A more defined format for DT documentation that we can script into the
>> ASWG format (or vice versa) might be helpful here, and we should add
>> notes to the DT documentation if this is how we want to proceed.
>
> That's a good point.
>
> Unfortunately, the timing is pretty bad (Thanksgiving) and the closest
> ASWG meeting is next Thursday, but that one's likely to be busy for other
> reasons.  I presume, then, that the earliest we can seriously get back to
> that in the ASWG is mid-December.
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
