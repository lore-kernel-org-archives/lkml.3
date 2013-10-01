Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3JAPJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:09:12 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:53575 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751898Ab3JAPJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:09:03 -0400
Message-ID: <524AE58B.9060902@hurleysoftware.com>
Date: Tue, 01 Oct 2013 11:08:59 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: [BUG] 3.12.0-rc2: cpufreq_get(0) crashes since commit 6eed9404a (cpufreq:
 Use rwsem for protecting critical sections)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.12.0-rc2 without a sub-driver loaded, the trivial module
inlined below [1] BUGs.

On 3.11.0, cpufreq_get(0) returns 0.

  kernel BUG at /home/peter/src/kernels/mainline/drivers/cpufreq/cpufreq.c:79!
  invalid opcode: 0000 [#1] PREEMPT SMP
  Modules linked in: cpufq(O+) ext2 ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables kvm_intel kvm bnep rfcomm bridge stp llc binfmt_misc snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi joydev snd_seq_midi_event snd_seq snd_timer snd_seq_device snd i5400_edac edac_core soundcore btusb bluetooth gpio_ich lpc_ich psmouse snd_page_alloc dm_multipath ppdev scsi_dh dcdbas i5k_amb parport_pc shpchp serio_raw lp parport hid_generic hid_logitech_dj usbhid hid netconsole configfs dm_mirror dm_region_hash dm_log usb_storage nouveau tg3 firewire_ohci ttm e1000e firewire_core drm_kms_helper crc_itu_t ptp drm pps_core i2c_algo_bit mxm_wmi video wmi
  CPU: 5 PID: 4189 Comm: modprobe Tainted: G           O 3.12-rc2+git07d8cec-trim #rc2+git07d8cec
  Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A11 04/30/2012
  task: ffff8800b3082e60 ti: ffff8802b20c8000 task.ti: ffff8802b20c8000
  RIP: 0010:[<ffffffff814f9d7f>]  [<ffffffff814f9d7f>] lock_policy_rwsem_read+0x3f/0x50
  RSP: 0018:ffff8802b20c9cc0  EFLAGS: 00010246
  RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000760
  RDX: ffff8802bfc00000 RSI: 0000000000000000 RDI: 0000000000000000
  RBP: ffff8802b20c9cd8 R08: ffffffffa0570000 R09: 00000000000030d0
  R10: 0000000000000001 R11: 8000000000000000 R12: 0000000000000000
  R13: ffffffffa0570050 R14: ffffffffa0570000 R15: ffff8802b0557660
  FS:  00007f9805a44700(0000) GS:ffff8802bfd40000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f98055833d0 CR3: 00000002b219d000 CR4: 00000000000007e0
  Stack:
   ffffffff814faff8 0000000000000000 ffffffffa056e000 ffff8802b20c9ce8
   ffffffffa056e010 ffff8802b20c9d68 ffffffff810002fa ffffffffa0570000
   ffff8802b0557660 ffff8802b20c9d38 ffffffff8103c993 0000000000000000
  Call Trace:
   [<ffffffff814faff8>] ? cpufreq_get+0x48/0x80
   [<ffffffffa056e000>] ? 0xffffffffa056dfff
   [<ffffffffa056e010>] cpufq_init+0x10/0x30 [cpufq]
   [<ffffffff810002fa>] do_one_initcall+0xfa/0x1b0
   [<ffffffff8103c993>] ? set_memory_nx+0x43/0x50
   [<ffffffff810bf674>] load_module+0x1d74/0x2890
   [<ffffffff810bb140>] ? unset_module_init_ro_nx+0x80/0x80
   [<ffffffff810c0242>] SyS_init_module+0xb2/0x100
   [<ffffffff8163bf92>] system_call_fastpath+0x16/0x1b
  Code: 44 cd 81 48 8b 04 10 48 85 c0 74 1f 55 48 c7 c7 20 fb 00 00 8b 40 14 48 89 e5 48 03 3c c5 40 44 cd 81 e8 a5 74 13 00 31 c0 5d c3 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66
  RIP  [<ffffffff814f9d7f>] lock_policy_rwsem_read+0x3f/0x50
   RSP <ffff8802b20c9cc0>


[1] trivial module

--- /dev/null	2013-10-01 10:01:46.782370182 -0400
+++ /home/peter/src/drivers/cpufq/cpufq.c	2013-10-01 09:40:18.996316926 -0400
@@ -0,0 +1,26 @@
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/cpufreq.h>
+
+
+static int cpufq_init(void)
+{
+	unsigned int freq = cpufreq_get(0);
+
+	pr_info("cpu 0 frequency: %u\n", freq);
+	return 0;
+}
+
+static void cpufq_exit(void)
+{
+}
+
+module_init(cpufq_init);
+module_exit(cpufq_exit);
+
+MODULE_LICENSE("GPL");
+
