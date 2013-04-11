Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab3DKUdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:33:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23708 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab3DKU0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:14 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=cYbFuNsn-aAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=NY3mP363oEMA:10 a=8pif782wAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=8Lux7RlFoefuZ1qdms8A:9 a=oUQuMaGMe1cA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202553.203987598@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Torsten Duwe <duwe@lst.de>
Subject: [ 043/171 ] KMS: fix EDID detailed timing vsync parsing
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0043-KMS-fix-EDID-detailed-timing-vsync-parsing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Torsten Duwe <torsten@lst.de>

[ Upstream commit 16dad1d743d31a104a849c8944e6b9eb479f6cd7 ]

EDID spreads some values across multiple bytes; bit-fiddling is needed
to retrieve these.  The current code to parse "detailed timings" has a
cut&paste error that results in a vsync offset of at most 15 lines
instead of 63.

See

   http://en.wikipedia.org/wiki/EDID

and in the "EDID Detailed Timing Descriptor" see bytes 10+11 show why
that needs to be a left shift.

Cc: stable@vger.kernel.org
Signed-off-by: Torsten Duwe <duwe@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/drm_edid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index b7ee230..fafd5a1 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -879,7 +879,7 @@ static struct drm_display_mode *drm_mode_detailed(struct drm_device *dev,
 	unsigned vblank = (pt->vactive_vblank_hi & 0xf) << 8 | pt->vblank_lo;
 	unsigned hsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0xc0) << 2 | pt->hsync_offset_lo;
 	unsigned hsync_pulse_width = (pt->hsync_vsync_offset_pulse_width_hi & 0x30) << 4 | pt->hsync_pulse_width_lo;
-	unsigned vsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0xc) >> 2 | pt->vsync_offset_pulse_width_lo >> 4;
+	unsigned vsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0xc) << 2 | pt->vsync_offset_pulse_width_lo >> 4;
 	unsigned vsync_pulse_width = (pt->hsync_vsync_offset_pulse_width_hi & 0x3) << 4 | (pt->vsync_offset_pulse_width_lo & 0xf);
 
 	/* ignore tiny modes */
-- 
1.7.10.4


