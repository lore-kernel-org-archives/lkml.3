Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaJWFGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 01:06:45 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:56347 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaJWFGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 01:06:44 -0400
Message-ID: <54488CE1.2000106@roeck-us.net>
Date: Wed, 22 Oct 2014 22:06:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: netdev <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] net: dsa: Add support for hardware monitoring
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net> <1414037002-25528-7-git-send-email-linux@roeck-us.net> <CAGVrzcYjPJWai9bxkh+WRrEEAzBKBd-LQm7zDeeouxngr_v9SQ@mail.gmail.com>
In-Reply-To: <CAGVrzcYjPJWai9bxkh+WRrEEAzBKBd-LQm7zDeeouxngr_v9SQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54488CE3.010B,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
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

On 10/22/2014 09:37 PM, Florian Fainelli wrote:
> 2014-10-22 21:03 GMT-07:00 Guenter Roeck <linux@roeck-us.net>:
>> Some Marvell switches provide chip temperature data.
>> Add support for reporting it to the dsa infrastructure.
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
> [snip]
>
>> +/* hwmon support ************************************************************/
>> +
>> +#if defined(CONFIG_HWMON) || (defined(MODULE) && defined(CONFIG_HWMON_MODULE))
>
> IS_ENABLED(CONFIG_HWMON)?
>

Hi Florian,

unfortunately, that won't work; I had it initially and got a nice error message
from Fengguang's build test bot.

Problem is that hwmon can be built as module and the dsa subsystem can be built
into the kernel. In that case, hwmon functionality in the driver must be disabled.
The above condition covers that case. The nouveau graphics driver has the same
problem and uses the same conditional to solve it.

An alternative would be to select HWMON in the NET_DSA Kconfig entry; the
Broadcom Tigon3 driver does that. I just don't know if that is a good idea.
I am open to suggestions.

>> +
>> +static ssize_t temp1_input_show(struct device *dev,
>> +                               struct device_attribute *attr, char *buf)
>> +{
>> +       struct dsa_switch *ds = dev_get_drvdata(dev);
>> +       int temp, ret;
>> +
>> +       ret = ds->drv->get_temp(ds, &temp);
>> +       if (ret < 0)
>> +               return ret;
>> +
>> +       return sprintf(buf, "%d\n", temp * 1000);
>> +}
>> +static DEVICE_ATTR_RO(temp1_input);
>
> You probably want the number of temperature sensors to come from the
> switch driver, and support arbitrary number of temperature sensors?

In that case we would need the number of sensors, pass a sensor index,
and create a dynamic number of attributes. The code would get much more
complex without real benefit unless there is such a chip - and if there is,
we can still change the code at that time. I would prefer to keep it simple
for now.

Thanks,
Guenter

