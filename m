Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab3ETNYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:24:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36784 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145Ab3ETNYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:24:00 -0400
Date: Mon, 20 May 2013 15:23:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, rjw@sisk.pl,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule, round 2
Message-ID: <20130520132355.GF12690@pd.tnic>
References: <20130520045023.GA12690@pd.tnic>
 <5199C169.7060504@linux.vnet.ibm.com>
 <20130520064727.GD12690@pd.tnic>
 <5199C990.3020602@linux.vnet.ibm.com>
 <5199CB59.1020309@linux.vnet.ibm.com>
 <CAKohponk-FQpHOx407FL63ZCYVgz2C-ScvZQBQFVxddbL+fS=A@mail.gmail.com>
 <5199CFD0.9030101@linux.vnet.ibm.com>
 <5199E54D.7030407@linux.vnet.ibm.com>
 <CAKohponS+tCkZyVpDO9fEMQCfsn5h=N235sj5sBGUkD2qKY=cQ@mail.gmail.com>
 <5199EBB5.7060209@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5199EBB5.7060209@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 05:24:05PM +0800, Michael Wang wrote:
> >> diff --git a/drivers/cpufreq/cpufreq_governor.c
> >> b/drivers/cpufreq/cpufreq_governor.c
> >> index 443442d..449be88 100644
> >> --- a/drivers/cpufreq/cpufreq_governor.c
> >> +++ b/drivers/cpufreq/cpufreq_governor.c
> >> @@ -26,6 +26,7 @@
> >>  #include <linux/tick.h>
> >>  #include <linux/types.h>
> >>  #include <linux/workqueue.h>
> >> +#include <linux/cpu.h>
> >>
> >>  #include "cpufreq_governor.h"
> >>
> >> @@ -180,8 +181,10 @@ void gov_queue_work(struct dbs_data *dbs_data,
> >> struct cpufreq_policy *policy,
> >>         if (!all_cpus) {
> >>                 __gov_queue_work(smp_processor_id(), dbs_data, delay);
> >>         } else {
> >> +               get_online_cpus();
> >>                 for_each_cpu(i, policy->cpus)
> >>                         __gov_queue_work(i, dbs_data, delay);
> >> +               put_online_cpus();
> >>         }
> >>  }
> >>  EXPORT_SYMBOL_GPL(gov_queue_work);
> >>
> >> This is supposed to make WARN disappear, if it works, then BINGO :)
> > 
> > Let people test it and then we can talk :)
> 
> Agree :)
> 
> Borislav, would you like to take a try?
> 
> If this fix cause other troubles, you could try get_cpu() or disable irq
> also.

I just confirmed that policy->cpus contains offlined cores with this:

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 5af40ad82d23..e8c25f71e9b6 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -169,6 +169,9 @@ static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
 {
        struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
 
+       if (WARN_ON(!cpu_online(cpu)))
+               return;
+
        mod_delayed_work_on(cpu, system_wq, &cdbs->work, delay);
 }

see splats collection below.

And I don't think your fix above addresses the issue for the simple
reason that if cpus go offline *before* you do get_online_cpus(), then
policy->cpus will already contain offlined cpus.

Rather, a better fix would be, IMHO, to do this (it works here, of course):

---
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 5af40ad82d23..58541b164494 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -17,6 +17,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <asm/cputime.h>
+#include <linux/cpu.h>
 #include <linux/cpufreq.h>
 #include <linux/cpumask.h>
 #include <linux/export.h>
@@ -169,7 +170,15 @@ static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
 {
        struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
 
+       get_online_cpus();
+
+       if (!cpu_online(cpu))
+               goto out;
+
        mod_delayed_work_on(cpu, system_wq, &cdbs->work, delay);
+
+ out:
+       put_online_cpus();
 }
 
 void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
--


