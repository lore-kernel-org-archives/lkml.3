Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaHZPrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:47:53 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:50845 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaHZPrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:47:51 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] xhci-ring: Fix Null pointer dereference
Date: Tue, 26 Aug 2014 17:47:41 +0200
Message-Id: <1409068061-10855-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing a usb gadget I managed to crash completely the host
computer. This was due to a NULL pointer derefence.

This patch avoids the crash although the kernel still outputs some
warnings.

Without this patch, kernels from (at least) 3.14 can be crashed with
mass storage gadgets.

Affected host:  NEC Corporation uPD720200 USB 3.0

Aug 26 17:34:37 neopili kernel: [ 4767.480159] ------------[ cut here ]------------
Aug 26 17:34:37 neopili kernel: [ 4767.480176] WARNING: CPU: 0 PID: 10185 at drivers/usb/host/xhci-ring.c:518 xhci_cleanup_stalled_ring+0x67/0x220 [xhci_hcd]()
Aug 26 17:34:37 neopili kernel: [ 4767.480179] Modules linked in: xhci_hcd uas usb_storage bnep pci_stub cpufreq_stats vboxpci(O) cpufreq_powersave cpufreq_conservative vboxnetadp(O) cpufreq_userspace vboxnetflt(O) vboxdrv(O) binfmt_misc tun arc4 iwldvm mac80211 snd_hda_codec_hdmi ecb snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec btusb x86_pkg_temp_thermal snd_hwdep snd_pcm_oss intel_powerclamp bluetooth intel_rapl coretemp snd_mixer_oss iTCO_wdt uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core kvm_intel snd_pcm v4l2_common videodev media iTCO_vendor_support kvm iwlwifi cfg80211 snd_timer joydev crc32_pclmul ghash_clmulni_intel thinkpad_acpi nvram snd aesni_intel evdev lpc_ich soundcore ac rfkill mfd_core aes_x86_64 psmouse serio_raw pcspkr lrw gf128mul glue_helper ablk_helper tpm_tis cryptd video i2c_i801 tpm shpchp processor button battery wmi nvidia(PO) i2c_core hdaps(O) tp_smapi(O)
thinkpad_ec(O) loop firewire_sbp2 fuse parport_pc ppdev lp parport autofs4 ext4 crc16 mbcache jbd2 sg sd_mod sr_mod crc_t10dif cdrom crct10dif_generic hid_generic usbhid hid crct10dif_pclmul crct10dif_common crc32c_intel ahci libahci libata sdhci_pci scsi_mod sdhci firewire_ohci ehci_pci firewire_core mmc_core ehci_hcd crc_itu_t e1000e usbcore ptp usb_common pps_core thermal thermal_sys [last unloaded: xhci_hcd]
Aug 26 17:34:37 neopili kernel: [ 4767.480309] CPU: 0 PID: 10185 Comm: usb-storage Tainted: P        W  O  3.16.0+ #2
Aug 26 17:34:37 neopili kernel: [ 4767.480312] Hardware name: LENOVO 4284HE2/4284HE2, BIOS 8BET62WW (1.42 ) 07/26/2013
Aug 26 17:34:37 neopili kernel: [ 4767.480315]  0000000000000009 ffffffff814ef2dd 0000000000000000 ffffffff81064c12
Aug 26 17:34:37 neopili kernel: [ 4767.480320]  ffff88056e044210 ffff880589eb4000 0000000000000002 ffff8800be1b7800
Aug 26 17:34:37 neopili kernel: [ 4767.480325]  ffff880589eb4048 ffffffffa11eae07 ffff88055d91bc10 0000000000000000
Aug 26 17:34:37 neopili kernel: [ 4767.480329] Call Trace:
Aug 26 17:34:37 neopili kernel: [ 4767.480342]  [<ffffffff814ef2dd>] ? dump_stack+0x41/0x51
Aug 26 17:34:37 neopili kernel: [ 4767.480349]  [<ffffffff81064c12>] ? warn_slowpath_common+0x72/0x90
Aug 26 17:34:37 neopili kernel: [ 4767.480357]  [<ffffffffa11eae07>] ? xhci_cleanup_stalled_ring+0x67/0x220 [xhci_hcd]
Aug 26 17:34:37 neopili kernel: [ 4767.480363]  [<ffffffffa11eb11e>] ? xhci_endpoint_reset+0x15e/0x1d0 [xhci_hcd]
Aug 26 17:34:37 neopili kernel: [ 4767.480382]  [<ffffffffa003c305>] ? usb_enable_endpoint+0x75/0x80 [usbcore]
Aug 26 17:34:37 neopili kernel: [ 4767.480398]  [<ffffffffa003c34d>] ? usb_enable_interface+0x3d/0x50 [usbcore]
Aug 26 17:34:37 neopili kernel: [ 4767.480413]  [<ffffffffa0030e12>] ? usb_reset_and_verify_device+0x642/0x770 [usbcore]
Aug 26 17:34:37 neopili kernel: [ 4767.480427]  [<ffffffffa003105d>] ? usb_reset_device+0x11d/0x290 [usbcore]
Aug 26 17:34:37 neopili kernel: [ 4767.480434]  [<ffffffffa10eac29>] ? usb_stor_port_reset+0x59/0x60 [usb_storage]
Aug 26 17:34:37 neopili kernel: [ 4767.480439]  [<ffffffffa10eacb1>] ? usb_stor_invoke_transport+0x81/0x510 [usb_storage]
Aug 26 17:34:37 neopili kernel: [ 4767.480447]  [<ffffffff814f230e>] ? wait_for_completion_interruptible+0xbe/0x210
Aug 26 17:34:37 neopili kernel: [ 4767.480452]  [<ffffffff81093bc0>] ? wake_up_state+0x10/0x10
Aug 26 17:34:37 neopili kernel: [ 4767.480458]  [<ffffffffa10ec4b8>] ? usb_stor_control_thread+0x168/0x290 [usb_storage]
Aug 26 17:34:37 neopili kernel: [ 4767.480464]  [<ffffffffa10ec350>] ? usb_stor_disconnect+0xc0/0xc0 [usb_storage]
Aug 26 17:34:37 neopili kernel: [ 4767.480470]  [<ffffffff8108534a>] ? kthread+0xca/0xe0
Aug 26 17:34:37 neopili kernel: [ 4767.480476]  [<ffffffff81067647>] ? do_exit+0x847/0xab0
Aug 26 17:34:37 neopili kernel: [ 4767.480481]  [<ffffffff81085280>] ? kthread_create_on_node+0x180/0x180
Aug 26 17:34:37 neopili kernel: [ 4767.480486]  [<ffffffff814f4e3c>] ? ret_from_fork+0x7c/0xb0
Aug 26 17:34:37 neopili kernel: [ 4767.480491]  [<ffffffff81085280>] ? kthread_create_on_node+0x180/0x180
Aug 26 17:34:37 neopili kernel: [ 4767.480494] ---[ end trace e627648c2935c96e ]---
Aug 26 17:34:37 neopili kernel: [ 4767.480500] xhci_hcd 0000:0e:00.0: WARN Cannot submit Set TR Deq Ptr
Aug 26 17:34:37 neopili kernel: [ 4767.480504] xhci_hcd 0000:0e:00.0: WARN deq seg =           (null), deq pt = ffff8805516d7800

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/host/xhci-ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 60fb52a..7767481 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -613,7 +613,8 @@ void xhci_queue_new_dequeue_state(struct xhci_hcd *xhci,
 			"Set TR Deq Ptr cmd, new deq seg = %p (0x%llx dma), "
 			"new deq ptr = %p (0x%llx dma), new cycle = %u",
 			deq_state->new_deq_seg,
-			(unsigned long long)deq_state->new_deq_seg->dma,
+			(unsigned long long)(deq_state->new_deq_seg) ?
+				deq_state->new_deq_seg->dma : 0,
 			deq_state->new_deq_ptr,
 			(unsigned long long)xhci_trb_virt_to_dma(deq_state->new_deq_seg, deq_state->new_deq_ptr),
 			deq_state->new_cycle_state);
-- 
2.1.0

