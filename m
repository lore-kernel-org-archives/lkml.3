Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaBNWIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 17:08:51 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64657 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751833AbaBNWIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 17:08:49 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, kgene.kim@samsung.com,
        jinchoi@broadcom.com, tianyu.lan@intel.com,
        sebastian.capella@linaro.org, jhbird.choi@samsung.com
Subject: Re: [PATCH V5 0/7] cpufreq: suspend early/resume late: dpm_{suspend|resume}()
Date: Fri, 14 Feb 2014 23:23:33 +0100
Message-ID: <2869027.iYHxWOSS2C@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <52FE71BD.3020103@wwwdotorg.org>
References: <cover.1392273722.git.viresh.kumar@linaro.org> <52FE71BD.3020103@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 14, 2014 12:42:53 PM Stephen Warren wrote:
> On 02/12/2014 11:50 PM, Viresh Kumar wrote:
> > This patchset creates/calls cpufreq suspend/resume callbacks from dpm_{suspend|resume}()
> > for handling suspend/resume of cpufreq governors and core.
> 
> Are these patches for 3.14 or 3.15?

I don't think they are suitable for 3.14, honestly.

> I ask because I just tested Linus's master from a few days back (some
> point after v3.14-rc2; commit 9398a10cd964 Merge tag
> 'regulator-v3.14-rc2'), and I see a lot of the following messages during
> suspend and/or resume (about 2-7 times, perhaps more of them from the
> resume path, but it's hard to tell):
> 
> cpufreq: __cpufreq_driver_target: Failed to change cpu frequency: -16
> 
> This series does appear to solve those, so I think at least part of it
> needs to be applied for 3.14.

Well, it would be good to verify which part, then.

> Also, I sometimes see the following during resume. I saw it twice with
> Linus's tree, but then I did 10 more reboot+suspend+resume cycles and
> couldn't repro it, and I saw it once with Linus's tree plus this series
> applied, then couldn't reproduce it in 5 more tries.
> 
> > [ 48.500410] ------------[ cut here ]------------
> > [ 48.505252] WARNING: CPU: 0 PID: 877 at fs/sysfs/dir.c:52 sysfs_warn_dup+0x68/0x84()
> > [ 48.513005] sysfs: cannot create duplicate filename '/devices/system/cpu/cpu1/cpufreq'
> > [ 48.520995] Modules linked in: brcmfmac brcmutil
> > [ 48.525740] CPU: 0 PID: 877 Comm: test-rtc-resume Not tainted 3.14.0-rc2-00259-g9398a10cd964 #12
> > [ 48.534645] [<c0015bac>] (unwind_backtrace) from [<c0011850>] (show_stack+0x10/0x14)
> > [ 48.542440] [<c0011850>] (show_stack) from [<c056e018>] (dump_stack+0x80/0xcc)
> > [ 48.549757] [<c056e018>] (dump_stack) from [<c0025e44>] (warn_slowpath_common+0x64/0x88)
> > [ 48.557964] [<c0025e44>] (warn_slowpath_common) from [<c0025efc>] (warn_slowpath_fmt+0x30/0x40)
> > [ 48.566756] [<c0025efc>] (warn_slowpath_fmt) from [<c012776c>] (sysfs_warn_dup+0x68/0x84)
> > [ 48.575024] [<c012776c>] (sysfs_warn_dup) from [<c0127a54>] (sysfs_do_create_link_sd+0xb0/0xb8)
> > [ 48.583772] [<c0127a54>] (sysfs_do_create_link_sd) from [<c038ef64>] (__cpufreq_add_dev.isra.27+0x2a8/0x814)
> > [ 48.593701] [<c038ef64>] (__cpufreq_add_dev.isra.27) from [<c038f548>] (cpufreq_cpu_callback+0x70/0x8c)
> > [ 48.603198] [<c038f548>] (cpufreq_cpu_callback) from [<c0043864>] (notifier_call_chain+0x44/0x84)
> > [ 48.612166] [<c0043864>] (notifier_call_chain) from [<c0025f60>] (__cpu_notify+0x28/0x44)
> > [ 48.620424] [<c0025f60>] (__cpu_notify) from [<c00261e8>] (_cpu_up+0xf0/0x140)
> > [ 48.627748] [<c00261e8>] (_cpu_up) from [<c0569eb8>] (enable_nonboot_cpus+0x68/0xb0)
> > [ 48.635579] [<c0569eb8>] (enable_nonboot_cpus) from [<c006339c>] (suspend_devices_and_enter+0x198/0x2dc)
> > [ 48.645136] [<c006339c>] (suspend_devices_and_enter) from [<c0063654>] (pm_suspend+0x174/0x1e8)
> > [ 48.653862] [<c0063654>] (pm_suspend) from [<c00624e0>] (state_store+0x6c/0xbc)
> > [ 48.661258] [<c00624e0>] (state_store) from [<c01fc200>] (kobj_attr_store+0x14/0x20)
> > [ 48.669083] [<c01fc200>] (kobj_attr_store) from [<c0126e50>] (sysfs_kf_write+0x44/0x48)
> > [ 48.677163] [<c0126e50>] (sysfs_kf_write) from [<c012a274>] (kernfs_fop_write+0xb4/0x14c)
> > [ 48.685432] [<c012a274>] (kernfs_fop_write) from [<c00d4818>] (vfs_write+0xa8/0x180)
> > [ 48.693214] [<c00d4818>] (vfs_write) from [<c00d4bb8>] (SyS_write+0x3c/0x70)
> > [ 48.700349] [<c00d4bb8>] (SyS_write) from [<c000e620>] (ret_fast_syscall+0x0/0x30)
> > [ 48.708053] ---[ end trace 76969904b614c18f ]--- 
> 
> Do you have any idea what the problem might be, and how to solve it?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
