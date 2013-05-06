Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab3EFVDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:03:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712Ab3EFUqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 059/115] ALSA: emu10k1: Fix dock firmware loading
Date: Mon,  6 May 2013 13:44:55 -0700
Message-Id: <20130506203101.601210703@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit e08b34e86dfdb72a62196ce0f03d33f48958d8b9 upstream.

The commit [b209c4df: ALSA: emu10k1: cache emu1010 firmware] broke the
firmware loading of the dock, just (mistakenly) ignoring a different
firmware for docks on some models.  This patch revives them again.

Bugzilla: https://bugs.archlinux.org/task/34865
Reported-and-tested-by: Tobias Powalowski <tobias.powalowski@googlemail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/sound/emu10k1.h          |    1 +
 sound/pci/emu10k1/emu10k1_main.c |   39 +++++++++++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 6 deletions(-)

--- a/include/sound/emu10k1.h
+++ b/include/sound/emu10k1.h
@@ -1787,6 +1787,7 @@ struct snd_emu10k1 {
 	unsigned int next_free_voice;
 
 	const struct firmware *firmware;
+	const struct firmware *dock_fw;
 
 #ifdef CONFIG_PM_SLEEP
 	unsigned int *saved_ptr;
--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -657,14 +657,14 @@ static int snd_emu10k1_cardbus_init(stru
 	return 0;
 }
 
-static int snd_emu1010_load_firmware(struct snd_emu10k1 *emu)
+static int snd_emu1010_load_firmware(struct snd_emu10k1 *emu,
+				     const struct firmware *fw_entry)
 {
 	int n, i;
 	int reg;
 	int value;
 	unsigned int write_post;
 	unsigned long flags;
-	const struct firmware *fw_entry = emu->firmware;
 
 	if (!fw_entry)
 		return -EIO;
@@ -725,9 +725,34 @@ static int emu1010_firmware_thread(void
 			/* Return to Audio Dock programming mode */
 			snd_printk(KERN_INFO "emu1010: Loading Audio Dock Firmware\n");
 			snd_emu1010_fpga_write(emu, EMU_HANA_FPGA_CONFIG, EMU_HANA_FPGA_CONFIG_AUDIODOCK);
-			err = snd_emu1010_load_firmware(emu);
-			if (err != 0)
-				continue;
+
+			if (!emu->dock_fw) {
+				const char *filename = NULL;
+				switch (emu->card_capabilities->emu_model) {
+				case EMU_MODEL_EMU1010:
+					filename = DOCK_FILENAME;
+					break;
+				case EMU_MODEL_EMU1010B:
+					filename = MICRO_DOCK_FILENAME;
+					break;
+				case EMU_MODEL_EMU1616:
+					filename = MICRO_DOCK_FILENAME;
+					break;
+				}
+				if (filename) {
+					err = request_firmware(&emu->dock_fw,
+							       filename,
+							       &emu->pci->dev);
+					if (err)
+						continue;
+				}
+			}
+
+			if (emu->dock_fw) {
+				err = snd_emu1010_load_firmware(emu, emu->dock_fw);
+				if (err)
+					continue;
+			}
 
 			snd_emu1010_fpga_write(emu, EMU_HANA_FPGA_CONFIG, 0);
 			snd_emu1010_fpga_read(emu, EMU_HANA_IRQ_STATUS, &reg);
@@ -862,7 +887,7 @@ static int snd_emu10k1_emu1010_init(stru
 			   filename, emu->firmware->size);
 	}
 
-	err = snd_emu1010_load_firmware(emu);
+	err = snd_emu1010_load_firmware(emu, emu->firmware);
 	if (err != 0) {
 		snd_printk(KERN_INFO "emu1010: Loading Firmware failed\n");
 		return err;
@@ -1253,6 +1278,8 @@ static int snd_emu10k1_free(struct snd_e
 		kthread_stop(emu->emu1010.firmware_thread);
 	if (emu->firmware)
 		release_firmware(emu->firmware);
+	if (emu->dock_fw)
+		release_firmware(emu->dock_fw);
 	if (emu->irq >= 0)
 		free_irq(emu->irq, emu);
 	/* remove reserved page */


