Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967760Ab3DSBRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 21:17:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55974 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967266Ab3DSBRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 21:17:45 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51709B0D.9000900@jp.fujitsu.com>
Date: Fri, 19 Apr 2013 10:17:01 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [Bug fix PATCH] numa, cpu hotplug: Change links of CPU and node
 when changing node number by onlining CPU
References: <516FA0B9.8080308@jp.fujitsu.com> <CAHGf_=qcV=R_O5fpjpRQh5Tu9=nz1jVR9r=55fYODds8TQm7vw@mail.gmail.com>
In-Reply-To: <CAHGf_=qcV=R_O5fpjpRQh5Tu9=nz1jVR9r=55fYODds8TQm7vw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/04/19 1:32, KOSAKI Motohiro wrote:
>>   #ifdef CONFIG_HOTPLUG_CPU
>> +static void change_cpu_under_node(struct cpu *cpu,
>> +                       unsigned int from_nid, unsigned int to_nid)
>> +{
>> +       int cpuid = cpu->dev.id;
>> +       unregister_cpu_under_node(cpuid, from_nid);
>> +       register_cpu_under_node(cpuid, to_nid);
>> +       cpu->node_id = to_nid;
>> +}
>> +
>

> Where is stub for !CONFIG_HOTPLUG_CPU?

This function is called by only store_online(). And the store_online() is
defined only when CONFIG_HOTPLUG_CPU enables. Thus change_cpu_under_node()
is not necessary for !CONFIG_HOTPLUG_CPU.

>
>
>>   static ssize_t show_online(struct device *dev,
>>                             struct device_attribute *attr,
>>                             char *buf)
>> @@ -39,17 +48,23 @@ static ssize_t __ref store_online(struct device *dev,
>>                                    const char *buf, size_t count)
>>   {
>>          struct cpu *cpu = container_of(dev, struct cpu, dev);
>> +       int num = cpu->dev.id;
>

> "num" is wrong name. cpuid may be better.

I'll update it.

>
>
>> +       int from_nid, to_nid;
>>          ssize_t ret;
>>
>>          cpu_hotplug_driver_lock();
>>          switch (buf[0]) {
>>          case '0':
>> -               ret = cpu_down(cpu->dev.id);
>> +               ret = cpu_down(num);
>>                  if (!ret)
>>                          kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
>>                  break;
>>          case '1':
>> -               ret = cpu_up(cpu->dev.id);
>> +               from_nid = cpu_to_node(num);
>> +               ret = cpu_up(num);
>> +               to_nid = cpu_to_node(num);
>> +               if (from_nid != to_nid)
>> +                       change_cpu_under_node(cpu, from_nid, to_nid);
>
> You need to add several comments. this code is not straightforward.

O.K. I'll update it.

Thanks,
Yasuaki Ishimatsu


