Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab3K2Qvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 11:51:54 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58830 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab3K2Qvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 11:51:50 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] drivers: video: metronomefb: avoid out-of-bounds array access
Date: Fri, 29 Nov 2013 17:51:43 +0100
Message-Id: <1385743903-9079-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

load_waveform function checks whether padding bytes in stuff2a
and stuff2b are all zero, but does so by treating those arrays
as a single longer array.  Since the structure is packed, and
the size sum matches, it all works, but creates some confusion
in the code.

This commit changes the stuff2a and stuff2b arrays into pad1 and
pad2 fields such that they cover the same bytes as the arrays
covered, and changes the check in the load_waveform function so
that the fields are read instead of iterating over an arary.

It also renames the other “stuff” fields to “ignore*” fields to
give them more semantic meaning.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/video/metronomefb.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/video/metronomefb.c b/drivers/video/metronomefb.c
index 195cc2d..4f36a2b 100644
--- a/drivers/video/metronomefb.c
+++ b/drivers/video/metronomefb.c
@@ -126,7 +126,7 @@ static struct fb_var_screeninfo metronomefb_var = {
 
 /* the waveform structure that is coming from userspace firmware */
 struct waveform_hdr {
-	u8 stuff[32];
+	u8 ignore1[32];
 
 	u8 wmta[3];
 	u8 fvsn;
@@ -134,13 +134,14 @@ struct waveform_hdr {
 	u8 luts;
 	u8 mc;
 	u8 trc;
-	u8 stuff3;
+	u8 ignore2;
 
 	u8 endb;
 	u8 swtb;
-	u8 stuff2a[2];
+	u32 pad1; /* u16 halfof(pad1) */
 
-	u8 stuff2b[3];
+	/* u16 halfof(pad1) */
+	u8 pad2;
 	u8 wfm_cs;
 } __attribute__ ((packed));
 
@@ -210,11 +211,9 @@ static int load_waveform(u8 *mem, size_t size, int m, int t,
 	}
 	wfm_hdr->mc += 1;
 	wfm_hdr->trc += 1;
-	for (i = 0; i < 5; i++) {
-		if (*(wfm_hdr->stuff2a + i) != 0) {
-			dev_err(dev, "Error: unexpected value in padding\n");
-			return -EINVAL;
-		}
+	if (wfm_hdr->pad1 || wfm_hdr->pad2) {
+		dev_err(dev, "Error: unexpected value in padding\n");
+		return -EINVAL;
 	}
 
 	/* calculating trn. trn is something used to index into
-- 
1.8.4.1

