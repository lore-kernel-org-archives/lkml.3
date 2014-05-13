Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760518AbaEMKKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:10:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50665 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933232AbaEMKJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:09:34 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] console: Remove superfluous readonly check
Date: Tue, 13 May 2014 12:09:29 +0200
Message-Id: <1399975769-30526-4-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399975769-30526-1-git-send-email-tiwai@suse.de>
References: <1399975769-30526-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uni_pagedir.readonly is never set.  Let's get rid of superfluous check
codes.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/tty/vt/consolemap.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
index 3fdc786b6b2f..610b720d3b91 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -179,7 +179,6 @@ struct uni_pagedir {
 	unsigned long	sum;
 	unsigned char	*inverse_translations[4];
 	u16		*inverse_trans_unicode;
-	int		readonly;
 };
 
 static struct uni_pagedir *dflt;
@@ -501,9 +500,6 @@ static int con_do_clear_unimap(struct vc_data *vc, struct unimapinit *ui)
 	struct uni_pagedir *p, *q;
 
 	p = *vc->vc_uni_pagedir_loc;
-	if (p && p->readonly)
-		return -EIO;
-
 	if (!p || --p->refcount) {
 		q = kzalloc(sizeof(*p), GFP_KERNEL);
 		if (!q) {
@@ -536,19 +532,13 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 	int err = 0, err1, i;
 	struct uni_pagedir *p, *q;
 
+	if (!ct)
+		return 0;
+
 	console_lock();
 
 	/* Save original vc_unipagdir_loc in case we allocate a new one */
 	p = *vc->vc_uni_pagedir_loc;
-	if (p->readonly) {
-		console_unlock();
-		return -EIO;
-	}
-	
-	if (!ct) {
-		console_unlock();
-		return 0;
-	}
 	
 	if (p->refcount > 1) {
 		int j, k;
-- 
1.9.2

