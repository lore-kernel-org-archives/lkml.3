Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab3EGD1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:27:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50034 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab3EGD1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:27:49 -0400
Date: Tue, 7 May 2013 11:27:33 +0800
From: Wang YanQing <udknight@gmail.com>
To: tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org, perex@perex.cz,
        david.henningsson@canonical.com
Subject: [PATCH]ALSA: HDA: Fix Oops caused by dereference NULL pointer
Message-ID: <20130507032733.GA29944@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, tiwai@suse.de,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
	perex@perex.cz, david.henningsson@canonical.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt handler azx_interrupt will call azx_update_rirb,
which may call snd_hda_queue_unsol_event, snd_hda_queue_unsol_event
will dereference chip->bus pointer.

The problem is we alloc chip->bus in azx_codec_create
which will be called after we enable IRQ and enable unsolicited
event in azx_probe.

This will cause Oops due dereference NULL pointer. I meet it, good luck:)

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 sound/pci/hda/hda_codec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 622f726..9c76752 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -618,6 +618,9 @@ int snd_hda_queue_unsol_event(struct hda_bus *bus, u32 res, u32 res_ex)
 	unsigned int wp;
 
 	trace_hda_unsol_event(bus, res, res_ex);
+	if (!bus)
+		return 0;
+
 	unsol = bus->unsol;
 	if (!unsol)
 		return 0;
-- 
1.7.12.4.dirty
