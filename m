Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbaFPJTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:19:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbaFPJT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:19:29 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86-32: do not populate physnode_map for nodes without NODE_DATA
Date: Mon, 16 Jun 2014 11:19:09 +0200
Message-Id: <1402910349-3976-1-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 BUG: unable to handle kernel paging request at 000010bc
 IP: [<c031c4f9>] compaction_alloc+0xa9/0x1b0
 *pdpt = 000000003651e001 *pde = 0000000000000000
 Oops: 0000 [#1] PREEMPT SMP
 Modules linked in: cfi_drv(O) reiserfs ses enclosure usb_storage fuse binfmt_misc nfsv3 nfs_acl nfsv4 nfs fscache lockd sunrpc snd_hda_codec_hdmi nikal(PO) memainUSB(O) memainPCI(O) ppdev parport_pc lp parport intel_powerclamp kvm_intel kvm crc32_pclmul aesni_intel ablk_helper cryptd lrw aes_i586 xts gf128mul pcspkr serio_raw snd_hda_codec_realtek mptctl snd_hda_intel snd_hda_codec snd_hwdep joydev snd_pcm firewire_ohci iTCO_wdt firewire_core iTCO_vendor_support crc_itu_t snd_timer nouveau snd hp_wmi ttm sparse_keymap drm_kms_helper rfkill soundcore drm i7core_edac snd_page_alloc mxm_wmi video edac_core wmi acpi_cpufreq mperf dm_mod autofs4 af_packet loop sg tpm_tis tpm tpm_bios coretemp crc32c_intel gpio_ich mptsas mptscsih mptbase scsi_transport_sas tg3 libphy lpc_ich sr_mod cdrom mfd_core ptp pps_core nvidiafb fb_ddc i2c_algo_bit vgastate shpchp button processor thermal_sys
 CPU: 5 PID: 10087 Comm: kwin Tainted: P           O 3.11.10-60.ge7b4603-desktop #1
 Hardware name: Hewlett-Packard HP Z800 Workstation/0AECh, BIOS 786G5 v03.54 11/02/2011
 task: f69b20f0 ti: efda6000 task.ti: efda6000
 EIP: 0060:[<c031c4f9>] EFLAGS: 00210202 CPU: 5
 EIP is at compaction_alloc+0xa9/0x1b0
 EAX: 00000000 EBX: efda7d6c ECX: 000371fe EDX: 00168e02
 ESI: 001a0000 EDI: 00000000 EBP: 00000000 ESP: efda7c90
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
 CR0: 80050033 CR2: 000010bc CR3: 2e7ef000 CR4: 000007f0
 Stack:
  efda7d6c 00037e00 00038220 f6389700 001a0000 00038220 f30e944c c031c450
  f30e945c f30e9438 c0346cd6 efda7d8c efda7d9c efda7d74 c031c450 efda7d6c
  00000000 00000000 00000020 efda7d74 00000000 00000000 00000000 00000000
 Call Trace:
  [<c0346cd6>] migrate_pages+0x96/0x590
  [<c031d198>] compact_zone+0x298/0x410
  [<c031d5f7>] try_to_compact_pages+0x127/0x180
  [<c0714f82>] __alloc_pages_direct_compact+0x91/0x18f
  [<c03076ee>] __alloc_pages_nodemask+0x4ce/0x870
  [<c033d7eb>] alloc_pages_vma+0x7b/0x130
  [<c034bf93>] do_huge_pmd_anonymous_page+0x173/0x440
  [<c032474d>] handle_mm_fault+0x32d/0x6d0
  [<c071ff25>] __do_page_fault+0x1a5/0x540
  [<c071da1f>] error_code+0x67/0x6c
  [<b535532f>] 0xb535532e
 Code: 3b 6b 14 72 0f e9 03 01 00 00 3b 7b 14 90 8d 74 26 00 73 68 89 f0 c1 e8 0e 0f be 80 60 38 b2 c0 85 c0 78 4c 8b 04 85 40 38 b2 c0 <8b> 90 bc 10 00 00 03 90 b4 10 00 00 39 f2 76 35 89 f2 2b 90 b4
 EIP: [<c031c4f9>] compaction_alloc+0xa9/0x1b0 SS:ESP 0068:efda7c90
 CR2: 00000000000010bc
 ---[ end trace a53e5e76bb90d371 ]---

The error occurs in isolate_freepages() calling pfn_valid() on a pfn that's
one past the end of last zone in Node 0, and should be the first pfn of the
first zone in Node 1. Dmesg reveals that NODE_DATA for Node 1 has not been
allocated, yet physnode_map was populated for Node 1, so pfn_valid() accesses
a NULL pointer in node_data[1].

This particular kernel was missing commit f3d815cb85 ("x86/mm/numa: Fix 32-bit
kernel NUMA boot") which would make NODE_DATA allocated. However, even with
that commit the code allows a situation where NODE_DATA is not allocated for a
node, and therefore physnode_map should not be populated for the node.

This patch checks if NODE_DATA is non-NULL before populating physnode_map for
the node.

Reported-and-tested-by: Martin Konold <external.martin.konold@de.bosch.com>
Link: https://bugzilla.novell.com/show_bug.cgi?id=881727
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 arch/x86/mm/numa_32.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 47b6436..cc933ca 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -50,6 +50,11 @@ void memory_present(int nid, unsigned long start, unsigned long end)
 
 	printk(KERN_INFO "Node: %d, start_pfn: %lx, end_pfn: %lx\n",
 			nid, start, end);
+	if (!NODE_DATA(nid)) {
+		 printk(KERN_INFO "Node %d has no NODE_DATA, not populating "
+				 "physnode_map\n", nid);
+		 return;
+	}
 	printk(KERN_DEBUG "  Setting physnode_map array to node %d for pfns:\n", nid);
 	printk(KERN_DEBUG "  ");
 	start = round_down(start, PAGES_PER_SECTION);
-- 
1.8.4.5

