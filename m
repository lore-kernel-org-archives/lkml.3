Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab3BELEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:04:12 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58359 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3BELEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:04:06 -0500
From: Mark Einon <mark.einon@gmail.com>
To: stefanr@s5r6.in-berlin.de
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, stern@rowland.harvard.edu,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH v3] firewire: Fix ohci free_irq() warning
Date: Tue,  5 Feb 2013 10:58:46 +0000
Message-Id: <1360061927-3359-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359748245-3674-1-git-send-email-mark.einon@gmail.com>
References: <1359748245-3674-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the kernel warning below, generated when putting an
MSI MS-1727 GT740 laptop into suspend mode. The call sequence in this
case calls free_irq() twice, once in pci_suspend() and once then in
pci_remove().

The fix breaks up the ohci_enable() call into four separate calls -
ohci_enable_regs(), ohci_create_irq(), ohci_enable_irq() and
ohci_enable_run(). The original call sequence of ohci_enable() is replaced
by the four calls, but the ohci_enable() called from pci_resume() is
replaced by three of the calls, missing out ohci_create_irq().

Finally, a new call, ohci_disable_irq(), replaces the free_irq() in
pci_suspend() which sets the irq mask to zero.

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

Note - This patch has only been tested with a firewire controller, and
not subsequently with any devices plugged into the controller.

 drivers/firewire/ohci.c |  134 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 91 insertions(+), 43 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 45912e6..56814b8 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2242,12 +2242,69 @@ static int probe_tsb41ba3d(struct fw_ohci *ohci)
 	return 1;
 }
 
