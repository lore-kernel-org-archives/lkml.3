Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213Ab3E1D4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52474 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758770Ab3E1DyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>,
        "Wang YanQing" <udknight@gmail.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.358315384@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [14/94] ALSA: HDA: Fix Oops caused by dereference NULL pointer
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/hda_codec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -615,6 +615,9 @@ int snd_hda_queue_unsol_event(struct hda
 	struct hda_bus_unsolicited *unsol;
 	unsigned int wp;
 
+	if (!bus || !bus->workq)
+		return 0;
+
 	trace_hda_unsol_event(bus, res, res_ex);
 	unsol = bus->unsol;
 	if (!unsol)

