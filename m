Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258Ab3CZT4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:56:09 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:48994 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3CZT4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:56:06 -0400
Date: Tue, 26 Mar 2013 20:56:01 +0100
From: Michal Hocko <mhocko@suse.cz>
To: dri-devel@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>, Ilija Hadzic <ilijahadzic@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Marco Munderloh <munderl@tnt.uni-hannover.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm: fix i_mapping and f_mapping initialization in drm_open
 in error path
Message-ID: <20130326195601.GA5124@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
the patch bellow fixes a nullptr dereference reported with OpenSUSE12.3.
I am not familiar with the area so I have no idea whether this is the
right way to go but after applying this patch the problem is not
reproducible anymore.
If the patch is correct then please mark it for stable (3.7+).

Thanks!
---
>From a786a701bd6c277329e2b788fea9a69b1c3ced2e Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 26 Mar 2013 19:04:40 +0100
Subject: [PATCH] drm: fix i_mapping and f_mapping initialization in drm_open
 in error path

Starting with fdb40a08 (drm: set dev_mapping before calling
drm_open_helper) inode and file mappings are set to old_mapping in the
error path. old_mapping can be NULL, however, which is handled by
initializing dev_mapping to default inode->i_data. old_mapping is left
intact though so the both inode's and filep's mapping will still point
to NULL which is unexpected and can it results in crashes later one.

