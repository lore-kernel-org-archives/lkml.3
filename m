Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab3FYCNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 22:13:40 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:35983 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3FYCNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 22:13:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130624101454.GG27646@sirena.org.uk>
References: <1371713467-3256-1-git-send-email-chao.xie@marvell.com>
	<20130621152416.GC27646@sirena.org.uk>
	<CADApbeigFTQNhxR-CVBGUhXvg+jVtt7ZVvEHuKqeSA80CFz-dQ@mail.gmail.com>
	<20130624101454.GG27646@sirena.org.uk>
Date: Tue, 25 Jun 2013 10:13:38 +0800
Message-ID: <CADApbeh7upEmy7URYvoMdU0jUR4qC-a+AErH5ND5QG5xwVdAdg@mail.gmail.com>
Subject: Re: [PATCH V2] regulator: 88pm800: add regulator driver for 88pm800
From: Chao Xie <xiechao.mail@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Chao Xie <chao.xie@marvell.com>, lgirdwood@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        yizhang@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 6:14 PM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Jun 24, 2013 at 10:01:39AM +0800, Chao Xie wrote:
>> On Fri, Jun 21, 2013 at 11:24 PM, Mark Brown <broonie@kernel.org> wrote:
>
>> > Just provide get_voltage_sel(), the core will do the mapping to voltages
>> > using list_voltage().
>
>> I am a little confused.
>> The BUCK voltage is not linear, and it contains a lot of voltages.
>> If we use map_voltage_ascend, it will looking a a suitable voltage
>> from begin to end one by one.
>
> What does this have to do with get_voltage()?  And note that you can
> write your own mapping function for a reason...
>
>> If we directly make use of set_voltage and get_voltage, we can
>> directly calculates the voltage which is
>> suitable, and do not go through all the voltags.
>> for example, now BUCK voltage table is
>> range 1 from 600000 to 1587500, each step is 12500
>> range 2 from 1600000 to 1800000, each step is 50000
>
> No, this is nothing at all to do with using the selector versions of the
> API.  Think about what the API is doing and take a look at the code.
>
OK. I will try to define my own mapping function and use the sel APIs.

>> >> +     } else if (pdata->num_regulators) {
>> >> +             /* Check whether num_regulator is valid. */
>> >> +             unsigned int count = 0;
>> >> +             for (i = 0; pdata->regulators[i]; i++)
>> >> +                     count++;
>> >> +             if (count != pdata->num_regulators)
>> >> +                     return -EINVAL;
>
>> > This looks...  odd.
>
>> It is just make sure that pdata has correct number of regulators.
>> It you think that it is redundant, i can remove it.
>
> If you really need to have platform data for all the regulators then
> just embed the array inside the platform data so there's no possibility
> of any confusion.
>
Some regulators will not be exported to kernel depending on boards which are
for special usage. So i do not use a array inside the platform data.

>> > With deferred probing you should just be able to use
>> > module_platform_driver().
>
>> The regulator controlles some BUCK regulators.
>> These regulators may be used by application CPU or CP(communication
>> CPU) for telephony.
>> The CP may need different voltages if it goes deep initialization. if
>> we defer the setting later, it is too late for
>> CP initialization, and will impact the performance.
>
> If your kernel startup is taking long enough for this to be an issue it
> seems like there's much bigger problems here and things are going to be
> very fragile anyway, it's going to be better to figure out what the root
> issue is.
I see. I will use module_platform_driver
