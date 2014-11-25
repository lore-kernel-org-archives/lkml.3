Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaKYR7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:59:16 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:60921 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaKYR7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:59:14 -0500
Message-ID: <5474C36C.1020004@roeck-us.net>
Date: Tue, 25 Nov 2014 09:59:08 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>
Subject: Re: [PATCH 1/5] hwmon: ina2xx: bail-out from ina2xx_probe() in case
 of configuration errors
References: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>	<1416930423-12179-2-git-send-email-bgolaszewski@baylibre.com>	<5474A72D.2000309@roeck-us.net>	<CAMpxmJUrs-3oXwYyNh26EnuZRH9bpXrmBBLKM7tmKGx=gSwyuQ@mail.gmail.com>	<5474B564.9080902@roeck-us.net> <CAMpxmJVGE444t3gE-=u8kuK_B9rJ=0fw9ZYVuYgQRPdswiPj7Q@mail.gmail.com>
In-Reply-To: <CAMpxmJVGE444t3gE-=u8kuK_B9rJ=0fw9ZYVuYgQRPdswiPj7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.5474C371.0325,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 09:50 AM, Bartosz Golaszewski wrote:
> 2014-11-25 17:59 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
>> The new functions _might_ make a bit more sense if you would
>> implement the necessary calculations in the functions, but you are
>> not doing that. Instead, in the next patch, you introduce yet
>> another function to do the calibration calculation, just to add it
>> as parameter to the actual calibration function whenever you call it.
>
> This wasn't my intention, but I'll keep that in mind for the next version.
>
>> - I don't accept unnecessary ( ).
>> - I don't accept unnecessary typecasts.
>> - If you don't accept negative values, use kstrtoul().
>> - kstrtol can at least in theory return other errors besides -EINVAL.
>
> I'll fix those in the next version.
>
>> - Locking should be done in the calling code. It is not needed during
>>    probe and more appropriate in set functions.
>
> I don't use locks in probe - they're used directly in
> ina2xx_set_value() or indirectly in ina226_update_avg(), but these
> functions are never called from probe.
>
>> - Any reason for selecting "rshunt" as sysfs attribute name instead
>>    of, say, shunt-resistor or maybe shunt_resistor ?
>
> I'll change it to shunt_resistor for more readability.
>
>> - Returning -ENODEV from a set function doesn't make much sense.
>
> It does make sense in case of ACME (http://baylibre.com/acme/) - a
> probe can be disconnected at run-time, which, even without these
> patches, would cause ina2xx_update_device() to error out when called
> by ina2xx_show_value():
>

It seems to me this is a problem of your architecture. That doesn't
make it a generic problem. Your architecture should detect that a
probe was disconnected and de-instantiate the device automatically
if so, and re-instantiate it if it is re-inserted. Ultimately this
should be done with, for example, devicetree overlays.

Even worse, the remove/reinsertion sequence results in a non-initialized
chip.

This makes me wonder: Is the shunt resistor value set by software,
or by replacing one probe with another ?

Guenter

> 231                         int rv = i2c_smbus_read_word_swapped(client, i);
> 232                         if (rv < 0) {
> 233                                 ret = ERR_PTR(rv);
> 234                                 goto abort;
>
> I just reproduced this behavior in ina2xx_set_value().
>
>> - We don't overwrite error codes except in probe functions.
>
> I'll fix that too.
>
> Bart
>

