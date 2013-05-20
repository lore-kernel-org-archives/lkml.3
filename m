Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab3ETKxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:53:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab3ETKxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wang YanQing <udknight@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 068/115] ALSA: HDA: Fix Oops caused by dereference NULL pointer
Date: Mon, 20 May 2013 11:51:08 +0100
Message-Id: <1369047116-9378-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang YanQing <udknight@gmail.com>

commit 2195b063f6609e4c6268f291683902f25eaf9aa6 upstream.

The interrupt handler azx_interrupt will call azx_update_rirb,
which may call snd_hda_queue_unsol_event, snd_hda_queue_unsol_event
will dereference chip->bus pointer.

The problem is we alloc chip->bus in azx_codec_create
which will be called after we enable IRQ and enable unsolicited
event in azx_probe.

This will cause Oops due dereference NULL pointer. I meet it, good luck:)

[Rearranged the NULL check before the tracepoint and added another
 NULL check of bus->workq -- tiwai]

Signed-off-by: Wang YanQing <udknight@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_codec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index e6b34c8..f33bb78 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -609,6 +609,9 @@ int snd_hda_queue_unsol_event(struct hda_bus *bus, u32 res, u32 res_ex)
 	struct hda_bus_unsolicited *unsol;
 	unsigned int wp;
 
+	if (!bus || !bus->workq)
+		return 0;
+
 	trace_hda_unsol_event(bus, res, res_ex);
 	unsol = bus->unsol;
 	if (!unsol)
-- 
1.8.1.2

