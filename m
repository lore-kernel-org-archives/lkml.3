Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750955Ab3FCDTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 23:19:45 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:34684 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3FCDTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 23:19:39 -0400
Message-ID: <51AC0B3C.8020504@linux.vnet.ibm.com>
Date: Mon, 03 Jun 2013 11:19:24 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: mingo@redhat.com, x86@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: Baremetal during suspend gives: WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123
 native_smp_send_reschedule+0x5b/0x60()
References: <20130531211116.GA5362@phenom.dumpdata.com>
In-Reply-To: <20130531211116.GA5362@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060303-5140-0000-0000-0000034CF7A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 05:11 AM, Konrad Rzeszutek Wilk wrote:
> Heya!
> 
> This is v3.10-rc3 with a revert of b5096566f6e1ee2b88324772f020ae9bc0cfa9a0
> (drm/nv50/fifo: prevent races between clients updating playlists) since said
> commit hangs resume.

Hi, Konrad

Borislav has reported the BUG before, and we already figure out the
issue was caused by gov_queue_work() passed an offline cpu to
mod_delayed_work_on(), you could get the conversation here:

	https://lkml.org/lkml/2013/5/20/297

I've cc the related folks, and I still suggest we could try:

diff --git a/drivers/cpufreq/cpufreq_governor.c
b/drivers/cpufreq/cpufreq_governor.c
index 443442d..449be88 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -26,6 +26,7 @@
 #include <linux/tick.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
+#include <linux/cpu.h>

 #include "cpufreq_governor.h"

@@ -180,8 +181,10 @@ void gov_queue_work(struct dbs_data *dbs_data,
struct cpufreq_policy *policy,
        if (!all_cpus) {
                __gov_queue_work(smp_processor_id(), dbs_data, delay);
        } else {
+               get_online_cpus();
                for_each_cpu(i, policy->cpus)
                        __gov_queue_work(i, dbs_data, delay);
+               put_online_cpus();
        }
 }
 EXPORT_SYMBOL_GPL(gov_queue_work);

firstly, would you like to apply it and see whether the problem get solved?

Regards,
Michael Wang

