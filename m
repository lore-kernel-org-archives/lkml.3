Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3ILSIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:08:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59680 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3ILSIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:08:10 -0400
Message-ID: <52320304.306@wwwdotorg.org>
Date: Thu, 12 Sep 2013 12:08:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] cpufreq: use correct values of cpus in __cpufreq_remove_dev_finish()
References: <cover.1378963070.git.viresh.kumar@linaro.org> <8f777cc6b41b2fed4bf71ce2adc36800353d5738.1378963070.git.viresh.kumar@linaro.org> <523161D1.9040005@linux.vnet.ibm.com> <CAKohpomz-EDbRNqv58zn6B+kC1jdjrxx68hoDrAj==+YbeTj=g@mail.gmail.com> <CAKohpomCXoO20cQyCrWtN0WgWnzvVmEqFxuwTU8V0GpXsQxgHw@mail.gmail.com> <52316A40.4050600@linux.vnet.ibm.com> <CAKohponzohnOL4Y81Q1W4Yg=paRO46c-gY=HMbkFUqgrjsT+xw@mail.gmail.com>
In-Reply-To: <CAKohponzohnOL4Y81Q1W4Yg=paRO46c-gY=HMbkFUqgrjsT+xw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 03:21 AM, Viresh Kumar wrote:
> On 12 September 2013 12:46, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> That sounds good! Even the naming is much better, it conveys the intent
>> clearly.
> 
> Folded below change in my patch (attached):
...

For the record, the patch which was attached to Viresh's email solves
the hangs I was getting in next-20130912 during (the second?) CPU
hotplug and resume. So,

Tested-by: Stephen Warren <swarren@nvidia.com>

Without this, I saw:

> root@localhost:~# ./cpuonline.py 
> echo 0 > /sys/devices/system/cpu/cpu1/online
> [   24.049729] CPU1: shutdown
> echo 1 > /sys/devices/system/cpu/cpu1/online
> [   26.090439] CPU1: Booted secondary processor
> root@localhost:~# ./cpuonline.py 
> echo 0 > /sys/devices/system/cpu/cpu1/online
> [   29.003016] CPU1: shutdown
> echo 1 > /sys/devices/system/cpu/cpu1/online
> [   31.032562] CPU1: Booted secondary processor
[hung]
> [  240.300393] INFO: task ondemand:678 blocked for more than 120 seconds.
> [  240.312842] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  240.326658] ondemand        D c050f6cc     0   678      1 0x00000000
> [  240.339062] [<c050f6cc>] (__schedule+0x330/0x6d0) from [<c050fe50>] (schedule_preempt_disabled+0x24/0x34)
> [  240.354904] [<c050fe50>] (schedule_preempt_disabled+0x24/0x34) from [<c050e810>] (__mutex_lock_slowpath+0x178/0x370)
> [  240.371767] [<c050e810>] (__mutex_lock_slowpath+0x178/0x370) from [<c050ea14>] (mutex_lock+0xc/0x24)
> [  240.387363] [<c050ea14>] (mutex_lock+0xc/0x24) from [<c00245e8>] (get_online_cpus+0x2c/0x48)
> [  240.402273] [<c00245e8>] (get_online_cpus+0x2c/0x48) from [<c0342c0c>] (store+0x18/0xbc)
> [  240.417688] [<c0342c0c>] (store+0x18/0xbc) from [<c011d598>] (sysfs_write_file+0x168/0x198)
> [  240.432687] [<c011d598>] (sysfs_write_file+0x168/0x198) from [<c00cbf98>] (vfs_write+0xb0/0x188)
> [  240.448185] [<c00cbf98>] (vfs_write+0xb0/0x188) from [<c00cc348>] (SyS_write+0x3c/0x70)
> [  240.462964] [<c00cc348>] (SyS_write+0x3c/0x70) from [<c000e540>] (ret_fast_syscall+0x0/0x30)
> [  240.478239] INFO: task sh:827 blocked for more than 120 seconds.
> [  240.491027] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  240.505795] sh              D c050f6cc     0   827    825 0x00000001
> [  240.519169] [<c050f6cc>] (__schedule+0x330/0x6d0) from [<c0510660>] (__down_write_nested+0x78/0xcc)
> [  240.535666] [<c0510660>] (__down_write_nested+0x78/0xcc) from [<c0342ae0>] (lock_policy_rwsem_write+0x34/0x48)
> [  240.552950] [<c0342ae0>] (lock_policy_rwsem_write+0x34/0x48) from [<c0343a04>] (cpufreq_update_policy+0x20/0xec)
> [  240.570631] [<c0343a04>] (cpufreq_update_policy+0x20/0xec) from [<c0344410>] (cpufreq_cpu_callback+0x78/0x8c)
> [  240.588051] [<c0344410>] (cpufreq_cpu_callback+0x78/0x8c) from [<c0042f44>] (notifier_call_chain+0x44/0x84)
> [  240.605401] [<c0042f44>] (notifier_call_chain+0x44/0x84) from [<c0024594>] (__cpu_notify+0x28/0x44)
> [  240.622085] [<c0024594>] (__cpu_notify+0x28/0x44) from [<c00247fc>] (_cpu_up+0x100/0x154)
> [  240.638006] [<c00247fc>] (_cpu_up+0x100/0x154) from [<c00248c4>] (cpu_up+0x5c/0x84)
> [  240.653405] [<c00248c4>] (cpu_up+0x5c/0x84) from [<c028a2a8>] (device_online+0x64/0x88)
> [  240.669263] [<c028a2a8>] (device_online+0x64/0x88) from [<c028a328>] (store_online+0x5c/0x64)
> [  240.685683] [<c028a328>] (store_online+0x5c/0x64) from [<c028816c>] (dev_attr_store+0x18/0x24)
> [  240.702337] [<c028816c>] (dev_attr_store+0x18/0x24) from [<c011d598>] (sysfs_write_file+0x168/0x198)
> [  240.719520] [<c011d598>] (sysfs_write_file+0x168/0x198) from [<c00cbf98>] (vfs_write+0xb0/0x188)
> [  240.736614] [<c00cbf98>] (vfs_write+0xb0/0x188) from [<c00cc348>] (SyS_write+0x3c/0x70)
> [  240.752799] [<c00cc348>] (SyS_write+0x3c/0x70) from [<c000e540>] (ret_fast_syscall+0x0/0x30)

