Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbaKNUTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:19:18 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:61803 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbaKNUTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:19:17 -0500
MIME-Version: 1.0
Date: Fri, 14 Nov 2014 12:19:16 -0800
Message-ID: <CAHTgTXX=0JqGx1eYa4+Y5TuvzUpVwMNQdPe2a7m=r3pZBfGXxQ@mail.gmail.com>
Subject: x86 math_error warning in Linux kernel 3.10
From: Vinson Lee <vlee@twopensource.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Suresh Siddha <sbsiddha@gmail.com>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt.fleming@intel.com>, Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

We hit this x86 math_error warning in Linux kernel 3.10.

------------[ cut here ]------------
WARNING: at arch/x86/include/asm/fpu-internal.h:524 math_error+0xd1/0x219()
Modules linked in: cls_basic act_mirred cls_u32 veth sch_ingress
netconsole configfs ipv6 dm_multipath scsi_dh video sbs sbshc hed
acpi_pad acpi_ipmi acpi_i2c parport_pc lp parport tcp_diag inet_diag
ipmi_si ipmi_devintf ipmi_msghandler dell_rbu sg iTCO_wdt
iTCO_vendor_support dcdbas igb i2c_algo_bit ptp pps_core shpchp
lpc_ich i2c_i801 mfd_core i2c_core ioatdma dca i7core_edac edac_core
microcode freq_table mperf ahci libahci libata sd_mod scsi_mod
CPU: 2 PID: 53182 Comm: java Not tainted 3.10.50 #1
 0000000000000000 ffff8808e1f5be38 ffffffff8146cb74 ffff8808e1f5be70
 ffffffff8103cbf9 0000000000000000 ffff88090b2c9730 ffff8808e1f5bf58
 0000000000000010 0000000000000000 ffff8808e1f5be80 ffffffff8103ccbf
Call Trace:
 [<ffffffff8146cb74>] dump_stack+0x19/0x1b
 [<ffffffff8103cbf9>] warn_slowpath_common+0x65/0x7d
 [<ffffffff8103ccbf>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff8100317b>] math_error+0xd1/0x219
 [<ffffffff81007f6c>] ? read_tsc+0x9/0x19
 [<ffffffff8107bab8>] ? timekeeping_get_ns.constprop.10+0x11/0x36
 [<ffffffff8107bf32>] ? ktime_get+0x68/0x76
 [<ffffffff81007f6c>] ? read_tsc+0x9/0x19
 [<ffffffff8107bab8>] ? timekeeping_get_ns.constprop.10+0x11/0x36
 [<ffffffff810032d6>] do_coprocessor_error+0x13/0x15
 [<ffffffff81478a38>] coprocessor_error+0x18/0x20
---[ end trace 3e4a6532a67ba6d3 ]---


Here are the CPU flags:

flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64
monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid dca sse4_1
sse4_2 popcnt aes lahf_lm ida arat epb dtherm tpr_shadow vnmi
flexpriority ept vpid


arch/x86/include/asm/fpu-internal.h
   519  /*
   520   * These disable preemption on their own and are safe
   521   */
   522  static inline void save_init_fpu(struct task_struct *tsk)
   523  {
   524          WARN_ON_ONCE(!__thread_has_fpu(tsk));
   525
   526          if (use_eager_fpu()) {
   527                  __save_fpu(tsk);
   528                  return;
   529          }
   530
   531          preempt_disable();
   532          __save_init_fpu(tsk);
   533          __thread_fpu_end(tsk);
   534          preempt_enable();
   535  }

Cheers,
Vinson
