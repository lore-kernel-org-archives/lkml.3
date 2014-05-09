Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbaEIQQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:16:13 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:34855 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995AbaEIQQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:16:09 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 9 May 2014 12:19:49 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Don Zickus <dzickus@redhat.com>, Vince Weaver <vincent.weaver@maine.edu>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
In-Reply-To: <20140508080234.GO8607@moon>
Message-ID: <alpine.DEB.2.10.1405091211430.13652@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu> <20140506202307.GA1458@moon> <20140508020050.GX39568@redhat.com> <20140508073756.GM8607@moon> <20140508074930.GN8607@moon> <20140508080234.GO8607@moon>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Cyrill Gorcunov wrote:
> 
> Updated.
> ---
>  arch/x86/kernel/cpu/perf_event_p4.c |   67 ++++++++++++++++--------------------
>  1 file changed, 30 insertions(+), 37 deletions(-)

I tried this patch, and even though it seemed to fix one of the NMI storms 
I was experiencing I've managed to trigger again using a different random 
seed.

I've been trying to track down a trace of what is triggering things, but 
this is very difficult as the full log isn't making it to the serial 
console, even when I fsync() stdout.

Maybe related, but the following messages tend to happen a lot while 
fuzzing, and always happen before the fuzzing that eventually locks up:

The warnings are for
	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
and
	WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);	


[ 3086.168915] hrtimer: interrupt took 4251 ns

[ 3097.845779] NOHZ: local_softirq_pending 100
[ 3098.222766] NOHZ: local_softirq_pending 100
[ 3098.239817] ------------[ cut here ]------------
[ 3098.240006] WARNING: CPU: 0 PID: 1877 at arch/x86/kernel/cpu/perf_event.c:1082 x86_pmu_start+0x4b/0xf8()
[ 3098.240006] Modules linked in: loop iTCO_wdt iTCO_vendor_support lpc_ich ppdev evdev microcode pcspkr psmouse i915 serio_raw parport_pc tpm_tis drm_kms_helper i2c_i801 tpm mfd_core parport drm acpi_cpufreq processor video button thermal_sys snd_hda_codec_analog snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm i2c_algo_bit snd_timer i2c_core snd soundcore sr_mod cdrom sd_mod crc_t10dif crct10dif_generic crct10dif_common tg3 ehci_pci uhci_hcd ehci_hcd ptp ata_generic ata_piix floppy libata scsi_mod pps_core libphy usbcore usb_common
[ 3098.240006] CPU: 0 PID: 1877 Comm: perf_fuzzer Not tainted 3.15.0-rc4+ #4
[ 3098.240006] Hardware name: LENOVO 88088NU/LENOVO, BIOS 2JKT37AUS 07/12/2007
[ 3098.240006]  0000000000000000 ffff88003af6bb40 ffffffff81430fbe 0000000000000000
[ 3098.240006]  ffff88003af6bb78 ffffffff8103c77d ffffffff81012912 ffff88003cb52c00
[ 3098.240006]  ffff88003f40bb50 000000000000000c ffff88003f40bb58 ffff88003af6bb88
[ 3098.240006] Call Trace:
[ 3098.240006]  [<ffffffff81430fbe>] dump_stack+0x45/0x56
[ 3098.240006]  [<ffffffff8103c77d>] warn_slowpath_common+0x7f/0x98
[ 3098.240006]  [<ffffffff81012912>] ? x86_pmu_start+0x4b/0xf8
[ 3098.240006]  [<ffffffff8103c844>] warn_slowpath_null+0x1a/0x1c
[ 3098.240006]  [<ffffffff81012912>] x86_pmu_start+0x4b/0xf8
[ 3098.240006]  [<ffffffff81012ee2>] x86_pmu_enable+0x154/0x233
[ 3098.240006]  [<ffffffff810cfc66>] perf_pmu_enable+0x27/0x29
[ 3098.240006]  [<ffffffff810117e7>] x86_pmu_commit_txn+0x7b/0x98
[ 3098.240006]  [<ffffffff8108a9e5>] ? clockevents_program_event+0x9d/0xb9
[ 3098.240006]  [<ffffffff810591ad>] ? __hrtimer_start_range_ns+0x267/0x299
[ 3098.240006]  [<ffffffff81015067>] ? p4_pmu_enable_event+0x111/0x11c
[ 3098.240006]  [<ffffffff810150b0>] ? p4_pmu_enable_all+0x3e/0x48
[ 3098.240006]  [<ffffffff810d0cfe>] ? event_sched_in+0x138/0x148
[ 3098.240006]  [<ffffffff810d0da6>] group_sched_in+0x98/0x141
[ 3098.240006]  [<ffffffff81064b4b>] ? sched_clock_cpu+0x91/0xa2
[ 3098.240006]  [<ffffffff810d1960>] __perf_event_enable+0xf6/0x136
[ 3098.240006]  [<ffffffff810cd934>] remote_function+0x1c/0x45
[ 3098.240006]  [<ffffffff810905c6>] generic_exec_single+0x3e/0x10f
[ 3098.240006]  [<ffffffff810cd918>] ? cpu_clock_event_add+0x1b/0x1b
[ 3098.240006]  [<ffffffff810cd918>] ? cpu_clock_event_add+0x1b/0x1b
[ 3098.240006]  [<ffffffff81090715>] smp_call_function_single+0x7e/0x86
[ 3098.240006]  [<ffffffff810cc9cd>] task_function_call+0x49/0x53
[ 3098.240006]  [<ffffffff810d186a>] ? __perf_install_in_context+0xf2/0xf2
[ 3098.240006]  [<ffffffff810cf080>] perf_event_enable+0x8a/0xbf
[ 3098.240006]  [<ffffffff810ceff6>] ? __perf_event_mark_enabled+0x5f/0x5f
[ 3098.240006]  [<ffffffff810cca34>] perf_event_for_each_child+0x5d/0x98
[ 3098.240006]  [<ffffffff810d048b>] perf_event_task_enable+0x56/0x7c
[ 3098.240006]  [<ffffffff8104dea9>] SyS_prctl+0x16e/0x391
[ 3098.240006]  [<ffffffff811228fd>] ? SyS_write+0x63/0x79
[ 3098.240006]  [<ffffffff8143acd6>] system_call_fastpath+0x1a/0x1f
[ 3098.240006] ---[ end trace de5690b3396a1c26 ]---

