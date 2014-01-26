Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaAZUoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 15:44:39 -0500
Received: from mail.active-venture.com ([67.228.131.205]:56570 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaAZUoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 15:44:38 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52E573B6.9040903@roeck-us.net>
Date: Sun, 26 Jan 2014 12:44:38 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: LM Sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Wei Ni <wni@nvidia.com>
Subject: Re: lm90 driver no longer working on PCs in 3.13
References: <52E561D0.4040308@roeck-us.net> <20140126211357.6fa68909@endymion.delvare>
In-Reply-To: <20140126211357.6fa68909@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On 01/26/2014 12:13 PM, Jean Delvare wrote:
> Hi Guenter,
>
> Adding Wei Ni to Cc, as he provided the commit which causes problem.
>
> On Sun, 26 Jan 2014 11:28:16 -0800, Guenter Roeck wrote:
>> Hi,
>>
>> the lm90 driver is no longer working on PCs with the 3.13 kernel ... or at least not without
>> special configuration.
>>
>> This is what I get if I try to instantiate a device on it (max6695):
>>
>> i2c 1-0018: Driver lm90 requests probe deferral
>> i2c i2c-1: new_device: Instantiated device max6695 at 0x18
>>
>> The regulator core always returns -EPROBE_DEFER if the platform does not support devicetree
>> and if the regulator it is looking for does not exist. Since the driver now requires a mandatory
>> regulator (commit 3e0f964f2ad - hwmon: (lm90) Add power control), and the regulator it requests
>> does not exist on a PC, the result is not really surprising. I thought the regulator core would
>> realize that it has to return a dummy regulator, but apparently that is not the case, or I don't
>> know how to configure it.
>>
>> Any idea what I might need to do to get it working ?
>
> Me, I really don't know. I seem to remember I tested Wei's patch set on
> an emulated ADM1032 chip and it was working fine. So maybe it depends
> on the kernel configuration, or something changed on the regulator side
> meanwhile.
>

The regulator code changed with 3.13; the dummy regulator no longer exists,
and the functionality it provided is supposed to be handled automatically.
But that only really works on devicetree based systems and otherwise returns
-EPROBE_DEFER as mentioned above.

Maybe there is some configuration option, or maybe something needs to be
configured from user space. I found neither. In the first case, we should create
a dependency for the LM90 driver; in the latter case, we would have to make sure
that it is well documented (I'd grumble on that, though - it would result in
never ending trouble for us, having to repeatedly explain how this is now
supposed to work).

Another possible fix would be to have the regulator core return -ENODEV
instead of -EPROBE_DEFER on non-dt systems. No idea if this would be acceptable
or even feasible.

Guenter

