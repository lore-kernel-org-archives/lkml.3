Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005Ab3HHIKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:10:38 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:4720 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933982Ab3HHIKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:10:34 -0400
Message-ID: <52035270.3010409@huawei.com>
Date: Thu, 8 Aug 2013 16:10:24 +0800
From: "Peter Huang(Peng)" <peter.huangpeng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <linqiangmin@huawei.com>,
        <luonengjun@huawei.com>, Majun <harry.majun@huawei.com>
CC: <oscar.zhangbo@huawei.com>
Subject: Does PVOPS guest os support online "suspend/resume"?
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.68.207]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While suspend and resume a PVOPS guest os while it's running, we found that it
would get its block/net io stucked. However, non-PVOPS guest os has no such
problem.

In non-PVOPS guest os, although they don't have blkfront SUSPEND method either,
their xen-driver doesn't resume blkfront device, thus, they would't have any problem
after suspend/resume.


I'm wondering why the 2 types of driver(PVOPS and non-PVOPS) are different here.
Is that because:
1) PVOPS kernel doesn't take this situation into accont, and has a bug here?
or
2) PVOPS has other ways to avoid such problem?

thank you in advance.

reproduce steps:
-------------------
1/1

Steps to reproduce:
------------------
1)suspend guest os
Note: do not migrate/shutdown the guest os.
2)resume guest os

(Think about rolling-back(resume) during core-dumping(suspend) a guest, such
problem would cause the guest os unoprationable.)

====================================================================
we found warning messages in guest os:
--------------------------------------------------------------------
Aug 2 10:17:34 localhost kernel: [38592.985159] platform pcspkr: resume
Aug 2 10:17:34 localhost kernel: [38592.989890] platform vesafb.0: resume
Aug 2 10:17:34 localhost kernel: [38592.996075] input input0: type resume
Aug 2 10:17:34 localhost kernel: [38593.001330] input input1: type resume
Aug 2 10:17:34 localhost kernel: [38593.005496] vbd vbd-51712: legacy resume
Aug 2 10:17:34 localhost kernel: [38593.011506] WARNING: g.e. still in use!
Aug 2 10:17:34 localhost kernel: [38593.016909] WARNING: leaking g.e. and page still in use!
Aug 2 10:17:34 localhost kernel: [38593.026204] xen vbd-51760: legacy resume
Aug 2 10:17:34 localhost kernel: [38593.033070] vif vif-0: legacy resume
Aug 2 10:17:34 localhost kernel: [38593.039327] WARNING: g.e. still in use!
Aug 2 10:17:34 localhost kernel: [38593.045304] WARNING: leaking g.e. and page still in use!
Aug 2 10:17:34 localhost kernel: [38593.052101] WARNING: g.e. still in use!
Aug 2 10:17:34 localhost kernel: [38593.057965] WARNING: leaking g.e. and page still in use!
Aug 2 10:17:34 localhost kernel: [38593.066795] serial8250 serial8250: resume
Aug 2 10:17:34 localhost kernel: [38593.073556] input input2: type resume
Aug 2 10:17:34 localhost kernel: [38593.079385] platform Fixed MDIO bus.0: resume
Aug 2 10:17:34 localhost kernel: [38593.086285] usb usb1: type resume
------------------------------------------------------

which means that we refers to a grant-table while it's in use.

The reason results in that:
suspend/resume codes:
--------------------------------------------------------
//drivers/xen/manage.c
static void do_suspend(void)
{
int err;
struct suspend_info si;

shutting_down = SHUTDOWN_SUSPEND;

………………
err = dpm_suspend_start(PMSG_FREEZE);
………………
dpm_resume_start(si.cancelled ? PMSG_THAW : PMSG_RESTORE);

if (err) {
pr_err("failed to start xen_suspend: %d\n", err);
si.cancelled = 1;
}
//NOTE: si.cancelled = 1

out_resume:
if (!si.cancelled) {
xen_arch_resume();
xs_resume();
} else
xs_suspend_cancel();

dpm_resume_end(si.cancelled ? PMSG_THAW : PMSG_RESTORE); //blkfront device got resumed here.

out_thaw:
#ifdef CONFIG_PREEMPT
thaw_processes();
out:
#endif
shutting_down = SHUTDOWN_INVALID;
}
------------------------------------

Func "dpm_suspend_start" suspends devices, and "dpm_resume_end" resumes devices.
However, we found that the device "blkfront" has no SUSPEND method but RESUME method.

-------------------------------------
//drivers/block/xen-blkfront.c
static DEFINE_XENBUS_DRIVER(blkfront, ,
.probe = blkfront_probe,
.remove = blkfront_remove,
.resume = blkfront_resume, // only RESUME method found here.
.otherend_changed = blkback_changed,
.is_ready = blkfront_is_ready,
);
--------------------------------------

It resumes blkfront device when it didn't get suspended, which caused the prolem above.


=========================================
In order to check whether it's the problem of PVOPS or hypervisor(xen)/dom0, we suspend/resume
other non-PVOPS guest oses, no such problem occured.

Other non-PVOPS are using their own xen drivers, as shown in https://github.com/jpaton/xen-4.1-LJX1/
blob/master/unmodified_drivers/linux-2.6/platform-pci/machine_reboot.c :

int __xen_suspend(int fast_suspend, void (*resume_notifier)(int))
{
int err, suspend_cancelled, nr_cpus;
struct ap_suspend_info info;

xenbus_suspend();

……………………
preempt_enable();

if (!suspend_cancelled)
xenbus_resume(); //when the guest os get resumed, suspend_cancelled == 1, thus it wouldn't
enter xenbus_resume_uvp here.
else
xenbus_suspend_cancel(); //It gets here. so the blkfront wouldn't resume.

return 0;
}