[ 3113.245401] NOHZ: local_softirq_pending 100
[ 3117.838763] ------------[ cut here ]------------
[ 3117.840006] WARNING: CPU: 1 PID: 1877 at arch/x86/kernel/cpu/perf_event.c:1164 x86_pmu_stop+0x6d/0xa0()
[ 3117.840006] Modules linked in: loop iTCO_wdt iTCO_vendor_support lpc_ich ppdev evdev microcode pcspkr psmouse i915 serio_raw parport_pc tpm_tis drm_kms_helper i2c_i801 tpm mfd_core parport drm acpi_cpufreq processor video button thermal_sys snd_hda_codec_analog snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm i2c_algo_bit snd_timer i2c_core snd soundcore sr_mod cdrom sd_mod crc_t10dif crct10dif_generic crct10dif_common tg3 ehci_pci uhci_hcd ehci_hcd ptp ata_generic ata_piix floppy libata scsi_mod pps_core libphy usbcore usb_common
[ 3117.840006] CPU: 1 PID: 1877 Comm: perf_fuzzer Tainted: G        W     3.15.0-rc4+ #4
[ 3117.840006] Hardware name: LENOVO 88088NU/LENOVO, BIOS 2JKT37AUS 07/12/2007
[ 3117.840006]  0000000000000000 ffff88003af6b7a0 ffffffff81430fbe 0000000000000000
[ 3117.840006]  ffff88003af6b7d8 ffffffff8103c77d ffffffff81012034 ffff880037038400
[ 3117.840006]  ffff88003f50bb50 0000000000000004 000002d043484e06 ffff88003af6b7e8
[ 3117.840006] Call Trace:
[ 3117.840006]  [<ffffffff81430fbe>] dump_stack+0x45/0x56
[ 3117.840006]  [<ffffffff8103c77d>] warn_slowpath_common+0x7f/0x98
[ 3117.840006]  [<ffffffff81012034>] ? x86_pmu_stop+0x6d/0xa0
[ 3117.840006]  [<ffffffff8103c844>] warn_slowpath_null+0x1a/0x1c
[ 3117.840006]  [<ffffffff81012034>] x86_pmu_stop+0x6d/0xa0
[ 3117.840006]  [<ffffffff810120a1>] x86_pmu_del+0x3a/0xe5
[ 3117.840006]  [<ffffffff810cfd01>] event_sched_out+0x99/0x102
[ 3117.840006]  [<ffffffff810cfd95>] group_sched_out+0x2b/0x7b
[ 3117.840006]  [<ffffffff810d003b>] ctx_sched_out+0x9c/0xf1
[ 3117.840006]  [<ffffffff810d126b>] __perf_event_task_sched_out+0x171/0x306
[ 3117.840006]  [<ffffffff8105eef0>] perf_event_task_sched_out+0x33/0x67
[ 3117.840006]  [<ffffffff81066d7d>] ? set_next_entity+0x3e/0x65
[ 3117.840006]  [<ffffffff8106890b>] ? pick_next_task_fair+0x142/0x336
[ 3117.840006]  [<ffffffff810674bf>] ? dequeue_task_fair+0x155/0x162
[ 3117.840006]  [<ffffffff8105e710>] ? pick_next_task+0x33/0x6b
[ 3117.840006]  [<ffffffff81432c03>] __schedule+0x237/0x4cd
[ 3117.840006]  [<ffffffff81432f0c>] schedule+0x73/0x75
[ 3117.840006]  [<ffffffff81432973>] schedule_hrtimeout_range_clock+0xb6/0xe6
[ 3117.840006]  [<ffffffff81058972>] ? hrtimer_get_res+0x42/0x42
[ 3117.840006]  [<ffffffff810591f3>] ? hrtimer_start_range_ns+0x14/0x16
[ 3117.840006]  [<ffffffff814329b6>] schedule_hrtimeout_range+0x13/0x15
[ 3117.840006]  [<ffffffff81130be8>] poll_schedule_timeout+0x41/0x61
[ 3117.840006]  [<ffffffff81131df0>] do_sys_poll+0x391/0x429
[ 3117.840006]  [<ffffffff81130d7c>] ? poll_select_copy_remaining+0xf9/0xf9
[ 3117.840006]  [<ffffffff81130d7c>] ? poll_select_copy_remaining+0xf9/0xf9
[ 3117.840006]  [<ffffffff81130d7c>] ? poll_select_copy_remaining+0xf9/0xf9
[ 3117.840006]  [<ffffffff81130d7c>] ? poll_select_copy_remaining+0xf9/0xf9
[ 3117.840006]  [<ffffffff81130d7c>] ? poll_select_copy_remaining+0xf9/0xf9
[ 3117.840006]  [<ffffffff81130d7c>] ? poll_select_copy_remaining+0xf9/0xf9
[ 3117.840006]  [<ffffffff81130d7c>] ? poll_select_copy_remaining+0xf9/0xf9
[ 3117.840006]  [<ffffffff81130d7c>] ? poll_select_copy_remaining+0xf9/0xf9
[ 3117.840006]  [<ffffffff81130d7c>] ? poll_select_copy_remaining+0xf9/0xf9
[ 3117.840006]  [<ffffffff81131f28>] SyS_poll+0x50/0xb7
[ 3117.840006]  [<ffffffff8143aed3>] tracesys+0xe1/0xe6
[ 3117.840006] ---[ end trace de5690b3396a1c27 ]---

[ 3123.751913] Uhhuh. NMI received for unknown reason 21 on CPU 0.
[ 3123.752446] Do you have a strange power saving mode enabled?
[ 3123.752446] Dazed and confused, but trying to continue
[ 3123.752446] Uhhuh. NMI received for unknown reason 31 on CPU 0.
[ 3123.752446] Do you have a strange power saving mode enabled?
[ 3123.752446] Dazed and confused, but trying to continue
....repeat forever