[   94.386340] EXT4-fs (sda7): re-mounted. Opts: (null)
[   96.520362] kvm: exiting hardware virtualization
[   96.637687] ACPI: Preparing to enter system sleep state S5
[   96.643506] Disabling non-boot CPUs ...
[   96.855499] ------------[ cut here ]------------
[   96.860172] WARNING: at drivers/cpufreq/cpufreq_governor.c:172 gov_queue_work+0xf0/0x110()
[   96.868501] Modules linked in: ext2 vfat fat loop usbhid snd_hda_codec_hdmi coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_intel snd_hda_codec ehci_pci xhci_hcd ehci_hcd usbcore crc32_pclmul crc32c_intel snd_hwdep snd_pcm snd_page_alloc snd_timer ghash_clmulni_intel snd aesni_intel aes_x86_64 glue_helper sb_edac edac_core acpi_cpufreq mperf pcspkr lrw gf128mul ablk_helper cryptd iTCO_wdt iTCO_vendor_support evdev soundcore lpc_ich mfd_core processor dcdbas i2c_i801 usb_common button microcode
[   96.914238] CPU: 0 PID: 315 Comm: kworker/1:2 Tainted: G        W    3.10.0-rc1+ #2
[   96.921969] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[   96.929424] Workqueue: events od_dbs_timer
[   96.933574]  0000000000000009 ffff88043a08bc78 ffffffff8161445c ffff88043a08bcb8
[   96.941085]  ffffffff8103e540 ffff88043b712a80 0000000000000001 ffff88043a296400
[   96.948602]  ffff88043b712a80 ffffffff81cdc910 0000000000000001 ffff88043a08bcc8
[   96.956123] Call Trace:
[   96.958602]  [<ffffffff8161445c>] dump_stack+0x19/0x1b
[   96.963801]  [<ffffffff8103e540>] warn_slowpath_common+0x70/0xa0
[   96.969858]  [<ffffffff8103e58a>] warn_slowpath_null+0x1a/0x20
[   96.975735]  [<ffffffff814f6bf0>] gov_queue_work+0xf0/0x110
[   96.981359]  [<ffffffff814f60bb>] od_dbs_timer+0xcb/0x170
[   96.986808]  [<ffffffff8105e75d>] process_one_work+0x1fd/0x540
[   96.992691]  [<ffffffff8105e6f2>] ? process_one_work+0x192/0x540
[   96.998756]  [<ffffffff8105ef22>] worker_thread+0x122/0x380
[   97.004371]  [<ffffffff8105ee00>] ? rescuer_thread+0x320/0x320
[   97.010256]  [<ffffffff8106634a>] kthread+0xea/0xf0
[   97.015185]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   97.021605]  [<ffffffff81623d9c>] ret_from_fork+0x7c/0xb0
[   97.027049]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   97.033457] ---[ end trace d36d91c626ac81a0 ]---
[   97.039221] ------------[ cut here ]------------
[   97.039227] ------------[ cut here ]------------
[   97.039229] WARNING: at drivers/cpufreq/cpufreq_governor.c:172 gov_queue_work+0xf0/0x110()
[   97.039243] Modules linked in: ext2 vfat fat loop usbhid snd_hda_codec_hdmi coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_intel snd_hda_codec ehci_pci xhci_hcd ehci_hcd usbcore crc32_pclmul crc32c_intel snd_hwdep snd_pcm snd_page_alloc snd_timer ghash_clmulni_intel snd aesni_intel aes_x86_64 glue_helper sb_edac edac_core acpi_cpufreq mperf pcspkr lrw gf128mul ablk_helper cryptd iTCO_wdt iTCO_vendor_support evdev soundcore lpc_ich mfd_core processor dcdbas i2c_i801 usb_common button microcode
[   97.039245] CPU: 4 PID: 82 Comm: kworker/2:1 Tainted: G        W    3.10.0-rc1+ #2
[   97.039245] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[   97.039248] Workqueue: events od_dbs_timer
[   97.039250]  0000000000000009 ffff88043b5cfc78 ffffffff8161445c ffff88043b5cfcb8
[   97.039251]  ffffffff8103e540 ffff88043b712a80 0000000000000002 ffff88043a295e00
[   97.039253]  ffff88043b712a80 ffffffff81cdc910 0000000000000002 ffff88043b5cfcc8
[   97.039253] Call Trace:
[   97.039255]  [<ffffffff8161445c>] dump_stack+0x19/0x1b
[   97.039257]  [<ffffffff8103e540>] warn_slowpath_common+0x70/0xa0
[   97.039258]  [<ffffffff8103e58a>] warn_slowpath_null+0x1a/0x20
[   97.039259]  [<ffffffff814f6bf0>] gov_queue_work+0xf0/0x110
[   97.039261]  [<ffffffff814f60bb>] od_dbs_timer+0xcb/0x170
[   97.039263]  [<ffffffff8105e75d>] process_one_work+0x1fd/0x540
[   97.039264]  [<ffffffff8105e6f2>] ? process_one_work+0x192/0x540
[   97.039265]  [<ffffffff8105ef22>] worker_thread+0x122/0x380
[   97.039267]  [<ffffffff8105ee00>] ? rescuer_thread+0x320/0x320
[   97.039268]  [<ffffffff8106634a>] kthread+0xea/0xf0
[   97.039269]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   97.039270]  [<ffffffff81623d9c>] ret_from_fork+0x7c/0xb0
[   97.039272]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   97.039272] ---[ end trace d36d91c626ac81a1 ]---
[   97.143214] nouveau E[     DRM] GPU lockup - switching to software fbcon
[   97.318430] WARNING: at drivers/cpufreq/cpufreq_governor.c:172 gov_queue_work+0xf0/0x110()
[   97.326804] Modules linked in: ext2 vfat fat loop usbhid snd_hda_codec_hdmi coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_intel snd_hda_codec ehci_pci xhci_hcd ehci_hcd usbcore crc32_pclmul crc32c_intel snd_hwdep snd_pcm snd_page_alloc snd_timer ghash_clmulni_intel snd aesni_intel aes_x86_64 glue_helper sb_edac edac_core acpi_cpufreq mperf pcspkr lrw gf128mul ablk_helper cryptd iTCO_wdt iTCO_vendor_support evdev soundcore lpc_ich mfd_core processor dcdbas i2c_i801 usb_common button microcode
[   97.374578] CPU: 0 PID: 98 Comm: kworker/3:1 Tainted: G        W    3.10.0-rc1+ #2
[   97.384154] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[   97.393566] Workqueue: events od_dbs_timer
[   97.399675]  0000000000000009 ffff88043b179c78 ffffffff8161445c ffff88043b179cb8
[   97.409153]  ffffffff8103e540 ffff88043b712a80 0000000000000003 ffff88043a295a00
[   97.418623]  ffff88043b712a80 ffffffff81cdc910 0000000000000003 ffff88043b179cc8
[   97.428103] Call Trace:
[   97.432520]  [<ffffffff8161445c>] dump_stack+0x19/0x1b
[   97.439678]  [<ffffffff8103e540>] warn_slowpath_common+0x70/0xa0
[   97.447694]  [<ffffffff8103e58a>] warn_slowpath_null+0x1a/0x20
[   97.455512]  [<ffffffff814f6bf0>] gov_queue_work+0xf0/0x110
[   97.462993]  [<ffffffff814f60bb>] od_dbs_timer+0xcb/0x170
[   97.470259]  [<ffffffff8105e75d>] process_one_work+0x1fd/0x540
[   97.477878]  [<ffffffff8105e6f2>] ? process_one_work+0x192/0x540
[   97.485652]  [<ffffffff8105ef22>] worker_thread+0x122/0x380
[   97.492969]  [<ffffffff8105ee00>] ? rescuer_thread+0x320/0x320
[   97.500565]  [<ffffffff8106634a>] kthread+0xea/0xf0
[   97.507167]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   97.515255]  [<ffffffff81623d9c>] ret_from_fork+0x7c/0xb0
[   97.522389]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   97.530472] ---[ end trace d36d91c626ac81a2 ]---
[   97.543176] ------------[ cut here ]------------
[   97.547172] ------------[ cut here ]------------
[   97.547178] WARNING: at drivers/cpufreq/cpufreq_governor.c:172 gov_queue_work+0xf0/0x110()
[   97.547197] Modules linked in: ext2 vfat fat loop usbhid snd_hda_codec_hdmi coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_intel snd_hda_codec ehci_pci xhci_hcd ehci_hcd usbcore crc32_pclmul crc32c_intel snd_hwdep snd_pcm snd_page_alloc snd_timer ghash_clmulni_intel snd aesni_intel aes_x86_64 glue_helper sb_edac edac_core acpi_cpufreq mperf pcspkr lrw gf128mul ablk_helper cryptd iTCO_wdt iTCO_vendor_support evdev soundcore lpc_ich mfd_core processor dcdbas i2c_i801 usb_common button microcode
[   97.547199] CPU: 7 PID: 316 Comm: kworker/5:1 Tainted: G        W    3.10.0-rc1+ #2
[   97.547200] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[   97.547202] Workqueue: events od_dbs_timer
[   97.547204]  0000000000000009 ffff88043905dc78 ffffffff8161445c ffff88043905dcb8
[   97.547205]  ffffffff8103e540 ffff88043b712a80 0000000000000005 ffff88043a295800
[   97.547206]  ffff88043b712a80 ffffffff81cdc910 0000000000000005 ffff88043905dcc8
[   97.547207] Call Trace:
[   97.547211]  [<ffffffff8161445c>] dump_stack+0x19/0x1b
[   97.547214]  [<ffffffff8103e540>] warn_slowpath_common+0x70/0xa0
[   97.547215]  [<ffffffff8103e58a>] warn_slowpath_null+0x1a/0x20
[   97.547216]  [<ffffffff814f6bf0>] gov_queue_work+0xf0/0x110
[   97.547218]  [<ffffffff814f60bb>] od_dbs_timer+0xcb/0x170
[   97.547220]  [<ffffffff8105e75d>] process_one_work+0x1fd/0x540
[   97.547221]  [<ffffffff8105e6f2>] ? process_one_work+0x192/0x540
[   97.547222]  [<ffffffff8105ef22>] worker_thread+0x122/0x380
[   97.547224]  [<ffffffff8105ee00>] ? rescuer_thread+0x320/0x320
[   97.547225]  [<ffffffff8106634a>] kthread+0xea/0xf0
[   97.547226]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   97.547228]  [<ffffffff81623d9c>] ret_from_fork+0x7c/0xb0
[   97.547229]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   97.547230] ---[ end trace d36d91c626ac81a3 ]---
[   97.761326] WARNING: at drivers/cpufreq/cpufreq_governor.c:172 gov_queue_work+0xf0/0x110()
[   97.770798] Modules linked in: ext2 vfat fat loop usbhid snd_hda_codec_hdmi coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_intel snd_hda_codec ehci_pci xhci_hcd ehci_hcd usbcore crc32_pclmul crc32c_intel snd_hwdep snd_pcm snd_page_alloc snd_timer ghash_clmulni_intel snd aesni_intel aes_x86_64 glue_helper sb_edac edac_core acpi_cpufreq mperf pcspkr lrw gf128mul ablk_helper cryptd iTCO_wdt iTCO_vendor_support evdev soundcore lpc_ich mfd_core processor dcdbas i2c_i801 usb_common button microcode
[   97.819617] CPU: 0 PID: 253 Comm: kworker/4:1 Tainted: G        W    3.10.0-rc1+ #2
[   97.828623] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[   97.837372] Workqueue: events od_dbs_timer
[   97.842805]  0000000000000009 ffff880439529c78 ffffffff8161445c ffff880439529cb8
[   97.851628]  ffffffff8103e540 ffff88043b712a80 0000000000000004 ffff88043a295c00
[   97.860445]  ffff88043b712a80 ffffffff81cdc910 0000000000000004 ffff880439529cc8
[   97.869249] Call Trace:
[   97.873041]  [<ffffffff8161445c>] dump_stack+0x19/0x1b
[   97.879533]  [<ffffffff8103e540>] warn_slowpath_common+0x70/0xa0
[   97.886912]  [<ffffffff8103e58a>] warn_slowpath_null+0x1a/0x20
[   97.894100]  [<ffffffff814f6bf0>] gov_queue_work+0xf0/0x110
[   97.901002]  [<ffffffff814f60bb>] od_dbs_timer+0xcb/0x170
[   97.907706]  [<ffffffff8105e75d>] process_one_work+0x1fd/0x540
[   97.914797]  [<ffffffff8105e6f2>] ? process_one_work+0x192/0x540
[   97.922016]  [<ffffffff8105ef22>] worker_thread+0x122/0x380
[   97.928803]  [<ffffffff8105ee00>] ? rescuer_thread+0x320/0x320
[   97.935837]  [<ffffffff8106634a>] kthread+0xea/0xf0
[   97.941900]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   97.949443]  [<ffffffff81623d9c>] ret_from_fork+0x7c/0xb0
[   97.956027]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   97.963563] ---[ end trace d36d91c626ac81a4 ]---
[   97.970449] ------------[ cut here ]------------
[   97.976277] WARNING: at drivers/cpufreq/cpufreq_governor.c:172 gov_queue_work+0xf0/0x110()
[   97.985762] Modules linked in: ext2 vfat fat loop usbhid snd_hda_codec_hdmi coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_intel snd_hda_codec ehci_pci xhci_hcd ehci_hcd usbcore crc32_pclmul crc32c_intel snd_hwdep snd_pcm snd_page_alloc snd_timer ghash_clmulni_intel snd aesni_intel aes_x86_64 glue_helper sb_edac edac_core acpi_cpufreq mperf pcspkr lrw gf128mul ablk_helper cryptd iTCO_wdt iTCO_vendor_support evdev soundcore lpc_ich mfd_core processor dcdbas i2c_i801 usb_common button microcode
[   98.035051] CPU: 0 PID: 102 Comm: kworker/6:1 Tainted: G        W    3.10.0-rc1+ #2
[   98.044067] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[   98.052834] Workqueue: events od_dbs_timer
[   98.058285]  0000000000000009 ffff88043b6f3c78 ffffffff8161445c ffff88043b6f3cb8
[   98.067114]  ffffffff8103e540 ffff88043b712a80 0000000000000006 ffff88043a295600
[   98.075924]  ffff88043b712a80 ffffffff81cdc910 0000000000000006 ffff88043b6f3cc8
[   98.084735] Call Trace:
[   98.088518]  [<ffffffff8161445c>] dump_stack+0x19/0x1b
[   98.095024]  [<ffffffff8103e540>] warn_slowpath_common+0x70/0xa0
[   98.102386]  [<ffffffff8103e58a>] warn_slowpath_null+0x1a/0x20
[   98.109565]  [<ffffffff814f6bf0>] gov_queue_work+0xf0/0x110
[   98.116502]  [<ffffffff814f60bb>] od_dbs_timer+0xcb/0x170
[   98.123253]  [<ffffffff8105e75d>] process_one_work+0x1fd/0x540
[   98.130394]  [<ffffffff8105e6f2>] ? process_one_work+0x192/0x540
[   98.137667]  [<ffffffff8105ef22>] worker_thread+0x122/0x380
[   98.144456]  [<ffffffff8105ee00>] ? rescuer_thread+0x320/0x320
[   98.151510]  [<ffffffff8106634a>] kthread+0xea/0xf0
[   98.157583]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   98.165143]  [<ffffffff81623d9c>] ret_from_fork+0x7c/0xb0
[   98.171730]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   98.179282] ---[ end trace d36d91c626ac81a5 ]---
[   98.185098] ------------[ cut here ]------------
[   98.190903] WARNING: at drivers/cpufreq/cpufreq_governor.c:172 gov_queue_work+0xf0/0x110()
[   98.200387] Modules linked in: ext2 vfat fat loop
[   98.205029] nouveau W[   PFIFO][0000:03:00.0] unknown intr 0x00400000, ch 1
[   98.214563]  usbhid snd_hda_codec_hdmi coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_intel snd_hda_codec ehci_pci xhci_hcd ehci_hcd usbcore crc32_pclmul crc32c_intel snd_hwdep snd_pcm snd_page_alloc snd_timer ghash_clmulni_intel snd aesni_intel aes_x86_64 glue_helper sb_edac edac_core acpi_cpufreq mperf pcspkr lrw gf128mul ablk_helper cryptd iTCO_wdt iTCO_vendor_support evdev soundcore lpc_ich mfd_core processor dcdbas i2c_i801 usb_common button microcode
[   98.258886] CPU: 0 PID: 318 Comm: kworker/7:1 Tainted: G        W    3.10.0-rc1+ #2
[   98.267919] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[   98.276689] Workqueue: events od_dbs_timer
[   98.282147]  0000000000000009 ffff88043969dc78 ffffffff8161445c ffff88043969dcb8
[   98.290991]  ffffffff8103e540 ffff88043b712a80 0000000000000007 ffff88043a295200
[   98.299832]  ffff88043b712a80 ffffffff81cdc910 0000000000000007 ffff88043969dcc8
[   98.308671] Call Trace:
[   98.312471]  [<ffffffff8161445c>] dump_stack+0x19/0x1b
[   98.318982]  [<ffffffff8103e540>] warn_slowpath_common+0x70/0xa0
[   98.326376]  [<ffffffff8103e58a>] warn_slowpath_null+0x1a/0x20
[   98.333577]  [<ffffffff814f6bf0>] gov_queue_work+0xf0/0x110
[   98.340482]  [<ffffffff814f60bb>] od_dbs_timer+0xcb/0x170
[   98.347160]  [<ffffffff8105e75d>] process_one_work+0x1fd/0x540
[   98.354232]  [<ffffffff8105e6f2>] ? process_one_work+0x192/0x540
[   98.361471]  [<ffffffff8105ef22>] worker_thread+0x122/0x380
[   98.368260]  [<ffffffff8105ee00>] ? rescuer_thread+0x320/0x320
[   98.375309]  [<ffffffff8106634a>] kthread+0xea/0xf0
[   98.381385]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   98.388951]  [<ffffffff81623d9c>] ret_from_fork+0x7c/0xb0
[   98.395546]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   98.403097] ---[ end trace d36d91c626ac81a6 ]---
[   98.409180] Power down.
[   98.413109] acpi_power_off called

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
