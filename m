Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaKYQ7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:59:23 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:53357 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaKYQ7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:59:22 -0500
Message-ID: <5474B564.9080902@roeck-us.net>
Date: Tue, 25 Nov 2014 08:59:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>
Subject: Re: [PATCH 1/5] hwmon: ina2xx: bail-out from ina2xx_probe() in case
 of configuration errors
References: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>	<1416930423-12179-2-git-send-email-bgolaszewski@baylibre.com>	<5474A72D.2000309@roeck-us.net> <CAMpxmJUrs-3oXwYyNh26EnuZRH9bpXrmBBLKM7tmKGx=gSwyuQ@mail.gmail.com>
In-Reply-To: <CAMpxmJUrs-3oXwYyNh26EnuZRH9bpXrmBBLKM7tmKGx=gSwyuQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.5474B569.0158,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 11/25/2014 08:25 AM, Bartosz Golaszewski wrote:
> 2014-11-25 16:58 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
>> You are introducing those two functions with the same code just to display
>> a different error message. That does not provide enough value to have extra
>> functions and just increases code size.
>>
>> Just check the return code from ina2xx_write_register directly in the probe
>> function and bail out there.
>
> With all six patches from this set applied, each of the two functions
> is called twice in the code. Together with the return value checks and
> repeated error messages it bloats the code even more. What about a
> single function taking the name of the register (in our case
> "configuration" or "calibration") as argument in order to print a nice
> error message? If this is still too dirty, than we can just print the
> hex value of the register.
>
> Bart
>

static int ina2xx_write_register(const struct i2c_client *client,
+						u8 reg, u16 value)
+{
+	return i2c_smbus_write_word_swapped(client, reg, value);
+}

Don't tell me that makes any sense. We don't introduce new functions
just to introduce new functions.

The new functions _might_ make a bit more sense if you would
implement the necessary calculations in the functions, but you are
not doing that. Instead, in the next patch, you introduce yet
another function to do the calibration calculation, just to add it
as parameter to the actual calibration function whenever you call it.
To me that is just adding unnecessary code, and I won't accept it.

The following applies to the entire series.

- I don't accept unnecessary ( ).
- I don't accept unnecessary typecasts.
- If you don't accept negative values, use kstrtoul().
- kstrtol can at least in theory return other errors besides -EINVAL.
- Locking should be done in the calling code. It is not needed during
   probe and more appropriate in set functions.
- Any reason for selecting "rshunt" as sysfs attribute name instead
   of, say, shunt-resistor or maybe shunt_resistor ?
- Returning -ENODEV from a set function doesn't make much sense.
- We don't overwrite error codes except in probe functions.

Thanks,
Guenter

