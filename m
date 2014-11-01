Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760471AbaKAVPa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 17:15:30 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:35805 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469AbaKAVP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 17:15:28 -0400
Message-ID: <54554D6D.5090509@roeck-us.net>
Date: Sat, 01 Nov 2014 14:15:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Neelesh Gupta <neelegup@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
CC: jdelvare@suse.de, lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hwmon: (ibmpowernv) Quieten when probing finds no
 device
References: <1414737923-8227-1-git-send-email-mpe@ellerman.id.au> <20141031181239.GA9776@roeck-us.net> <54551CDB.2090407@linux.vnet.ibm.com>
In-Reply-To: <54551CDB.2090407@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54554D70.0007,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
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

On 11/01/2014 10:48 AM, Neelesh Gupta wrote:
>
> On 10/31/2014 11:42 PM, Guenter Roeck wrote:
>> On Fri, Oct 31, 2014 at 05:45:22PM +1100, Michael Ellerman wrote:
>>> Because we build kernels with drivers built in for many platforms, it's
>>> normal for the ibmpowernv driver to be loaded on systems that don't have
>>> the appropriate hardware.
>>>
>>> Currently the driver spams the log with:
>>>
>>>    ibmpowernv ibmpowernv.0: Opal node 'sensors' not found
>>>    ibmpowernv: Platfrom driver probe failed
>>>
>>> But there is no error, this machine is not a powernv and doesn't have
>>> the hardware. So change the sensors message to dev_dbg(), and only print
>>> an error about the probe failing if it's not ENODEV.
>>>
>>> Also fix the spelling of "Platfrom" and print the actual error value.
>>>
>>> Signed-off-by: Michael Ellerman<mpe@ellerman.id.au>
>> Neelesh,
>>
>> is there a compatible property in the powernv devicetree which can be
>> used to identify the system ?
>
> I think the driver should not be loaded at first place on *non* powernv platforms.
> Still, we can improve by introducing 'platform_driver.id_table' and moving the
> platform device creation code in platform init 'opal-sensor.c' using
> of_platform_device_create() and just do driver register in module init.
>

Ok with me.

Can you write a patch doing that ?

Thanks,
Guenter

> - Neelesh
>
>>
>> I am ok with applying this patch for the time being, but it would be better
>> if we can change the driver to only instantiate when actually needed.
>>
>> Thanks,
>> Guenter
>>
>>> ---
>>>   drivers/hwmon/ibmpowernv.c | 6 ++++--
>>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/hwmon/ibmpowernv.c b/drivers/hwmon/ibmpowernv.c
>>> index d2bf2c97ae70..6a30eeea94be 100644
>>> --- a/drivers/hwmon/ibmpowernv.c
>>> +++ b/drivers/hwmon/ibmpowernv.c
>>> @@ -181,7 +181,7 @@ static int __init populate_attr_groups(struct platform_device *pdev)
>>>
>>>   	opal = of_find_node_by_path("/ibm,opal/sensors");
>>>   	if (!opal) {
>>> -		dev_err(&pdev->dev, "Opal node 'sensors' not found\n");
>>> +		dev_dbg(&pdev->dev, "Opal node 'sensors' not found\n");
>>>   		return -ENODEV;
>>>   	}
>>>
>>> @@ -335,7 +335,9 @@ static int __init ibmpowernv_init(void)
>>>
>>>   	err = platform_driver_probe(&ibmpowernv_driver, ibmpowernv_probe);
>>>   	if (err) {
>>> -		pr_err("Platfrom driver probe failed\n");
>>> +		if (err != -ENODEV)
>>> +			pr_err("Platform driver probe failed (%d)\n", err);
>>> +
>>>   		goto exit_device_del;
>>>   	}
>>>
>>> --
>>> 1.9.1
>>>
>

