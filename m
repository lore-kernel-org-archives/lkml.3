Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaAFJ5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:57:55 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:51429 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbaAFJ5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:57:52 -0500
MIME-Version: 1.0
In-Reply-To: <87iotx32mx.fsf@nemi.mork.no>
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
	<5562479.pVWRuDL0y6@vostro.rjw.lan>
	<87zjne7f75.fsf@nemi.mork.no>
	<2302938.b8tymqrMEz@vostro.rjw.lan>
	<878uuxquxu.fsf@nemi.mork.no>
	<871u0po0gx.fsf@nemi.mork.no>
	<CAKohpo=9p8ArfWyyWkdQm_BWtyWbWe_dsg6VAUP60VUFcAjFSw@mail.gmail.com>
	<87wqihmg9a.fsf@nemi.mork.no>
	<CAKohpo=3s6=gw8OJTrUdLH8o2ouA=8a8MhrgNRXwHmOf0si5Pw@mail.gmail.com>
	<87iotx32mx.fsf@nemi.mork.no>
Date: Mon, 6 Jan 2014 15:27:51 +0530
Message-ID: <CAKohpo=KgHqz0KYv7h0EYP3=8h7T3ZfPpFTMS6qVoEb6dXGnSQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 January 2014 14:31, Bjørn Mork <bjorn@mork.no> wrote:
> That's correct.  I have not observed this on suspend to RAM.  But then
> again I haven't rigged any way to log that, so I don't think it's
> conclusive..
>
> The point I tried to make is that it isn't related to any hibernation
> *failures*.  The warning appears even if the add_dev() is successful,
> and it also appears if I touch only the *boot* cpu cpufreq attributes.

Okay.. But your log below is for add_dev() failure case.

> I.e., this seems to be unrelated to the hotplugging code.
>
> Here's another copy of the warning, captured by cancelling hibernation
> as I don't have any other way to log it at the moment.  But I do see the
> warning appear on the console *before* cancelling.  And I also see this
> warning appear when trying the in-kernel hibernation instead of
> userspace.

How do you cancel hibernation here? Sorry, what is in-kernel hibernation?

> [  267.893084] ======================================================
> [  267.893085] [ INFO: possible circular locking dependency detected ]
> [  267.893087] 3.13.0-rc6+ #183 Tainted: G        W
> [  267.893089] -------------------------------------------------------
> [  267.893090] s2disk/5450 is trying to acquire lock:
> [  267.893101]  (s_active#164){++++.+}, at: [<ffffffff8118b9d7>] sysfs_addrm_finish+0x28/0x46
> [  267.893102]
> [  267.893102] but task is already holding lock:
> [  267.893111]  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81039ff5>] cpu_hotplug_begin+0x28/0x50
> [  267.893112]
> [  267.893112] which lock already depends on the new lock.
> [  267.893112]
> [  267.893113]
> [  267.893113] the existing dependency chain (in reverse order) is:
> [  267.893117]
> [  267.893117] -> #1 (cpu_hotplug.lock){+.+.+.}:
> [  267.893123]        [<ffffffff81075027>] lock_acquire+0xfb/0x144
> [  267.893128]        [<ffffffff8139d4d2>] mutex_lock_nested+0x6c/0x397
> [  267.893132]        [<ffffffff81039f4a>] get_online_cpus+0x3c/0x50
> [  267.893137]        [<ffffffff812a69c4>] store+0x20/0xad
> [  267.893142]        [<ffffffff8118a9a1>] sysfs_write_file+0x138/0x18b
> [  267.893147]        [<ffffffff8112a428>] vfs_write+0x9c/0x102
> [  267.893151]        [<ffffffff8112a716>] SyS_write+0x50/0x85
> [  267.893155]        [<ffffffff813a57a2>] system_call_fastpath+0x16/0x1b
> [  267.893160]
> [  267.893160] -> #0 (s_active#164){++++.+}:
> [  267.893164]        [<ffffffff81074760>] __lock_acquire+0xae3/0xe68
> [  267.893168]        [<ffffffff81075027>] lock_acquire+0xfb/0x144
> [  267.893172]        [<ffffffff8118b027>] sysfs_deactivate+0xa5/0x108
> [  267.893175]        [<ffffffff8118b9d7>] sysfs_addrm_finish+0x28/0x46
> [  267.893178]        [<ffffffff8118bd3f>] sysfs_remove+0x2a/0x31
> [  267.893182]        [<ffffffff8118be2f>] sysfs_remove_dir+0x66/0x6b
> [  267.893186]        [<ffffffff811d5d11>] kobject_del+0x18/0x42
> [  267.893190]        [<ffffffff811d5e1c>] kobject_cleanup+0xe1/0x14f
> [  267.893193]        [<ffffffff811d5ede>] kobject_put+0x45/0x49
> [  267.893197]        [<ffffffff812a6ed5>] cpufreq_policy_put_kobj+0x37/0x83

All above is for case where add dev was required to clear up earlier
allocated policy as something failed during add_dev()

> [  267.893201]        [<ffffffff812a8bfb>] __cpufreq_add_dev.isra.18+0x75e/0x78c
> [  267.893204]        [<ffffffff812a8c89>] cpufreq_cpu_callback+0x53/0x88
> [  267.893208]        [<ffffffff813a314c>] notifier_call_chain+0x67/0x92
> [  267.893213]        [<ffffffff8105bce4>] __raw_notifier_call_chain+0x9/0xb
> [  267.893217]        [<ffffffff81039e7c>] __cpu_notify+0x1b/0x32
> [  267.893221]        [<ffffffff81039ea1>] cpu_notify+0xe/0x10
> [  267.893225]        [<ffffffff8103a12b>] _cpu_up+0xf1/0x124
> [  267.893230]        [<ffffffff8138ee7d>] enable_nonboot_cpus+0x52/0xbf
> [  267.893234]        [<ffffffff8107a2a3>] hibernation_snapshot+0x1be/0x2ed

And this is again the same log as what you have sent last time. It happened
while saving image after disabling all non-boot CPUs. And so it happened for
your case as your driver->init() was failing, so it may not get reproduced at
my end. Haven't tried it though.

> I don't think I do anything extra-ordinary to trigger this, so I would
> be surprised if you can't reproduce it by doing
>
>   export x=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
>   echo $x >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
>   s2disk

I don't see you cancelling hibernation here. Sorry got confused on how
exactly you reproduced it.
