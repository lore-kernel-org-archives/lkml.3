Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaBNUWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:22:31 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46787 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaBNUW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:22:27 -0500
Message-ID: <52FE7AFD.2040203@wwwdotorg.org>
Date: Fri, 14 Feb 2014 13:22:21 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net
CC: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, nm@ti.com,
        kgene.kim@samsung.com, jinchoi@broadcom.com, tianyu.lan@intel.com,
        sebastian.capella@linaro.org, jhbird.choi@samsung.com
Subject: Re: [PATCH V5 0/7] cpufreq: suspend early/resume late: dpm_{suspend|resume}()
References: <cover.1392273722.git.viresh.kumar@linaro.org> <52FE71BD.3020103@wwwdotorg.org>
In-Reply-To: <52FE71BD.3020103@wwwdotorg.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 12:42 PM, Stephen Warren wrote:
> On 02/12/2014 11:50 PM, Viresh Kumar wrote:
>> This patchset creates/calls cpufreq suspend/resume callbacks from dpm_{suspend|resume}()
>> for handling suspend/resume of cpufreq governors and core.

BTW, I also happened to test these on a Tegra114 system, on which there
is no cpufreq driver, and this series (applied on top of commit
9398a10cd964 Merge tag 'regulator-v3.14-rc2') causes the following
during suspend:

> [  196.666799] PM: Syncing filesystems ... done.
> [  196.692824] Freezing user space processes ... (elapsed 0.002 seconds) done.
> [  196.694265] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
> [  196.695377] Unable to handle kernel NULL pointer dereference at virtual address 00000024
> [  196.695380] pgd = ec454000
> [  196.695390] [00000024] *pgd=acb0c831, *pte=00000000, *ppte=00000000
> [  196.695398] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
> [  196.695405] Modules linked in:
> [  196.695413] CPU: 0 PID: 892 Comm: test-rtc-resume Not tainted 3.14.0-rc2-00266-gca91b201c563-dirty #41
> [  196.695418] task: ecb86e00 ti: ec692000 task.ti: ec692000
> [  196.695432] PC is at cpufreq_suspend+0xc/0xc8
> [  196.695440] LR is at dpm_suspend+0x30/0x214
> [  196.695447] pc : [<c038f6c0>]    lr : [<c02c3208>]    psr: 60000113
> [  196.695447] sp : ec693e60  ip : 00000018  fp : 000aa2b8
> [  196.695451] r10: c07dcfec  r9 : ec975808  r8 : c07f4a28
> [  196.695455] r7 : c08642c8  r6 : c08658a0  r5 : 00000003  r4 : c081f690
> [  196.695459] r3 : 00000000  r2 : cbf0c52d  r1 : 3b9aca00  r0 : ec693e80
> [  196.695465] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [  196.695470] Control: 10c5387d  Table: ac45406a  DAC: 00000015
> [  196.695475] Process test-rtc-resume (pid: 892, stack limit = 0xec692240)
> [  196.695479] Stack: (0xec693e60 to 0xec694000)
> [  196.695488] 3e60: c081f690 00000003 c07f49ec c02c3208 c07f4a20 00000002 cbf0c52d 0000002d
> [  196.695495] 3e80: cbf0c52d 0000002d 00000003 c081f690 00000003 00000003 00000003 ec88bcc0
> [  196.695503] 3ea0: ec975808 00000004 000aa2b8 c006324c 000aa2b8 c056cb70 c070a0a4 ec693ed4
> [  196.695509] 3ec0: 00000003 ec693ed4 00000003 00000000 00000003 c0577bc4 00000003 ec88bcc0
> [  196.695516] 3ee0: 00000004 c0063654 0000006d 00000003 c06b8040 c00624e0 00000004 ed13b4c8
> [  196.695523] 3f00: ec88bcc0 00000004 ec693f80 ec88bcc0 ec975800 c01fc200 00000004 c0126e50
> [  196.695530] 3f20: c0126e0c 00000000 00000000 c012a274 00000000 00000000 ec4f3ec0 00000004
> [  196.695536] 3f40: 000ac408 ec693f80 00000000 ec692000 00000004 c00d4818 ec9c6d40 00000001
> [  196.695543] 3f60: 0000000a 00000000 00000000 ec4f3ec0 000ac408 00000000 00000004 c00d4bb8
> [  196.695550] 3f80: 00000000 00000000 ec4f3ec0 b6f17a78 00000004 000ac408 00000004 c000e7a4
> [  196.695556] 3fa0: 00000000 c000e620 b6f17a78 00000004 00000001 000ac408 00000004 00000000
> [  196.695563] 3fc0: b6f17a78 00000004 000ac408 00000004 beca645c 000a6094 00000000 000aa2b8
> [  196.695570] 3fe0: 00000000 beca63dc b6e86747 b6ebe60c 400f0010 00000001 941e9002 3000f8d9
> [  196.695585] [<c038f6c0>] (cpufreq_suspend) from [<c02c3208>] (dpm_suspend+0x30/0x214)
> [  196.695601] [<c02c3208>] (dpm_suspend) from [<c006324c>] (suspend_devices_and_enter+0x48/0x2dc)
> [  196.695613] [<c006324c>] (suspend_devices_and_enter) from [<c0063654>] (pm_suspend+0x174/0x1e8)
> [  196.695623] [<c0063654>] (pm_suspend) from [<c00624e0>] (state_store+0x6c/0xbc)
> [  196.695634] [<c00624e0>] (state_store) from [<c01fc200>] (kobj_attr_store+0x14/0x20)
> [  196.695650] [<c01fc200>] (kobj_attr_store) from [<c0126e50>] (sysfs_kf_write+0x44/0x48)
> [  196.695663] [<c0126e50>] (sysfs_kf_write) from [<c012a274>] (kernfs_fop_write+0xb4/0x14c)
> [  196.695677] [<c012a274>] (kernfs_fop_write) from [<c00d4818>] (vfs_write+0xa8/0x180)
> [  196.695691] [<c00d4818>] (vfs_write) from [<c00d4bb8>] (SyS_write+0x3c/0x70)
> [  196.695705] [<c00d4bb8>] (SyS_write) from [<c000e620>] (ret_fast_syscall+0x0/0x30)
> [  196.695716] Code: e12fff1e e92d4070 e59f60a8 e5963000 (e5932024) 
> [  196.695722] ---[ end trace 606f168631f0e32f ]---

