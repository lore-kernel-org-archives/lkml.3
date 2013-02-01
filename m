Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab3BATvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 14:51:21 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:35619 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab3BATuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 14:50:55 -0500
From: Mark Einon <mark.einon@gmail.com>
To: stefanr@s5r6.in-berlin.de
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, stern@rowland.harvard.edu,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH v2] firewire: Fix ohci free_irq() warning
Date: Fri,  1 Feb 2013 19:50:45 +0000
Message-Id: <1359748245-3674-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359410988-3740-1-git-send-email-mark.einon@gmail.com>
References: <1359410988-3740-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the kernel warning generated when putting an MSI MS-1727
GT740 laptop into suspend mode. The call sequence in this case calls
free_irq() twice, once in pci_remove() and once then in pci_suspend().

[  262.299486] WARNING: at /build/buildd/linux-3.5.0/kernel/irq/manage.c:1198 __free_irq+0xa3/0x1e0()
[  262.299487] Hardware name: MS-1727
[  262.299488] Trying to free already-free IRQ 16
[  262.299488] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables xt_state ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter snd_hda_codec_hdmi ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables bridge stp llc joydev arc4 parport_pc ppdev coretemp kvm_intel snd_hda_codec_realtek kvm microcode snd_seq_midi snd_rawmidi psmouse snd_seq_midi_event serio_raw nvidia(PO) i7core_edac snd_seq edac_core snd_hda_intel iwlwifi snd_hda_codec jmb38x_ms snd_hwdep mac80211 snd_pcm lpc_ich memstick snd_seq_device cfg80211 snd_timer snd soundcore snd_page_alloc ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_sanyo_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rfcomm bnep rc_rc6_mce mxm_wmi ene_ir rc_core bluetooth wmi video acpiphp mac_hid lp parport binfmt_misc hid_generic usbhid hid firewire_ohci sdhci_pci r8169 firewire_core sdhci crc_itu_t
[  262.299537] Pid: 4, comm: kworker/0:0 Tainted: P           O 3.5.0-22-generic #34-Ubuntu
[  262.299538] Call Trace:
[  262.299540]  [<ffffffff81051c1f>] warn_slowpath_common+0x7f/0xc0
[  262.299545]  [<ffffffff81051d16>] warn_slowpath_fmt+0x46/0x50
[  262.299548]  [<ffffffff8103fa39>] ? default_spin_lock_flags+0x9/0x10
[  262.299551]  [<ffffffff810df6b3>] __free_irq+0xa3/0x1e0
[  262.299554]  [<ffffffff810df844>] free_irq+0x54/0xc0
[  262.299558]  [<ffffffffa005a27e>] pci_remove+0x6e/0x210 [firewire_ohci]
[  262.299564]  [<ffffffff8135ae7f>] pci_device_remove+0x3f/0x110
[  262.299569]  [<ffffffff8141fdbc>] __device_release_driver+0x7c/0xe0
[  262.299573]  [<ffffffff8141fe4c>] device_release_driver+0x2c/0x40
[  262.299576]  [<ffffffff8141f5f1>] bus_remove_device+0xe1/0x120
[  262.299578]  [<ffffffff8141cd1a>] device_del+0x12a/0x1c0
[  262.299581]  [<ffffffff8141cdc6>] device_unregister+0x16/0x30
[  262.299583]  [<ffffffff81354784>] pci_stop_bus_device+0x94/0xa0
[  262.299588]  [<ffffffffa0091c67>] acpiphp_disable_slot+0xb7/0x1a0 [acpiphp]
[  262.299594]  [<ffffffffa0090716>] ? get_slot_status+0x46/0xc0 [acpiphp]
[  262.299599]  [<ffffffffa0091d7d>] acpiphp_check_bridge.isra.15+0x2d/0xf0 [acpiphp]
[  262.299604]  [<ffffffffa0092442>] _handle_hotplug_event_bridge+0x372/0x4d0 [acpiphp]
[  262.299608]  [<ffffffff81390f8c>] ? acpi_os_execute_deferred+0x2f/0x34
[  262.299612]  [<ffffffff8116e22d>] ? kfree+0xed/0x110
[  262.299617]  [<ffffffff8107086a>] process_one_work+0x12a/0x420
[  262.299620]  [<ffffffffa00920d0>] ? _handle_hotplug_event_func+0x1d0/0x1d0 [acpiphp]
[  262.299625]  [<ffffffff8107141e>] worker_thread+0x12e/0x2f0
[  262.299627]  [<ffffffff810712f0>] ? manage_workers.isra.26+0x200/0x200
[  262.299629]  [<ffffffff81075f13>] kthread+0x93/0xa0
[  262.299632]  [<ffffffff8168d024>] kernel_thread_helper+0x4/0x10
[  262.299636]  [<ffffffff81075e80>] ? kthread_freezable_should_stop+0x70/0x70
[  262.299639]  [<ffffffff8168d020>] ? gs_change+0x13/0x13
[  262.299641] ---[ end trace 3f830890e076911f ]---

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/firewire/ohci.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 45912e6..8e1c7a9 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -196,6 +196,7 @@ struct fw_ohci {
 	bool csr_state_setclear_abdicate;
 	int n_ir;
 	int n_it;
+	bool irq_requested; /* pci dev irq request successful, not freed */
 	/*
 	 * Spinlock for accessing fw_ohci data.  Never call out of
 	 * this driver with this lock held.
@@ -2384,7 +2385,7 @@ static int ohci_enable(struct fw_card *card,
 
 	if (!(ohci->quirks & QUIRK_NO_MSI))
 		pci_enable_msi(dev);
-	if (request_irq(dev->irq, irq_handler,
+	if (!ohci->irq_requested && request_irq(dev->irq, irq_handler,
 			pci_dev_msi_enabled(dev) ? 0 : IRQF_SHARED,
 			ohci_driver_name, ohci)) {
 		dev_err(card->device, "failed to allocate interrupt %d\n",
@@ -2398,6 +2399,8 @@ static int ohci_enable(struct fw_card *card,
 			ohci->next_config_rom = NULL;
 		}
 		return -EIO;
+	} else {
+		ohci->irq_requested = true;
 	}
 
 	irqs =	OHCI1394_reqTxComplete | OHCI1394_respTxComplete |
@@ -3733,8 +3736,10 @@ static void pci_remove(struct pci_dev *dev)
 	 */
 
 	software_reset(ohci);
-	free_irq(dev->irq, ohci);
-
+	if (ohci->irq_requested) {
+		free_irq(dev->irq, ohci);
+		ohci->irq_requested = false;
+	}
 	if (ohci->next_config_rom && ohci->next_config_rom != ohci->config_rom)
 		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
 				  ohci->next_config_rom, ohci->next_config_rom_bus);
@@ -3766,7 +3771,10 @@ static int pci_suspend(struct pci_dev *dev, pm_message_t state)
 	int err;
 
 	software_reset(ohci);
-	free_irq(dev->irq, ohci);
+	if (ohci->irq_requested) {
+		free_irq(dev->irq, ohci);
+		ohci->irq_requested = false;
+	}
 	pci_disable_msi(dev);
 	err = pci_save_state(dev);
 	if (err) {
-- 
1.7.10.4

