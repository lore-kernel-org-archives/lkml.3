Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaJ1Aqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:46:31 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48686 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbaJ1Aqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:46:30 -0400
MIME-Version: 1.0
In-Reply-To: <544EBB70.6020507@intel.com>
References: <1414378748-8855-1-git-send-email-zhangwm@marvell.com> <544EBB70.6020507@intel.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Mon, 27 Oct 2014 20:46:08 -0400
X-Google-Sender-Auth: 5AMQpinm8ibjqOQaFgM8f4GDeVE
Message-ID: <CALZtONCkQVeau8JETKtxuQsoGnVymKPOgwvcidHH=EFVmhKc5g@mail.gmail.com>
Subject: Re: [PATCH V2] Driver cpu: update online when cpu_up/down besides sysfs
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Neil Zhang <zhangwm@marvell.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, nfont@linux.vnet.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 5:38 PM, Rafael J. Wysocki
<rafael.j.wysocki@intel.com> wrote:
> On 10/27/2014 3:59 AM, Neil Zhang wrote:
>>
>> The current per-cpu offline info won't be updated when we use
>> any other method besides sysfs to call cpu_up/down.
>> Thus the cpu/online can't reflect the real online status.
>>
>> This patch is going to fix the issue introduced by commit
>> 0902a9044fa5b7a0456ea4daacec2c2b3189ba8c (Driver core:
>> Use generic offline/online for CPU offline/online)
>>
>> CC: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Tested-by: Dan Streetman <ddstreet@ieee.org>
>> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
>
>
> Oh dear, no.
>
> Please first tell me what exactly the problem you're seeing is.

For some background, here is my last comment on the first email thread on this:
https://lkml.org/lkml/2014/10/27/595

I didn't create this patch, but the problem essentially is that before
your commit the individual cpu online nodes
(/sys/devices/system/cpu/cpuN/online) stayed in sync during
cpu_down/up, because they used the cpu_online_mask; while after the
commit, they are tracked by the cpu's generic dev->offline flag, which
isn't updated during cpu_down/up.  So now, any place in the kernel
that brings a cpu up or down must also update the cpu->dev->offline
flag.  My interest in the patch was coincidental because I was seeing
the same problem when using dlpar operations to hotplug cpus, which
uses the arch/powerpc/platform/pseries/dlpar.c code; that code brings
a cpu offline when it's hot-removed (and the cpu online when it's
hot-added), but it hasn't been changed to also update the cpu's
dev->offline flag.

As I said in the previous email to the first thread, the ppc dlpar
operation might be changed in the future to fully unregister a cpu
when it's hot-removed, which would remove the entire sysfs cpuN
directory.  Alternately and/or until then, it could be updated to
simply update the cpu'd dev->offline flag (that's what I originally
did for my own testing).  However, without a central place to update
the cpu's dev->offline field, like this, or possibly in
set_cpu_online(), or elsewhere during cpu_down/up, each place in the
kernel that calls cpu_down() or cpu_up() also needs to update the
dev->offline flag.  It's possible that the ppc dlpar code is the only
place in the kernel that has this problem; I haven't searched.

>
>
>> ---
>>   drivers/base/cpu.c |   25 +++++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>
>> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
>> index 006b1bc..9d61824 100644
>> --- a/drivers/base/cpu.c
>> +++ b/drivers/base/cpu.c
>> @@ -418,10 +418,35 @@ static void __init cpu_dev_register_generic(void)
>>   #endif
>>   }
>>   +static int device_hotplug_notifier(struct notifier_block *nfb,
>> +                                     unsigned long action, void *hcpu)
>> +{
>> +       unsigned int cpu = (unsigned long)hcpu;
>> +       struct device *dev = get_cpu_device(cpu);
>> +       int ret;
>> +
>> +       switch (action & ~CPU_TASKS_FROZEN) {
>> +       case CPU_ONLINE:
>> +               dev->offline = false;
>> +               ret = NOTIFY_OK;
>> +               break;
>> +       case CPU_DYING:
>> +               dev->offline = true;
>> +               ret = NOTIFY_OK;
>> +               break;
>> +       default:
>> +               ret = NOTIFY_DONE;
>> +               break;
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>>   void __init cpu_dev_init(void)
>>   {
>>         if (subsys_system_register(&cpu_subsys, cpu_root_attr_groups))
>>                 panic("Failed to register CPU subsystem");
>>         cpu_dev_register_generic();
>> +       cpu_notifier(device_hotplug_notifier, 0);
>>   }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
