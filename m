Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaKYKHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:07:13 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50547 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaKYKHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:07:07 -0500
Date: Tue, 25 Nov 2014 02:07:03 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudley.dulixin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] [PATCH] next: cyapa: fix inop touchpad after resume on Acer
 C720
Message-ID: <20141125100703.GA9287@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudley.dulixin@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124085059.GA15770@hudson.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an Acer C720 running linux-next (20141124) the touchpad will become
inoperative after a resume.  Reloading the cyapa driver restores normal
operation.

The following trace appeared in dmesg after a resume.

  [   21.803878] ------------[ cut here ]------------
  [   21.803886] WARNING: CPU: 0 PID: 901 at kernel/irq/manage.c:444 enable_irq+0x3a/0x80()
  [   21.803886] Unbalanced enable for IRQ 0
  [   21.803927] Modules linked in: binfmt_misc bnep ecb ath3k btusb bluetooth uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc arc4 ath9k snd_hda_codec_hdmi ath9k_common ath9k_hw ath tpm_infineon mac80211 i915 joydev x86_pkg_temp_thermal iTCO_wdt intel_powerclamp cyapa iTCO_vendor_support intel_rapl iosf_mbi coretemp kvm_intel kvm cfg80211 snd_hda_codec_realtek snd_hda_codec_generic chromeos_laptop crct10dif_pclmul crc32_pclmul i2c_algo_bit crc32c_intel snd_hda_intel drm_kms_helper xhci_pci xhci_hcd ghash_clmulni_intel snd_hda_controller snd_hda_codec cryptd rfkill drm usbcore evdev pcspkr snd_hwdep serio_raw snd_pcm i2c_i801 shpchp snd_timer usb_common lpc_ich snd tpm_tis mfd_core video i2c_designware_pci
  [   21.803941]  tpm battery ac soundcore i2c_designware_platform i2c_designware_core i2c_core processor button fuse autofs4 ext4 crc16 mbcache jbd2 sg sd_mod ahci libahci libata scsi_mod fan thermal thermal_sys sdhci_acpi sdhci mmc_core
  [   21.803945] CPU: 0 PID: 901 Comm: systemd-sleep Not tainted 3.18.0-rc5-next-20141121 #50
  [   21.803946] Hardware name: Acer Peppy, BIOS          04/30/2014
  [   21.803949]  0000000000000000 ffffffff81725091 ffffffff81535c6c ffff8800740cbc78
  [   21.803951]  ffffffff81069f61 ffff880100405400 0000000000000000 ffff88006c9c1c20
  [   21.803953]  ffff88006ae73220 0000000000000010 ffffffff81069fda ffffffff8171bbb8
  [   21.803953] Call Trace:
  [   21.803959]  [<ffffffff81535c6c>] ? dump_stack+0x40/0x50
  [   21.803964]  [<ffffffff81069f61>] ? warn_slowpath_common+0x81/0xb0
  [   21.803967]  [<ffffffff81069fda>] ? warn_slowpath_fmt+0x4a/0x50
  [   21.803969]  [<ffffffff810b9792>] ? __irq_get_desc_lock+0x52/0x90
  [   21.803971]  [<ffffffff810bb32a>] ? enable_irq+0x3a/0x80
  [   21.803976]  [<ffffffffa0412535>] ? cyapa_resume+0x85/0xb0 [cyapa]
  [   21.803984]  [<ffffffffa01c3e90>] ? i2c_device_pm_thaw+0x40/0x40 [i2c_core]
  [   21.803988]  [<ffffffff813ce85a>] ? dpm_run_callback+0x4a/0x100
  [   21.803991]  [<ffffffff813cedd6>] ? device_resume+0xd6/0x210
  [   21.803994]  [<ffffffff813d02c9>] ? dpm_resume+0x109/0x2c0
  [   21.803997]  [<ffffffff813d07cd>] ? dpm_resume_end+0xd/0x20
  [   21.804000]  [<ffffffff810ae1e7>] ? suspend_devices_and_enter+0x137/0x630
  [   21.804003]  [<ffffffff810aea32>] ? pm_suspend+0x352/0x3d0
  [   21.804005]  [<ffffffff810ad266>] ? state_store+0x76/0xf0
  [   21.804010]  [<ffffffff8122bd5c>] ? kernfs_fop_write+0x12c/0x180
  [   21.804013]  [<ffffffff811b78a2>] ? vfs_write+0xb2/0x1f0
  [   21.804015]  [<ffffffff811b8432>] ? SyS_write+0x42/0xb0
  [   21.804018]  [<ffffffff8153b6ad>] ? system_call_fastpath+0x16/0x1b
  [   21.804020] ---[ end trace 83d258439f6abe06 ]---

Performing a bisect on the kernel revealed that the following commit
introduced the bug.

  commit b1cfa7b4388285c0f0b486f152ab0cb18612c779
  Author: Dudley Du <dudley.dulixin@gmail.com>
  Date:   Sun Nov 9 12:36:34 2014 -0800

      Input: cyapa - switch to using managed resources

      Use of managed resources simplifies error handling and device removal code.

      Signed-off-by: Dudley Du <dudl@cypress.com>
      [Dmitry: added open/close methods so cyapa_remove is no longer needed.]
      Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

The trace message "Unbalanced enable for IRQ 0" suggests there is a
problem with the interrupts.  Examing the patch which introduced the bug
revealed that the variable used to store the interrupt number was
changed from cyapa->irq to client->irq.  However, there was an old entry
in cyapa_resume() which wasn't updated and was trying to enable
interrupts using the old name.  Since it was undefined, it was trying to
enable irq 0, which produced the error.

Fix the bug by using the correct variable name in cyapa_resume().

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/input/mouse/cyapa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index c84a9eb..d8d2ccb 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -964,7 +964,7 @@ static int __maybe_unused cyapa_resume(struct device *dev)
 		dev_warn(dev, "resume: set power mode to %d failed: %d\n",
 			 power_mode, error);
 
-	enable_irq(cyapa->irq);
+	enable_irq(client->irq);
 
 	mutex_unlock(&input->mutex);
 
-- 
2.1.3


-- 
- Jeremiah Mahler
