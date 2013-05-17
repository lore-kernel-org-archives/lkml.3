Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab3EQW1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:27:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab3EQVhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wang YanQing <udknight@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 010/102] ALSA: HDA: Fix Oops caused by dereference NULL pointer
Date: Fri, 17 May 2013 14:35:25 -0700
Message-Id: <20130517213245.392177743@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -681,6 +681,9 @@ int snd_hda_queue_unsol_event(struct hda
 	struct hda_bus_unsolicited *unsol;
 	unsigned int wp;
 
+	if (!bus || !bus->workq)
+		return 0;
+
 	trace_hda_unsol_event(bus, res, res_ex);
 	unsol = bus->unsol;
 	if (!unsol)


