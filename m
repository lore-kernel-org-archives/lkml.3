Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaFPCoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 22:44:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:8227 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbaFPCof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 22:44:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,483,1400050800"; 
   d="scan'208";a="555988744"
Message-ID: <539E59D3.7080508@intel.com>
Date: Mon, 16 Jun 2014 10:43:31 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Zheng, Lv" <lv.zheng@intel.com>
CC: David Rientjes <rientjes@google.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>, "naszar@ya.ru" <naszar@ya.ru>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI/Battery: Retry to get Battery information if failed
 during probing
References: <1402552946-14704-1-git-send-email-tianyu.lan@intel.com> <alpine.DEB.2.02.1406112354070.23724@chino.kir.corp.google.com> <53995488.20308@intel.com> <alpine.DEB.2.02.1406120025050.23724@chino.kir.corp.google.com> <53996152.2000407@intel.com> <alpine.DEB.2.02.1406121415150.8305@chino.kir.corp.google.com> <539A60FC.1050301@intel.com> <alpine.DEB.2.02.1406131445130.31981@chino.kir.corp.google.com> <539E528B.90908@intel.com> <1AE640813FDE7649BE1B193DEA596E880262DA59@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E880262DA59@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年06月16日 10:35, Zheng, Lv wrote:
> Hi,
> 
>> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Lan Tianyu
>> Sent: Monday, June 16, 2014 10:12 AM
>> To: David Rientjes
>> Cc: rjw@rjwysocki.net; lenb@kernel.org; naszar@ya.ru; linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] ACPI/Battery: Retry to get Battery information if failed during probing
>>
>> On 2014年06月14日 05:46, David Rientjes wrote:
>>> On Fri, 13 Jun 2014, Lan Tianyu wrote:
>>>
>>>> How about this?
>>>>
>>>> -       result = acpi_battery_update(battery, false);
>>>> -       if (result)
>>>> +
>>>> +       /*
>>>> +        * Some machines'(E,G Lenovo Z480) ECs are not stable
> 
> Just a reminder.
> 
> This statement may not be true.
> The issue may be caused by the EC driver itself.
> So we need to investigate.

Not sure. The bug doesn't happen every time. 5-10% during boot up.

> 
>>>> +        * during boot up and this causes battery driver fails to be
>>>> +        * probed due to failure of getting battery information
>>>> +        * from EC sometimes. After several retries, the operation
>>>> +        * may work. So add retry code here and 20ms sleep between
>>>> +        * every retries.
>>>> +        */
>>>> +       while (acpi_battery_update(battery, false) && retry--)
> 
> If EC hardware is stable, why we need to do retry here?
> 

Yes, if it can work normally every time, we don't need retry here.


> Thanks and best regards
> -Lv
> 
>>>> +               msleep(20);
>>>> +       if (!retry) {
>>>> +               result = -ENODEV;
>>>>                 goto fail;
>>>> +       }
>>>> +
>>>
>>> I think you want --retry and not retry--.
>>
>> My original purpose is to retry 5 times after the first try fails.
>> If use "--retry" here, it just retries 4 times.
>>
>>>  Otherwise it's possible for the
>>> final call to acpi_battery_update() to succeed and now it's returning
>>> -ENODEV.
>>>
>>
>> Yes, it maybe and I will change code like the following.
>>
>> while ((result = acpi_battery_update(battery, false)) && retry--)
>>        msleep(20);
>> if (result)
>>        goto fail;
>>
>>
>> --
>> Best regards
>> Tianyu Lan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Best regards
Tianyu Lan