-static int ohci_enable(struct fw_card *card,
-		       const __be32 *config_rom, size_t length)
+static int ohci_create_irq(struct fw_card *card)
 {
 	struct fw_ohci *ohci = fw_ohci(card);
 	struct pci_dev *dev = to_pci_dev(card->device);
-	u32 lps, version, irqs;
+
+	if (!(ohci->quirks & QUIRK_NO_MSI))
+		pci_enable_msi(dev);
+	if (request_irq(dev->irq, irq_handler,
+			pci_dev_msi_enabled(dev) ? 0 : IRQF_SHARED,
+			ohci_driver_name, ohci)) {
+		dev_err(card->device, "failed to allocate interrupt %d\n",
+			dev->irq);
+		pci_disable_msi(dev);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void ohci_disable_irq(struct fw_ohci *ohci)
+{
+	reg_write(ohci, OHCI1394_IntMaskSet, 0);
+
+	reg_write(ohci, OHCI1394_HCControlSet,
+		  ~(OHCI1394_HCControl_linkEnable &
+		  OHCI1394_HCControl_BIBimageValid));
+
+	reg_write(ohci, OHCI1394_LinkControlSet,
+		  ~(OHCI1394_LinkControl_rcvSelfID &
+		  OHCI1394_LinkControl_rcvPhyPkt));
+}
+
+static void ohci_enable_irq(struct fw_ohci *ohci)
+{
+	int irqs = OHCI1394_reqTxComplete | OHCI1394_respTxComplete |
+		   OHCI1394_RQPkt | OHCI1394_RSPkt |
+		   OHCI1394_isochTx | OHCI1394_isochRx |
+		   OHCI1394_postedWriteErr |
+		   OHCI1394_selfIDComplete |
+		   OHCI1394_regAccessFail |
+		   OHCI1394_cycleInconsistent |
+		   OHCI1394_unrecoverableError |
+		   OHCI1394_cycleTooLong |
+		   OHCI1394_masterIntEnable;
+
+	if (param_debug & OHCI_PARAM_DEBUG_BUSRESETS)
+		irqs |= OHCI1394_busReset;
+	reg_write(ohci, OHCI1394_IntMaskSet, irqs);
+
+	reg_write(ohci, OHCI1394_HCControlSet,
+		  OHCI1394_HCControl_linkEnable |
+		  OHCI1394_HCControl_BIBimageValid);
+
+	reg_write(ohci, OHCI1394_LinkControlSet,
+		  OHCI1394_LinkControl_rcvSelfID |
+		  OHCI1394_LinkControl_rcvPhyPkt);
+}
+
+static int ohci_enable_regs(struct fw_card *card,
+			    const __be32 *config_rom, size_t length)
+{
+	struct fw_ohci *ohci = fw_ohci(card);
+	u32 lps, version;
 	int i, ret;
 
 	if (software_reset(ohci)) {
@@ -2382,53 +2439,41 @@ static int ohci_enable(struct fw_card *card,
 
 	reg_write(ohci, OHCI1394_AsReqFilterHiSet, 0x80000000);
 
-	if (!(ohci->quirks & QUIRK_NO_MSI))
-		pci_enable_msi(dev);
-	if (request_irq(dev->irq, irq_handler,
-			pci_dev_msi_enabled(dev) ? 0 : IRQF_SHARED,
-			ohci_driver_name, ohci)) {
-		dev_err(card->device, "failed to allocate interrupt %d\n",
-			dev->irq);
-		pci_disable_msi(dev);
+	return 0;
+}
+
+static void ohci_enable_run(struct fw_ohci *ohci)
+{
+	ar_context_run(&ohci->ar_request_ctx);
+	ar_context_run(&ohci->ar_response_ctx);
 
+	flush_writes(ohci);
+
+	/* We are ready to go, reset bus to finish initialization. */
+	fw_schedule_bus_reset(&ohci->card, false, true);
+}
+
+static int ohci_enable(struct fw_card *card,
+		       const __be32 *config_rom, size_t length)
+{
+	struct fw_ohci *ohci = fw_ohci(card);
+	int ret;
+
+	ohci_enable_regs(card, config_rom, length);
+
+	ret = ohci_create_irq(card);
+	if (ret) {
 		if (config_rom) {
 			dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
 					  ohci->next_config_rom,
 					  ohci->next_config_rom_bus);
 			ohci->next_config_rom = NULL;
 		}
-		return -EIO;
+		return ret;
 	}
 
-	irqs =	OHCI1394_reqTxComplete | OHCI1394_respTxComplete |
-		OHCI1394_RQPkt | OHCI1394_RSPkt |
-		OHCI1394_isochTx | OHCI1394_isochRx |
-		OHCI1394_postedWriteErr |
-		OHCI1394_selfIDComplete |
-		OHCI1394_regAccessFail |
-		OHCI1394_cycleInconsistent |
-		OHCI1394_unrecoverableError |
-		OHCI1394_cycleTooLong |
-		OHCI1394_masterIntEnable;
-	if (param_debug & OHCI_PARAM_DEBUG_BUSRESETS)
-		irqs |= OHCI1394_busReset;
-	reg_write(ohci, OHCI1394_IntMaskSet, irqs);
-
-	reg_write(ohci, OHCI1394_HCControlSet,
-		  OHCI1394_HCControl_linkEnable |
-		  OHCI1394_HCControl_BIBimageValid);
-
-	reg_write(ohci, OHCI1394_LinkControlSet,
-		  OHCI1394_LinkControl_rcvSelfID |
-		  OHCI1394_LinkControl_rcvPhyPkt);
-
-	ar_context_run(&ohci->ar_request_ctx);
-	ar_context_run(&ohci->ar_response_ctx);
-
-	flush_writes(ohci);
-
-	/* We are ready to go, reset bus to finish initialization. */
-	fw_schedule_bus_reset(&ohci->card, false, true);
+	ohci_enable_irq(ohci);
+	ohci_enable_run(ohci);
 
 	return 0;
 }
@@ -3766,7 +3811,7 @@ static int pci_suspend(struct pci_dev *dev, pm_message_t state)
 	int err;
 
 	software_reset(ohci);
-	free_irq(dev->irq, ohci);
+	ohci_disable_irq(ohci);
 	pci_disable_msi(dev);
 	err = pci_save_state(dev);
 	if (err) {
@@ -3802,10 +3847,13 @@ static int pci_resume(struct pci_dev *dev)
 		reg_write(ohci, OHCI1394_GUIDHi, (u32)(ohci->card.guid >> 32));
 	}
 
-	err = ohci_enable(&ohci->card, NULL, 0);
+	err = ohci_enable_regs(&ohci->card, NULL, 0);
 	if (err)
 		return err;
 
+	ohci_enable_irq(ohci);
+	ohci_enable_run(ohci);
+
 	ohci_resume_iso_dma(ohci);
 
 	return 0;
-- 
1.7.10.4

