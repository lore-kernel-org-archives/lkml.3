Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaLXGKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 01:10:19 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:55513 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaLXGKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 01:10:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpo=Xm6sSqVtNaL=ycJ=mbFW0n6zddcu5pawDL3F10SaTEw@mail.gmail.com>
References: <1419379901-17182-1-git-send-email-dianders@chromium.org>
	<CAKohpo=Xm6sSqVtNaL=ycJ=mbFW0n6zddcu5pawDL3F10SaTEw@mail.gmail.com>
Date: Tue, 23 Dec 2014 22:10:15 -0800
X-Google-Sender-Auth: o7XT7OhMlxChh0SnLe7eMDPypSw
Message-ID: <CAD=FV=V4TBDiWX=PfgZcXUW7K-s_be7HRCgFMwmSVaY_PsgZbw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: suspend cpufreq governors on shutdown
From: Doug Anderson <dianders@chromium.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Heiko Stuebner <heiko@sntech.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Zhong <zyw@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sonny Rao <sonnyrao@chromium.org>, Dylan Reid <dgreid@chromium.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Virseh,


On Tue, Dec 23, 2014 at 5:46 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 24 December 2014 at 05:41, Doug Anderson <dianders@chromium.org> wrote:
>> We should stop cpufreq governors when we shut down the system.  If we
>> don't do this, we can end up with this deadlock:
>
> Can you also add what exactly happens in such deadlock? Some lockdeps?
> Or just a hang ?

It only fails 1 in ~50 calls to halt.

When it fails, most times I get a hang.  Sometimes I actually got a hard lockup:

[   23.511813] reboot: Power down
[   40.418425] Kernel panic - not syncing: Watchdog detected hard
LOCKUP on cpu 1

I'm slightly amazed that the hard lockup detector even fired (and I'm
not sure why it sometimes doesn't fire).  ...when I use kdb to get a
trace at this point:

Stack traceback for pid 6564
0xecd2ee00     6564        1  0    0   D  0xecd2f1e8  halt
[<c065ab64>] (__schedule) from [<c065ae9c>] (schedule+0xa4/0xa8)
[<c065ae9c>] (schedule) from [<c065b21c>] (schedule_preempt_disabled+0x18/0x1c)
[<c065b21c>] (schedule_preempt_disabled) from [<c065bfe8>]
(mutex_lock_nested+0x294/0x3e4)
[<c065bfe8>] (mutex_lock_nested) from [<c041c0d0>] (regmap_lock_mutex+0x1c/0x20)
[<c041c0d0>] (regmap_lock_mutex) from [<c041e618>]
(regmap_update_bits+0x34/0x6c)
[<c041e618>] (regmap_update_bits) from [<c042a9bc>]
(rk808_device_shutdown+0x54/0x7c)
[<c042a9bc>] (rk808_device_shutdown) from [<c01070b8>]
(machine_power_off+0x34/0x3c)
[<c01070b8>] (machine_power_off) from [<c0147168>] (kernel_power_off+0x68/0x7c)
[<c0147168>] (kernel_power_off) from [<c0147360>] (SyS_reboot+0x154/0x1fc)
[<c0147360>] (SyS_reboot) from [<c01062a0>] (ret_fast_syscall+0x0/0x48)


I'm not used to using lockdep.  Trying now.  OK, no lockdep warning.

I'm relatively confident that I understand the problem because I added
a bunch of other debug info.  You can see my patch at
<https://chromium-review.googlesource.com/#/c/237455/>.  In the case I
captured I confirmed that I was stopping CPU1 while it held the mutex.


>> 1. cpufreq governor may be running on a CPU other than CPU0.
>> 2. In machine_restart() we call smp_send_stop() which stops CPUs.
>>    If one of these CPUs was actively running a cpufreq governor
>>    then it may have the mutex / spinlock needed to access the main
>>    PMIC in the system (perhaps over I2C)
>> 3. If a machine needs access to the main PMIC in order to shutdown
>>    then it will never get it since the mutex was lost when the other
>>    CPU stopped.
>>
>> Let's avoid the race by stopping the cpufreq governor at shutdown,
>> which is a sensible thing to do anyway.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>> NOTE: This was developed / tested / on a 3.14 kernel with backports.
>> I have confirmed that it compiles on a mainline kernel and doesn't
>> crash, but I haven't verified that there isn't some other fix in
>> mainline that also fixes this problem.  If you are aware of such a fix
>> then please drop this patch.
>
> No, its a new problem.

OK, good to know.


>>  drivers/cpufreq/cpufreq.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index a09a29c..bd89721 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -27,6 +27,7 @@
>>  #include <linux/mutex.h>
>>  #include <linux/slab.h>
>>  #include <linux/suspend.h>
>> +#include <linux/syscore_ops.h>
>>  #include <linux/tick.h>
>>  #include <trace/events/power.h>
>>
>> @@ -2550,6 +2551,15 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
>>  }
>>  EXPORT_SYMBOL_GPL(cpufreq_unregister_driver);
>>
>> +static void cpufreq_shutdown(void)
>> +{
>> +       cpufreq_suspend();
>> +}
>> +
>> +static struct syscore_ops cpufreq_syscore_ops = {
>> +       .shutdown = cpufreq_shutdown,
>
> directly pass cpufreq_suspend() here and add a note over the
> cpufreq_syscore_ops on why it exists here.

Done.
