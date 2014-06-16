Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaFPCNY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 22:13:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:57340 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbaFPCNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 22:13:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,482,1400050800"; 
   d="scan'208";a="445829640"
Message-ID: <539E528B.90908@intel.com>
Date: Mon, 16 Jun 2014 10:12:27 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: rjw@rjwysocki.net, lenb@kernel.org, naszar@ya.ru,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/Battery: Retry to get Battery information if failed
 during probing
References: <1402552946-14704-1-git-send-email-tianyu.lan@intel.com> <alpine.DEB.2.02.1406112354070.23724@chino.kir.corp.google.com> <53995488.20308@intel.com> <alpine.DEB.2.02.1406120025050.23724@chino.kir.corp.google.com> <53996152.2000407@intel.com> <alpine.DEB.2.02.1406121415150.8305@chino.kir.corp.google.com> <539A60FC.1050301@intel.com> <alpine.DEB.2.02.1406131445130.31981@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406131445130.31981@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年06月14日 05:46, David Rientjes wrote:
> On Fri, 13 Jun 2014, Lan Tianyu wrote:
> 
>> How about this?
>>
>> -       result = acpi_battery_update(battery, false);
>> -       if (result)
>> +
>> +       /*
>> +        * Some machines'(E,G Lenovo Z480) ECs are not stable
>> +        * during boot up and this causes battery driver fails to be
>> +        * probed due to failure of getting battery information
>> +        * from EC sometimes. After several retries, the operation
>> +        * may work. So add retry code here and 20ms sleep between
>> +        * every retries.
>> +        */
>> +       while (acpi_battery_update(battery, false) && retry--)
>> +               msleep(20);
>> +       if (!retry) {
>> +               result = -ENODEV;
>>                 goto fail;
>> +       }
>> +
> 
> I think you want --retry and not retry--.

My original purpose is to retry 5 times after the first try fails.
If use "--retry" here, it just retries 4 times.

>  Otherwise it's possible for the 
> final call to acpi_battery_update() to succeed and now it's returning 
> -ENODEV.
> 

Yes, it maybe and I will change code like the following.

while ((result = acpi_battery_update(battery, false)) && retry--)
       msleep(20);
if (result)
       goto fail;


-- 
Best regards
Tianyu Lan
