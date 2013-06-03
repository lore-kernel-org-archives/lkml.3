Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943Ab3FCWZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:25:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645Ab3FCWLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:11:55 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=E_01eQ8_LXMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=iq5bJfM2-h4A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=MSl-tDqOz04A:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=b92XQqyOg-e1Bq7J:21 a=TZAx_CBMticqeaDO:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221152.975893502@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wang YanQing <udknight@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [05/65] ALSA: HDA: Fix Oops caused by dereference NULL pointer
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0005-ALSA-HDA-Fix-Oops-caused-by-dereference-NULL-pointer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wang YanQing <udknight@gmail.com>

[ Upstream commit 2195b063f6609e4c6268f291683902f25eaf9aa6 ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/pci/hda/hda_codec.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 558b6b0..693e890 100644
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
1.7.10.4


