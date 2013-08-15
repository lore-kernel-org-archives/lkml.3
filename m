Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab3HOPNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 11:13:35 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44778 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab3HOPNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 11:13:32 -0400
Message-ID: <520CF01D.4020309@arm.com>
Date: Thu, 15 Aug 2013 16:13:33 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v3 03/16] driver/core: cpu: initialize of_node in cpu's
 device struture
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-4-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1804645.BcbkbcfKAA@flatron>
In-Reply-To: <1804645.BcbkbcfKAA@flatron>
X-OriginalArrivalTime: 15 Aug 2013 15:13:27.0953 (UTC) FILETIME=[FE9D7010:01CE99C9]
X-MC-Unique: 113081516133008801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/08/13 12:35, Tomasz Figa wrote:
> Hi Sudeep,
> 
> On Monday 22 of July 2013 12:32:14 Sudeep KarkadaNagesha wrote:
>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> CPUs are also registered as devices but the of_node in these cpu
>> devices are not initialized. Currently different drivers requiring
>> to access cpu device node are parsing the nodes themselves and
>> initialising the of_node in cpu device.
>>
>> The of_node in all the cpu devices needs to be initialized properly
>> and at one place. The best place to update this is CPU subsystem
>> driver when registering the cpu devices.
>>
>> The OF/DT core library now provides of_get_cpu_node to retrieve a cpu
>> device node for a given logical index by abstracting the architecture
>> specific details.
>>
>> This patch uses of_get_cpu_node to assign of_node when registering the
>> cpu devices.
>>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Acked-by: Rob Herring <rob.herring@calxeda.com>
>> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>> ---
>>  drivers/base/cpu.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
>> index 4c358bc..ea51c6d 100644
>> --- a/drivers/base/cpu.c
>> +++ b/drivers/base/cpu.c
>> @@ -14,6 +14,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/percpu.h>
>>  #include <linux/acpi.h>
>> +#include <linux/of.h>
>>
>>  #include "base.h"
>>
>> @@ -289,6 +290,7 @@ int register_cpu(struct cpu *cpu, int num)
>>  	cpu->dev.release = cpu_device_release;
>>  	cpu->dev.offline_disabled = !cpu->hotpluggable;
>>  	cpu->dev.offline = !cpu_online(num);
>> +	cpu->dev.of_node = of_get_cpu_node(num);
> 
> Aha, so this would be the only place where of_get_cpu_node() gets called, 
> so the parsing would be done only once and then any code that needs CPU DT 
> node would just simply grab it from CPU dev. Fair enough.
> 
> Not sure if this makes the need for such helper to be globally available 
> in of/base.c, but I guess this won't hurt.
> 
Ah, you found it out yourself. Sorry responded to your earlier mail.
Yes but there may be uses cases which need cpu of_node before CPUs get
registered. I believe PATCH 4-6 in the series is good examples as why we
need this helper to be global.

Move over now we need to extend support to PowerPC where DT is scanned
needlessly always to fetch cpu of_node. Of course they need to fix it,
use cpu->of_node instead.

Regards,
Sudeep


