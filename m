Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab3CWOpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 10:45:54 -0400
Received: from verein.lst.de ([213.95.11.211]:42298 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab3CWOpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 10:45:51 -0400
Date: Sat, 23 Mar 2013 15:38:22 +0100 (MET)
From: Torsten Duwe <torsten@lst.de>
To: David Airlie <airlied@linux.ie>, torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KMS: fix EDID detailed timing vsync parsing
In-Reply-To: <alpine.LNX.2.02.1303231531520.2097@blackhole.lst.de>
Message-ID: <alpine.LNX.2.02.1303231537190.2097@blackhole.lst.de>
References: <alpine.LNX.2.02.1303231531520.2097@blackhole.lst.de>
User-Agent: Alpine 2.02 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


EDID spreads some values across multiple bytes; bit-fiddling is needed
to retrieve these. The current code to parse "detailed timings" has a
cut&paste error that results in a vsync offset of at most 15 lines
instead of 63. en.wikipedia.org/wiki/EDID "detailed timing" bytes
10+11 show why that needs to be a left shift.

Cc: stable@vger.kernel.org
Signed-off-by: Torsten Duwe <duwe@lst.de>

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -896,7 +896,7 @@ static struct drm_display_mode *drm_mode
 	unsigned vblank = (pt->vactive_vblank_hi & 0xf) << 8 | pt->vblank_lo;
 	unsigned hsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0xc0) << 2 | pt->hsync_offset_lo;
 	unsigned hsync_pulse_width = (pt->hsync_vsync_offset_pulse_width_hi & 0x30) << 4 | pt->hsync_pulse_width_lo;
-	unsigned vsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0xc) >> 2 | pt->vsync_offset_pulse_width_lo >> 4;
+	unsigned vsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0xc) << 2 | pt->vsync_offset_pulse_width_lo >> 4;
 	unsigned vsync_pulse_width = (pt->hsync_vsync_offset_pulse_width_hi & 0x3) << 4 | (pt->vsync_offset_pulse_width_lo & 0xf);
 
 	/* ignore tiny modes */

