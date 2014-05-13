Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbaEMKKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:10:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933234AbaEMKJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:09:34 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] vgacon: Fix & cleanup refcounting
Date: Tue, 13 May 2014 12:09:27 +0200
Message-Id: <1399975769-30526-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399975769-30526-1-git-send-email-tiwai@suse.de>
References: <1399975769-30526-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vgacon driver prepares a two element array of uni_pagedir_loc and
uses the second item as its own reference counter for sharing the
uni_pagedir.  And the code assumes blindly that the second item is
available if the assigned vc_uni_pagedir isn't the standard one, which
might be wrong (although currently it's so).

This patch fixes that wrong assumption, and gives a slight cleanup
along with it: namely, instead of array, just give the uni_pagedir_loc
and a separate refcount variable.  It makes the code a bit more
understandable at first glance.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/video/console/vgacon.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 9d8feac67637..9e18770aaba6 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -87,7 +87,8 @@ static void vgacon_save_screen(struct vc_data *c);
 static int vgacon_scroll(struct vc_data *c, int t, int b, int dir,
 			 int lines);
 static void vgacon_invert_region(struct vc_data *c, u16 * p, int count);
-static unsigned long vgacon_uni_pagedir[2];
+static unsigned long vgacon_uni_pagedir;
+static int vgacon_refcount;
 
 /* Description of the hardware situation */
 static int		vga_init_done		__read_mostly;
@@ -575,12 +576,12 @@ static void vgacon_init(struct vc_data *c, int init)
 	if (vga_512_chars)
 		c->vc_hi_font_mask = 0x0800;
 	p = *c->vc_uni_pagedir_loc;
-	if (c->vc_uni_pagedir_loc == &c->vc_uni_pagedir ||
-	    !--c->vc_uni_pagedir_loc[1])
+	if (c->vc_uni_pagedir_loc != &vgacon_uni_pagedir) {
 		con_free_unimap(c);
-	c->vc_uni_pagedir_loc = vgacon_uni_pagedir;
-	vgacon_uni_pagedir[1]++;
-	if (!vgacon_uni_pagedir[0] && p)
+		c->vc_uni_pagedir_loc = &vgacon_uni_pagedir;
+		vgacon_refcount++;
+	}
+	if (!vgacon_uni_pagedir && p)
 		con_set_default_unimap(c);
 
 	/* Only set the default if the user didn't deliberately override it */
@@ -597,7 +598,7 @@ static void vgacon_deinit(struct vc_data *c)
 		vga_set_mem_top(c);
 	}
 
-	if (!--vgacon_uni_pagedir[1])
+	if (!--vgacon_refcount)
 		con_free_unimap(c);
 	c->vc_uni_pagedir_loc = &c->vc_uni_pagedir;
 	con_set_default_unimap(c);
-- 
1.9.2

