Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990AbaDOVdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 17:33:12 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:57487 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaDOVdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 17:33:08 -0400
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 17:33:08 EDT
X-Spam-Flag: NO
X-Spam-Score: -20.468
Message-ID: <534DA315.6040808@tremplin-utc.net>
Date: Tue, 15 Apr 2014 23:22:29 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>,
        Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: using __this_cpu_write() in preemptible [00000000] code:
 systemd-udevd/497
References: <87mwfn4gah.fsf@canonical.com>
In-Reply-To: <87mwfn4gah.fsf@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/14 01:55, Luis Henriques wrote:
> 
> (Cc'ing both lis3lv02d and ACPI maintainers)
> 
> Since commit 188a81409ff7de1c5aae947a96356ddd8ff4aaa3 ("percpu: add
> preemption checks to __this_cpu ops") I've been seeing the following:
Hi,

I've had a quick look at the lis3lv02d_acpi_read() (in
drivers/platform/x86/hp_accel.c) and couldn't see anything obvious. It
basically does:
status = acpi_evaluate_integer(dev->handle, "ALRD", &args, &lret);

Is there anything special to take care before calling
acpi_evaluate_integer()? After having a look at some codes calling it
nothing obvious either jumped to my eyes.

> 
> [   10.485588] hp_accel: hardware type HPB64xx found
> [   10.485772] BUG: using __this_cpu_write() in preemptible [00000000] code: systemd-udevd/497
> [   10.485777] caller is __this_cpu_preempt_check+0x13/0x20
> [   10.485781] CPU: 3 PID: 497 Comm: systemd-udevd Tainted: G        W     3.15.0-rc1 #9
> [   10.485783] Hardware name: Hewlett-Packard HP EliteBook 8470p/179B, BIOS 68ICF Ver. F.02 04/27/2012
> [   10.485785]  ffffffff81a14db5 ffff88022c80b8e0 ffffffff81604ba4 0000000000000003
> [   10.485789]  ffff88022c80b908 ffffffff81313431 0000000000000000 0000000000000032
> [   10.485793]  00000000000003e8 ffff88022c80b918 ffffffff81313473 ffff88022c80b928
> [   10.485796] Call Trace:
> [   10.485802]  [<ffffffff81604ba4>] dump_stack+0x4e/0x7a
> [   10.485805]  [<ffffffff81313431>] check_preemption_disabled+0xe1/0xf0
> [   10.485808]  [<ffffffff81313473>] __this_cpu_preempt_check+0x13/0x20
> [   10.485813]  [<ffffffff810e4eb8>] touch_nmi_watchdog+0x28/0x40
> [   10.485817]  [<ffffffff81369c29>] acpi_os_stall+0x37/0x40
> [   10.485822]  [<ffffffff813843e2>] acpi_ex_system_do_stall+0x39/0x3d
> [   10.485825]  [<ffffffff81381138>] acpi_ex_opcode_1A_0T_0R+0x72/0xa3
> [   10.485829]  [<ffffffff81379a5d>] acpi_ds_exec_end_op+0xd0/0x3e8
> [   10.485833]  [<ffffffff8138b118>] acpi_ps_parse_loop+0x51d/0x576
> [   10.485836]  [<ffffffff8138bbc4>] acpi_ps_parse_aml+0x98/0x289
> [   10.485839]  [<ffffffff8138c41e>] acpi_ps_execute_method+0x1c1/0x26c
> [   10.485843]  [<ffffffff81386dcd>] acpi_ns_evaluate+0x1c1/0x258
> [   10.485846]  [<ffffffff8138960d>] acpi_evaluate_object+0x126/0x22f
> [   10.485850]  [<ffffffff810a4492>] ? wake_up_klogd+0x52/0x70
> [   10.485853]  [<ffffffff8136a520>] acpi_evaluate_integer+0x34/0x52
> [   10.485858]  [<ffffffffa01671e9>] lis3lv02d_acpi_read+0x59/0x70 [hp_accel]
> [   10.485863]  [<ffffffffa014e426>] lis3lv02d_init_device+0x26/0xc00 [lis3lv02d]
> [   10.485866]  [<ffffffff8138dc93>] ? acpi_walk_resources+0x77/0x8d
> [   10.485870]  [<ffffffffa0167265>] ? lis3lv02d_dmi_matched+0x35/0x40 [hp_accel]
> [   10.485874]  [<ffffffffa0167381>] lis3lv02d_add+0xe1/0x1d0 [hp_accel]
> [   10.485878]  [<ffffffff8136d83f>] acpi_device_probe+0x41/0xee
> [   10.485882]  [<ffffffff813eba1d>] driver_probe_device+0xfd/0x240
> [   10.485886]  [<ffffffff813ebc33>] __driver_attach+0x93/0xa0
> [   10.485889]  [<ffffffff813ebba0>] ? __device_attach+0x40/0x40
> [   10.485893]  [<ffffffff813e9b93>] bus_for_each_dev+0x63/0xa0
> [   10.485897]  [<ffffffff813eb4ae>] driver_attach+0x1e/0x20
> [   10.485900]  [<ffffffff813eb0e8>] bus_add_driver+0x178/0x230
> [   10.485904]  [<ffffffffa001d000>] ? 0xffffffffa001cfff
> [   10.485908]  [<ffffffff813ec264>] driver_register+0x64/0xf0
> [   10.485911]  [<ffffffffa001d000>] ? 0xffffffffa001cfff
> [   10.485915]  [<ffffffff8136e081>] acpi_bus_register_driver+0x3b/0x43
> [   10.485919]  [<ffffffffa001d010>] lis3lv02d_driver_init+0x10/0x1000 [hp_accel]
> [   10.485923]  [<ffffffff81000352>] do_one_initcall+0x112/0x160
> [   10.485927]  [<ffffffff8103c763>] ? set_memory_nx+0x43/0x50
> [   10.485932]  [<ffffffff810c79f0>] load_module+0x1b20/0x22f0
> [   10.485936]  [<ffffffff810c4860>] ? ref_module+0x120/0x120
> [   10.485940]  [<ffffffff810c4b6a>] ? copy_module_from_fd.isra.46+0x10a/0x160
> [   10.485944]  [<ffffffff810c82ee>] SyS_finit_module+0x7e/0x80
> [   10.485949]  [<ffffffff81614356>] system_call_fastpath+0x1a/0x1f
> 
> Before this BUG, I also have the following, which doesn't seem related
> (but I may be wrong):
:
I also agree with you this second stack dump is probably unrelated :-)

Cheers,
Éric

