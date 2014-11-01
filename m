Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbaKARzX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 13:55:23 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47001 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbaKARzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 13:55:21 -0400
Message-ID: <54551E28.8090306@linux.vnet.ibm.com>
Date: Sat, 01 Nov 2014 23:23:44 +0530
From: Neelesh Gupta <neelegup@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hwmon: (ibmpowernv) Quieten when probing finds no
 device
References: <1414737923-8227-1-git-send-email-mpe@ellerman.id.au> <20141031104147.0381619a@endymion.delvare> <54538CEC.3060006@roeck-us.net>
In-Reply-To: <54538CEC.3060006@roeck-us.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110117-0009-0000-0000-0000008AFDBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/31/2014 06:51 PM, Guenter Roeck wrote:
> On 10/31/2014 02:41 AM, Jean Delvare wrote:
>> Hi Michael,
>>
>> On Fri, 31 Oct 2014 17:45:22 +1100, Michael Ellerman wrote:
>>> Because we build kernels with drivers built in for many platforms, it's
>>> normal for the ibmpowernv driver to be loaded on systems that don't 
>>> have
>>> the appropriate hardware.
>>>
>>> Currently the driver spams the log with:
>>>
>>>    ibmpowernv ibmpowernv.0: Opal node 'sensors' not found
>>>    ibmpowernv: Platfrom driver probe failed
>>>
>>> But there is no error, this machine is not a powernv and doesn't have
>>> the hardware. So change the sensors message to dev_dbg(), and only 
>>> print
>>> an error about the probe failing if it's not ENODEV.
>>>
>>> Also fix the spelling of "Platfrom" and print the actual error value.
>>>
>>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>>> ---
>>>   drivers/hwmon/ibmpowernv.c | 6 ++++--
>>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/hwmon/ibmpowernv.c b/drivers/hwmon/ibmpowernv.c
>>> index d2bf2c97ae70..6a30eeea94be 100644
>>> --- a/drivers/hwmon/ibmpowernv.c
>>> +++ b/drivers/hwmon/ibmpowernv.c
>>> @@ -181,7 +181,7 @@ static int __init populate_attr_groups(struct 
>>> platform_device *pdev)
>>>
>>>       opal = of_find_node_by_path("/ibm,opal/sensors");
>>>       if (!opal) {
>>> -        dev_err(&pdev->dev, "Opal node 'sensors' not found\n");
>>> +        dev_dbg(&pdev->dev, "Opal node 'sensors' not found\n");
>>>           return -ENODEV;
>>>       }
>>>
>>> @@ -335,7 +335,9 @@ static int __init ibmpowernv_init(void)
>>>
>>>       err = platform_driver_probe(&ibmpowernv_driver, 
>>> ibmpowernv_probe);
>>>       if (err) {
>>> -        pr_err("Platfrom driver probe failed\n");
>>> +        if (err != -ENODEV)
>>> +            pr_err("Platform driver probe failed (%d)\n", err);
>>>
>>>           goto exit_device_del;
>>>       }
>>>
>>
>> Looks reasonable.
>>
> The reduced noise, ok, but a better fix would be to not attempt to load
> the driver in the first place. This should be doable by introducing an
> of_match_table.

The parent 'sensors' node doesn't have a compatible property, rather 
individual
child sensors have. So, instead we can introduce 
'platform_driver.id_table' for
the probe.

Thanks,
Neelesh

>
> Guenter
>
>> Reviewed-by: Jean Delvare <jdelvare@suse.de>
>>
>