Marco Munderloh has reported such crashes:
 BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
 IP: [<ffffffff81190be4>] drop_pagecache_sb+0x74/0xe0
 PGD 252bc1067 PUD 253d11067 PMD 0
 Oops: 0000 [#1] SMP
 Modules linked in: fuse af_packet xt_tcpudp xt_pkttype xt_LOG xt_limit bnep bluetooth ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq snd_hda_codec_hdmi mperf coretemp snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep kvm_intel snd_pcm arc4 snd_seq snd_timer snd_seq_device kvm iwldvm mac80211 snd uvcvideo crc32c_intel videobuf2_core videodev ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw videobuf2_vmalloc aes_x86_64 iTCO_wdt xts tpm_infineon mei r8169 videobuf2_memops iTCO_vendor_support sr_mod lpc_ich iwlwifi gf128mul sony_laptop rts_pstor(C) cdrom i2c_i801 tpm_tis tpm tpm_bios battery mfd_core soundcore snd_page_alloc cfg80211 rfkill ac sg microcode pcspkr autofs4 xhci_hcd ehci_hcd usbcore usb_common radeon i915 video ttm drm_kms_helper drm i2c_algo_bit thermal button processor thermal_sys scsi_dh_emc scsi_dh_rdac scsi_dh_hp_sw scsi_dh_alua
scsi_dh
 CPU 0
 Pid: 1452, comm: bash Tainted: G         C   3.7.10-1.1-default
ation VPCSA4W9E/VAIO
 RIP: 0010:[<ffffffff81190be4>]  [<ffffffff81190be4>] drop_pagecache_sb+0x74/0xe0
 RSP: 0018:ffff880252bc9e18  EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffff88024ecb7db0 RCX: 0000000000000002
 RDX: 0000000000000007 RSI: ffff88024f63a670 RDI: ffff88024ecb7e38
 RBP: ffff88024ecb7e38 R08: dead000000200200 R09: 0000000000000000
 R10: 0000000000000001 R11: 0000000000000210 R12: ffff880254d588a0
 R13: ffff88024fcb25e8 R14: ffffffff81190b70 R15: ffffffffffffffea
 FS:  00007fad2b9ed700(0000) GS:ffff88025fa00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000058 CR3: 0000000252ad2000 CR4: 00000000000407f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process bash (pid: 1452, threadinfo ffff880252bc8000, task ffff880253d321c0)
 Stack:
  0000000000000001 ffff880254d58800 ffff880254e94800 ffff880254d58868
  0000000000000000 ffffffff8116a499 0000000000000000 0000000000000001
  ffffffff81a228a0 ffff880252bc9f50 0000000000000002 ffffffff81190cce
 Call Trace:
  [<ffffffff8116a499>] iterate_supers+0xd9/0xe0
  [<ffffffff81190cce>] drop_caches_sysctl_handler+0x7e/0x90
  [<ffffffff811d0e26>] proc_sys_call_handler.isra.10+0xc6/0xe0
  [<ffffffff81166fd7>] vfs_write+0xa7/0x180
  [<ffffffff81167321>] sys_write+0x51/0xa0
  [<ffffffff8154f2ed>] system_call_fastpath+0x1a/0x1f
  [<00007fad2ae959c0>] 0x7fad2ae959bf
 Code: 01 00 00 49 39 c4 48 8d 98 00 ff ff ff 74 68 48 8d ab 88 00 00 00 48 89 ef e8 49 69 3b 00 f6 83 a0 00 00 00 38 75 d0 48 8b 43 30 <48> 83 78 58 00 74 c5 48 89 df e8 dd ef fe ff 66 83 45 00 01 66
 RIP  [<ffffffff81190be4>] drop_pagecache_sb+0x74/0xe0
  RSP <ffff880252bc9e18>
 CR2: 0000000000000058

when dropping caches when inode with NULL i_mapping is encountered. Or a
different one when umounting devtmpfs:
 BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
 IP: [<ffffffff81122001>] shmem_evict_inode+0x11/0x130
 PGD 0
 Oops: 0000 [#1] SMP
 Modules linked in: xt_tcpudp xt_pkttype xt_LOG xt_limit af_packet ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack bnep bluetooth ip6table_filter ip6_tables cpufreq_conservative x_tables cpufreq_userspace cpufreq_powersave snd_hda_codec_hdmi snd_hda_codec_realtek acpi_cpufreq snd_hda_intel mperf snd_hda_codec coretemp snd_hwdep kvm_intel snd_pcm kvm arc4 snd_seq iwldvm mac80211 crc32c_intel ghash_clmulni_intel snd_timer aesni_intel snd_seq_device iTCO_wdt uvcvideo videobuf2_core iwlwifi videodev sony_laptop videobuf2_vmalloc videobuf2_memops ablk_helper iTCO_vendor_support cryptd cfg80211 tpm_infineon r8169 sr_mod cdrom mei snd lpc_ich battery lrw aes_x86_64 xts rfkill i2c_i801 pcspkr mfd_core tpm_tis ac gf128mul tpm tpm_bios soundcore snd_page_alloc sg microcode autofs4 xhci_hcd ehci_hcd radeon(-) i915 ttm drm_kms_helper usbcore usb_common drm thermal i2c_algo_bit video button processor thermal_sys scsi_dh_emc scsi_dh_rdac scsi_dh_hp_sw scsi_dh_alua scsi_dh
 CPU 1 <4>[   44.175256] Pid: 29, comm: kdevtmpfs Tainted: G        W    3.7.10-1-default-patched #4 Sony Corpora
tion VPCSA4W9E/VAIO
 RIP: 0010:[<ffffffff81122001>]  [<ffffffff81122001>] shmem_evict_inode+0x11/0x130
 RSP: 0018:ffff880254ed3d18  EFLAGS: 00010296
 RAX: 0000000000000000 RBX: ffff88024fb185e8 RCX: 0000000000000034
 RDX: 0000000000002433 RSI: 0000000000000c11 RDI: ffff88024fb185e8
 RBP: ffff88024fb186e8 R08: 1038000000000000 R09: 024fb186881c0000
 R10: fd924f0d6445a207 R11: 0000000000000000 R12: ffffffff8161b640
 R13: ffff88024fb185e8 R14: 0000000000000000 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff88025fa40000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000068 CR3: 0000000001a0c000 CR4: 00000000000407e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process kdevtmpfs (pid: 29, threadinfo ffff880254ed2000, task ffff880254ed0080)
 Stack:
  ffff88024fb185e8 ffff88024fb185e8 ffff88024fb186e8 ffffffff8161b640
  0000000000000000 ffffffff8117f5f3 ffff88024e453a80 ffff88024fb185e8
  0000000000000000 ffffffff8117b778 0000000000000000 ffff88024e453a80
 Call Trace:
  [<ffffffff8117f5f3>] evict+0xa3/0x190
  [<ffffffff8117b778>] d_delete+0x148/0x180
  [<ffffffff81171d77>] vfs_unlink+0xf7/0x110
  [<ffffffff81386ab2>] handle_remove+0x202/0x250
  [<ffffffff81386de5>] devtmpfsd+0xd5/0x130
  [<ffffffff81066273>] kthread+0xb3/0xc0
  [<ffffffff81549c3c>] ret_from_fork+0x7c/0xb0
 Code: 7b 30 b9 01 00 00 00 31 d2 4c 89 f6 e8 69 e3 00 00 e9 23 ff ff ff 0f 1f 40 00 41 55 49 89 fd 41 54 55 53 48 83 ec 08 48 8b 47 30 <48> 81 78 68 00 b7 61 81 74 75 48 8b 7f a8 4d 8d 65 90 e8 b8 1f
 RIP  [<ffffffff81122001>] shmem_evict_inode+0x11/0x130
 RSP <ffff880254ed3d18>
 CR2: 0000000000000068

This patch fixes that by initializating old_mapping to the inode->i_data
same as dev_mapping.

Reported-and-tested-by: Marco Munderloh <munderl@tnt.uni-hannover.de>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 drivers/gpu/drm/drm_fops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 133b413..62a5435 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -139,7 +139,7 @@ int drm_open(struct inode *inode, struct file *filp)
 	mutex_lock(&dev->struct_mutex);
 	old_mapping = dev->dev_mapping;
 	if (old_mapping == NULL)
-		dev->dev_mapping = &inode->i_data;
+		dev->dev_mapping = old_mapping = &inode->i_data;
 	/* ihold ensures nobody can remove inode with our i_data */
 	ihold(container_of(dev->dev_mapping, struct inode, i_data));
 	inode->i_mapping = dev->dev_mapping;
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