> 
> Anyhow on a Fedora built type .config the machine during suspend throws this warning:
> 
> 
> [  819.641298] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [  819.695579] PM: Saving platform NVS memory
> [  819.701191] Disabling non-boot CPUs ...
> [  819.705218] smpboot: CPU 1 is now offline
> [  819.705652] CPU 1 offline: Remove Rx thread
> [  819.705972] ------------[ cut here ]------------
> [  819.705984] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5b/0x60()
> [  819.706040] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHECKSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_nat iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio bridge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntrack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_addr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc crc32c_intel snd_timer edac_core eeepc_wmi ghash_clmulni_intel asus_wmi snd sparse_keymap rfkill k10temp fam15h_power
> [  819.706063]  microcode serio_raw edac_mce_amd joydev pcspkr sp5100_tco vhost_net soundcore i2c_piix4 r8169 ptp tun pps_core mii macvtap macvlan kvm_amd kvm uinput nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm usb_storage drm hid_logitech_dj i2c_core wmi
> [  819.706067] CPU: 0 PID: 127 Comm: kworker/1:1 Not tainted 3.10.0-rc3+ #4
> [  819.706068] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1208 04/18/2012
> [  819.706073] Workqueue: events od_dbs_timer
> [  819.706080]  0000000000000009 ffff88042ff6dbf8 ffffffff8167edc5 ffff88042ff6dc38
> [  819.706084]  ffffffff8105d380 0000000000000339 0000000000000001 ffff8804385e0000
> [  819.706088]  000000010008056a 0000000000000001 ffff88044ec50b08 ffff88042ff6dc48
> [  819.706089] Call Trace:
> [  819.706097]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
> [  819.706102]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
> [  819.706107]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
> [  819.706112]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
> [  819.706116]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
> [  819.706120]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
> [  819.706125]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
> [  819.706129]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
> [  819.706133]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
> [  819.706138]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
> [  819.706141]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
> [  819.706146]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
> [  819.706150]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
> [  819.706154]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
> [  819.706158]  [<ffffffff81082960>] kthread+0xc0/0xd0
> [  819.706162]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
> [  819.706166]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
> [  819.706170]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
> [  819.706173] ---[ end trace a5556efe295a5e63 ]---
> [  819.706729] Broke affinity for irq 81
> [  819.709704] smpboot: CPU 2 is now offline
> [  819.710351] CPU 2 offline: Remove Rx thread
> [  819.710995] ------------[ cut here ]------------
> [  819.711000] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5b/0x60()
> [  819.711042] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHECKSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_nat iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio bridge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntrack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_addr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc crc32c_intel snd_timer edac_core eeepc_wmi ghash_clmulni_intel asus_wmi snd sparse_keymap rfkill k10temp fam15h_power
> [  819.711060]  microcode serio_raw edac_mce_amd joydev pcspkr sp5100_tco vhost_net soundcore i2c_piix4 r8169 ptp tun pps_core mii macvtap macvlan kvm_amd kvm uinput nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm usb_storage drm hid_logitech_dj i2c_core wmi
> [  819.711063] CPU: 0 PID: 112 Comm: kworker/2:1 Tainted: G        W    3.10.0-rc3+ #4
> [  819.711064] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1208 04/18/2012
> [  819.711067] Workqueue: events od_dbs_timer
> [  819.711073]  0000000000000009 ffff88042fd61bf8 ffffffff8167edc5 ffff88042fd61c38
> [  819.711077]  ffffffff8105d380 0000000000000339 0000000000000002 ffff880438604000
> [  819.711081]  0000000100080574 0000000000000002 ffff88044ec90b08 ffff88042fd61c48
> [  819.711082] Call Trace:
> [  819.711086]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
> [  819.711091]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
> [  819.711095]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
> [  819.711099]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
> [  819.711103]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
> [  819.711107]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
> [  819.711111]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
> [  819.711115]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
> [  819.711119]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
> [  819.711123]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
> [  819.711126]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
> [  819.711131]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
> [  819.711135]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
> [  819.711139]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
> [  819.711142]  [<ffffffff81082960>] kthread+0xc0/0xd0
> [  819.711146]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
> [  819.711150]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
> [  819.711153]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
> [  819.711156] ---[ end trace a5556efe295a5e64 ]---
> [  819.712428] smpboot: CPU 3 is now offline
> [  819.712967] CPU 3 offline: Remove Rx thread
> [  819.716711] smpboot: CPU 4 is now offline
> [  819.717210] CPU 4 offline: Remove Rx thread
> [  819.717924] Broke affinity for irq 18
> [  819.717940] Broke affinity for irq 22
> [  819.717946] Broke affinity for irq 23
> [  819.719055] ------------[ cut here ]------------
> [  819.719060] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5b/0x60()
> [  819.719098] ------------[ cut here ]------------
> [  819.719113] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5b/0x60()
> [  819.719117] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHECKSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_nat iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio bridge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntrack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_addr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
> [  819.719119] Modules linked in:
> [  819.719121]  snd_hwdep
> [  819.719123]  bnep
> [  819.719124]  snd_seq
> [  819.719126]  bluetooth
> [  819.719128]  snd_seq_device
> [  819.719129]  fuse
> [  819.719131]  snd_pcm
> [  819.719133]  ebtable_nat
> [  819.719135]  e1000e
> [  819.719136]  xt_CHECKSUM
> [  819.719139] smpboot: CPU 5 is now offline
> [  819.719141]  snd_page_alloc
> [  819.719142]  ipt_MASQUERADE
> [  819.719144]  crc32c_intel
> [  819.719146]  nf_conntrack_netbios_ns
> [  819.719147]  snd_timer
> [  819.719149]  nf_conntrack_broadcast
> [  819.719151]  edac_core
> [  819.719152]  ip6table_mangle
> [  819.719154]  eeepc_wmi
> [  819.719156]  ip6t_REJECT
> [  819.719157]  ghash_clmulni_intel
> [  819.719159]  nf_conntrack_ipv6
> [  819.719160]  asus_wmi
> [  819.719162]  nf_defrag_ipv6
> [  819.719164]  snd
> [  819.719165]  be2iscsi
> [  819.719167]  sparse_keymap
> [  819.719168]  iptable_nat
> [  819.719170]  rfkill
> [  819.719171]  iscsi_boot_sysfs
> [  819.719173]  k10temp
> [  819.719175]  nf_nat_ipv4
> [  819.719176]  fam15h_power
> [  819.719178]  bnx2i
> [  819.719179]  microcode
> [  819.719181]  nf_nat
> [  819.719182]  serio_raw
> [  819.719184]  cnic
> [  819.719186]  edac_mce_amd
> [  819.719187]  iptable_mangle
> [  819.719189]  joydev
> [  819.719190]  uio
> [  819.719192]  pcspkr
> [  819.719194]  bridge
> [  819.719195]  sp5100_tco
> [  819.719197]  cxgb4i
> [  819.719198]  vhost_net
> [  819.719200]  cxgb4
> [  819.719202]  soundcore
> [  819.719203]  nf_conntrack_ipv4
> [  819.719205]  i2c_piix4
> [  819.719207]  stp
> [  819.719209]  r8169
> [  819.719211]  llc
> [  819.719213]  ptp
> [  819.719215]  nf_defrag_ipv4
> [  819.719217]  tun
> [  819.719219]  cxgb3i
> [  819.719221]  pps_core
> [  819.719222]  xt_conntrack
> [  819.719224]  mii
> [  819.719226]  cxgb3
> [  819.719228]  macvtap
> [  819.719230]  nf_conntrack
> [  819.719231]  macvlan
> [  819.719233]  mdio
> [  819.719235]  kvm_amd
> [  819.719237]  libcxgbi
> [  819.719239]  kvm
> [  819.719241]  ib_iser
> [  819.719243]  uinput
> [  819.719245]  rdma_cm
> [  819.719246]  nouveau
> [  819.719248]  ebtable_filter
> [  819.719250]  video
> [  819.719252]  ib_addr
> [  819.719253]  mxm_wmi
> [  819.719255]  iw_cm
> [  819.719256]  i2c_algo_bit
> [  819.719259]  ebtables
> [  819.719260]  drm_kms_helper
> [  819.719262]  ib_cm
> [  819.719264]  ttm
> [  819.719266]  ib_sa
> [  819.719267]  usb_storage
> [  819.719270]  ip6table_filter
> [  819.719271]  drm
> [  819.719273]  ib_mad
> [  819.719274]  hid_logitech_dj
> [  819.719276]  ip6_tables
> [  819.719278]  i2c_core
> [  819.719279]  ib_core
> [  819.719281]  wmi
> 
> [  819.719287] CPU: 0 PID: 2321 Comm: kworker/4:0 Tainted: G        W    3.10.0-rc3+ #4
> [  819.719289] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1208 04/18/2012
> [  819.719293]  iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
> [  819.719295] Workqueue: events od_dbs_timer
> 
> [  819.719300]  snd_hda_codec_hdmi snd_hda_codec_realtek
> [  819.719302]  0000000000000009
> [  819.719304]  snd_hda_intel
> [  819.719306]  ffff8803fb159bf8
> [  819.719308]  snd_hda_codec
> [  819.719310]  ffffffff8167edc5
> [  819.719313]  snd_hwdep
> [  819.719314]  ffff8803fb159c38
> 
> [  819.719318]  snd_seq snd_seq_device
> [  819.719320]  ffffffff8105d380
> [  819.719321]  snd_pcm
> [  819.719323]  0000000000000339
> [  819.719325]  e1000e
> [  819.719326]  0000000000000004
> [  819.719329]  snd_page_alloc
> [  819.719330]  ffff880438678000
> 
> [  819.719334]  crc32c_intel snd_timer
> [  819.719336]  000000010008057e
> [  819.719338]  edac_core
> [  819.719339]  0000000000000004
> [  819.719342]  eeepc_wmi
> [  819.719344]  ffff88044ed10b08
> [  819.719345]  ghash_clmulni_intel
> [  819.719347]  ffff8803fb159c48
> 
> [  819.719351] Call Trace:
> [  819.719353]  asus_wmi snd sparse_keymap
> [  819.719359]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
> [  819.719361]  rfkill k10temp
> [  819.719368]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
> [  819.719370]  fam15h_power microcode
> [  819.719376]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
> [  819.719378]  serio_raw edac_mce_amd
> [  819.719384]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
> [  819.719386]  joydev pcspkr
> [  819.719390]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
> [  819.719393]  sp5100_tco vhost_net
> [  819.719397]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
> [  819.719400]  soundcore i2c_piix4
> [  819.719405]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
> [  819.719407]  r8169 ptp
> [  819.719412]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
> [  819.719415]  tun pps_core
> [  819.719419]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
> [  819.719422]  mii macvtap
> [  819.719426]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
> [  819.719429]  macvlan kvm_amd
> [  819.719433]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
> [  819.719435]  kvm uinput
> [  819.719440]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
> [  819.719443]  nouveau video mxm_wmi
> [  819.719448]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
> [  819.719450]  i2c_algo_bit drm_kms_helper
> [  819.719455]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
> [  819.719457]  ttm usb_storage
> [  819.719461]  [<ffffffff81082960>] kthread+0xc0/0xd0
> [  819.719464]  drm hid_logitech_dj i2c_core
> [  819.719469]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
> [  819.719470]  wmi
> [  819.719474]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
> [  819.719479] CPU: 6 PID: 136 Comm: kworker/3:1 Tainted: G        W    3.10.0-rc3+ #4
> [  819.719483] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1208 04/18/2012
> [  819.719486]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
> [  819.719493] ---[ end trace a5556efe295a5e65 ]---
> [  819.719494] Workqueue: events od_dbs_timer
> [  819.719502]  0000000000000009 ffff88042f823bf8 ffffffff8167edc5 ffff88042f823c38
> [  819.719507]  ffffffff8105d380 0000000000000339 0000000000000003 ffff880438650000
> [  819.719511]  000000010008057e 0000000000000003 ffff88044ecd0b08 ffff88042f823c48
> [  819.719513] Call Trace:
> [  819.719521]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
> [  819.719528]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
> [  819.719534]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
> [  819.719539]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
> [  819.719544]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
> [  819.719549]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
> [  819.719554]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
> [  819.719559]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
> [  819.719563]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
> [  819.719569]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
> [  819.719573]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
> [  819.719578]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
> [  819.719583]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
> [  819.719588]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
> [  819.719593]  [<ffffffff81082960>] kthread+0xc0/0xd0
> [  819.719598]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
> [  819.719603]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
> [  819.719607]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
> [  819.719611] ---[ end trace a5556efe295a5e66 ]---
> [  819.719680] CPU 5 offline: Remove Rx thread
> [  819.719940] ------------[ cut here ]------------
> [  819.719945] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5b/0x60()
> [  819.719988] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHECKSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_nat iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio bridge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntrack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_addr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc crc32c_intel snd_timer edac_core eeepc_wmi ghash_clmulni_intel asus_wmi snd sparse_keymap rfkill k10temp fam15h_power
> [  819.720005]  microcode serio_raw edac_mce_amd joydev pcspkr sp5100_tco vhost_net soundcore i2c_piix4 r8169 ptp tun pps_core mii macvtap macvlan kvm_amd kvm uinput nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm usb_storage drm hid_logitech_dj i2c_core wmi
> [  819.720008] CPU: 0 PID: 126 Comm: kworker/5:1 Tainted: G        W    3.10.0-rc3+ #4
> [  819.720009] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1208 04/18/2012
> [  819.720012] Workqueue: events od_dbs_timer
> [  819.720017]  0000000000000009 ffff88042ff11bf8 ffffffff8167edc5 ffff88042ff11c38
> [  819.720021]  ffffffff8105d380 0000000000000339 0000000000000005 ffff88043869c000
> [  819.720025]  000000010008057e 0000000000000005 ffff88044ed50b08 ffff88042ff11c48
> [  819.720026] Call Trace:
> [  819.720030]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
> [  819.720034]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
> [  819.720039]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
> [  819.720043]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
> [  819.720047]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
> [  819.720050]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
> [  819.720055]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
> [  819.720058]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
> [  819.720062]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
> [  819.720066]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
> [  819.720070]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
> [  819.720074]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
> [  819.720078]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
> [  819.720082]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
> [  819.720085]  [<ffffffff81082960>] kthread+0xc0/0xd0
> [  819.720090]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
> [  819.720093]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
> [  819.720097]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
> [  819.720099] ---[ end trace a5556efe295a5e67 ]---
> [  819.723294] smpboot: CPU 6 is now offline
> [  819.723792] CPU 6 offline: Remove Rx thread
> [  819.724289] Broke affinity for irq 19
> [  819.725405] smpboot: CPU 7 is now offline
> [  819.725840] CPU 7 offline: Remove Rx thread
> [  819.729465] ACPI: Low-level resume complete
> [  819.729494] PM: Restoring platform NVS memory
> [  819.820651] microcode: CPU0: new patch_level=0x06000629
> [  819.820717] ------------[ cut here ]------------
> [  819.820723] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5b/0x60()
> [  819.820750] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHECKSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_nat iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio bridge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntrack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_addr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc crc32c_intel snd_timer edac_core eeepc_wmi ghash_clmulni_intel asus_wmi snd sparse_keymap rfkill k10temp fam15h_power
> [  819.820761]  microcode serio_raw edac_mce_amd joydev pcspkr sp5100_tco vhost_net soundcore i2c_piix4 r8169 ptp tun pps_core mii macvtap macvlan kvm_amd kvm uinput nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm usb_storage drm hid_logitech_dj i2c_core wmi
> [  819.820763] CPU: 0 PID: 257 Comm: kworker/6:2 Tainted: G        W    3.10.0-rc3+ #4
> [  819.820764] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1208 04/18/2012
> [  819.820766] Workqueue: events od_dbs_timer
> [  819.820769]  0000000000000009 ffff88042f33bbf8 ffffffff8167edc5 ffff88042f33bc38
> [  819.820771]  ffffffff8105d380 0000000000000339 0000000000000006 ffff8804386dc000
> [  819.820773]  0000000100080594 0000000000000006 ffff88044ed90b08 ffff88042f33bc48
> [  819.820773] Call Trace:
> [  819.820777]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
> [  819.820779]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
> [  819.820781]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
> [  819.820783]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
> [  819.820785]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
> [  819.820787]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
> [  819.820789]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
> [  819.820791]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
> [  819.820792]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
> [  819.820794]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
> [  819.820796]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
> [  819.820797]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
> [  819.820799]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
> [  819.820801]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
> [  819.820802]  [<ffffffff81082960>] kthread+0xc0/0xd0
> [  819.820804]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
> [  819.820806]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
> [  819.820807]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
> [  819.820808] ---[ end trace a5556efe295a5e68 ]---
> [  819.820811] ------------[ cut here ]------------
> [  819.820813] WARNING: at /home/konrad/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5b/0x60()
> [  819.820830] Modules linked in: bnep bluetooth fuse ebtable_nat xt_CHECKSUM ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 be2iscsi iptable_nat iscsi_boot_sysfs nf_nat_ipv4 bnx2i nf_nat cnic iptable_mangle uio bridge cxgb4i cxgb4 nf_conntrack_ipv4 stp llc nf_defrag_ipv4 cxgb3i xt_conntrack cxgb3 nf_conntrack mdio libcxgbi ib_iser rdma_cm ebtable_filter ib_addr iw_cm ebtables ib_cm ib_sa ip6table_filter ib_mad ip6_tables ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc crc32c_intel snd_timer edac_core eeepc_wmi ghash_clmulni_intel asus_wmi snd sparse_keymap rfkill k10temp fam15h_power
> [  819.820837]  microcode serio_raw edac_mce_amd joydev pcspkr sp5100_tco vhost_net soundcore i2c_piix4 r8169 ptp tun pps_core mii macvtap macvlan kvm_amd kvm uinput nouveau video mxm_wmi i2c_algo_bit drm_kms_helper ttm usb_storage drm hid_logitech_dj i2c_core wmi
> [  819.820838] CPU: 0 PID: 60 Comm: kworker/7:0 Tainted: G        W    3.10.0-rc3+ #4
> [  819.820838] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1208 04/18/2012
> [  819.820839] Workqueue: events od_dbs_timer
> [  819.820841]  0000000000000009 ffff88043870dbf8 ffffffff8167edc5 ffff88043870dc38
> [  819.820843]  ffffffff8105d380 0000000000000339 0000000000000007 ffff880438720000
> [  819.820844]  0000000100080594 0000000000000007 ffff88044edd0b08 ffff88043870dc48
> [  819.820845] Call Trace:
> [  819.820846]  [<ffffffff8167edc5>] dump_stack+0x19/0x1b
> [  819.820848]  [<ffffffff8105d380>] warn_slowpath_common+0x70/0xa0
> [  819.820850]  [<ffffffff8105d3ca>] warn_slowpath_null+0x1a/0x20
> [  819.820852]  [<ffffffff8103679b>] native_smp_send_reschedule+0x5b/0x60
> [  819.820853]  [<ffffffff8108f8bd>] wake_up_nohz_cpu+0x2d/0xa0
> [  819.820854]  [<ffffffff8106d9a6>] add_timer_on+0x96/0x100
> [  819.820856]  [<ffffffff8107bd8e>] __queue_delayed_work+0x16e/0x1a0
> [  819.820858]  [<ffffffff8107baa9>] ? try_to_grab_pending+0xc9/0x180
> [  819.820859]  [<ffffffff8107be1a>] mod_delayed_work_on+0x5a/0x80
> [  819.820861]  [<ffffffff815234fd>] gov_queue_work+0x4d/0xc0
> [  819.820862]  [<ffffffff81521ed9>] od_dbs_timer+0xc9/0x170
> [  819.820864]  [<ffffffff8107b3da>] process_one_work+0x17a/0x400
> [  819.820865]  [<ffffffff8107c83c>] worker_thread+0x11c/0x370
> [  819.820867]  [<ffffffff8107c720>] ? manage_workers.isra.21+0x2b0/0x2b0
> [  819.820868]  [<ffffffff81082960>] kthread+0xc0/0xd0
> [  819.820870]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
> [  819.820871]  [<ffffffff8168e0ec>] ret_from_fork+0x7c/0xb0
> [  819.820872]  [<ffffffff810828a0>] ? kthread_create_on_node+0x120/0x120
> [  819.820873] ---[ end trace a5556efe295a5e69 ]---
> 
> I did not dive in details so I hadn't even bisected it. I can certainly
> do so on Monday - but figured I would first ask whether somebody
> else had reported this.
> 
> Attached is the full dmesg.
> 
> 

