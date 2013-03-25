Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab3CYNrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:47:35 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:52244 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757818Ab3CYNre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:47:34 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] sound: oss: uart401: Used kmemdup instead of kmalloc and memcpy
Date: Mon, 25 Mar 2013 15:46:49 +0200
Message-Id: <1364219209-11807-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used kmemdup instead of replicating it's behaviour with kmalloc followed
by memcpy.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 sound/oss/uart401.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/oss/uart401.c b/sound/oss/uart401.c
index 8e514a6..5433c6f 100644
--- a/sound/oss/uart401.c
+++ b/sound/oss/uart401.c
@@ -352,23 +352,26 @@ int probe_uart401(struct address_info *hw_config, struct module *owner)
 		goto cleanup_irq;
 	}
 	conf_printf(name, hw_config);
-	midi_devs[devc->my_dev] = kmalloc(sizeof(struct midi_operations), GFP_KERNEL);
+	midi_devs[devc->my_dev] = kmemdup(&uart401_operations,
+					  sizeof(struct midi_operations),
+					  GFP_KERNEL);
 	if (!midi_devs[devc->my_dev]) {
 		printk(KERN_ERR "uart401: Failed to allocate memory\n");
 		goto cleanup_unload_mididev;
 	}
-	memcpy(midi_devs[devc->my_dev], &uart401_operations, sizeof(struct midi_operations));
 
 	if (owner)
 		midi_devs[devc->my_dev]->owner = owner;
 	
 	midi_devs[devc->my_dev]->devc = devc;
-	midi_devs[devc->my_dev]->converter = kmalloc(sizeof(struct synth_operations), GFP_KERNEL);
+	midi_devs[devc->my_dev]->converter = kmemdup(&std_midi_synth,
+						     sizeof(struct synth_operations),
+						     GFP_KERNEL);
+
 	if (!midi_devs[devc->my_dev]->converter) {
 		printk(KERN_WARNING "uart401: Failed to allocate memory\n");
 		goto cleanup_midi_devs;
 	}
-	memcpy(midi_devs[devc->my_dev]->converter, &std_midi_synth, sizeof(struct synth_operations));
 	strcpy(midi_devs[devc->my_dev]->info.name, name);
 	midi_devs[devc->my_dev]->converter->id = "UART401";
 	midi_devs[devc->my_dev]->converter->midi_dev = devc->my_dev;
-- 
1.7.9.5

