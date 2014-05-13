Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbaEMKKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:10:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933235AbaEMKJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:09:35 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] console: Use explicit pointer type for vc_uni_pagedir* fields
Date: Tue, 13 May 2014 12:09:28 +0200
Message-Id: <1399975769-30526-3-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399975769-30526-1-git-send-email-tiwai@suse.de>
References: <1399975769-30526-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vc_data.vc_uni_pagedir filed is currently long int, supposedly to
be served generically.  This, however, leads to lots of cast to
pointer, and rather it worsens the readability significantly.

Actually, we have now only a single uni_pagedir map implementation,
and this won't change likely.  So, it'd be much more simple and
error-prone to just use the exact pointer for struct uni_pagedir
instead of long.

Ditto for vc_uni_pagedir_loc.  It's a pointer to the uni_pagedir, thus
it can be changed similarly to the exact type.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/tty/vt/consolemap.c    | 38 +++++++++++++++++++-------------------
 drivers/tty/vt/vt.c            |  2 +-
 drivers/video/console/vgacon.c |  4 ++--
 include/linux/console_struct.h |  5 +++--
 4 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
index 2978ca596a7f..3fdc786b6b2f 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -262,7 +262,7 @@ u16 inverse_translate(struct vc_data *conp, int glyph, int use_unicode)
 	int m;
 	if (glyph < 0 || glyph >= MAX_GLYPH)
 		return 0;
-	else if (!(p = (struct uni_pagedir *)*conp->vc_uni_pagedir_loc))
+	else if (!(p = *conp->vc_uni_pagedir_loc))
 		return glyph;
 	else if (use_unicode) {
 		if (!p->inverse_trans_unicode)
@@ -287,7 +287,7 @@ static void update_user_maps(void)
 	for (i = 0; i < MAX_NR_CONSOLES; i++) {
 		if (!vc_cons_allocated(i))
 			continue;
-		p = (struct uni_pagedir *)*vc_cons[i].d->vc_uni_pagedir_loc;
+		p = *vc_cons[i].d->vc_uni_pagedir_loc;
 		if (p && p != q) {
 			set_inverse_transl(vc_cons[i].d, p, USER_MAP);
 			set_inverse_trans_unicode(vc_cons[i].d, p);
@@ -418,10 +418,10 @@ void con_free_unimap(struct vc_data *vc)
 {
 	struct uni_pagedir *p;
 
-	p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
+	p = *vc->vc_uni_pagedir_loc;
 	if (!p)
 		return;
-	*vc->vc_uni_pagedir_loc = 0;
+	*vc->vc_uni_pagedir_loc = NULL;
 	if (--p->refcount)
 		return;
 	con_release_unimap(p);
@@ -436,7 +436,7 @@ static int con_unify_unimap(struct vc_data *conp, struct uni_pagedir *p)
 	for (i = 0; i < MAX_NR_CONSOLES; i++) {
 		if (!vc_cons_allocated(i))
 			continue;
-		q = (struct uni_pagedir *)*vc_cons[i].d->vc_uni_pagedir_loc;
+		q = *vc_cons[i].d->vc_uni_pagedir_loc;
 		if (!q || q == p || q->sum != p->sum)
 			continue;
 		for (j = 0; j < 32; j++) {
@@ -459,7 +459,7 @@ static int con_unify_unimap(struct vc_data *conp, struct uni_pagedir *p)
 		}
 		if (j == 32) {
 			q->refcount++;
-			*conp->vc_uni_pagedir_loc = (unsigned long)q;
+			*conp->vc_uni_pagedir_loc = q;
 			con_release_unimap(p);
 			kfree(p);
 			return 1;
@@ -500,7 +500,7 @@ static int con_do_clear_unimap(struct vc_data *vc, struct unimapinit *ui)
 {
 	struct uni_pagedir *p, *q;
 
-	p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
+	p = *vc->vc_uni_pagedir_loc;
 	if (p && p->readonly)
 		return -EIO;
 
@@ -512,7 +512,7 @@ static int con_do_clear_unimap(struct vc_data *vc, struct unimapinit *ui)
 			return -ENOMEM;
 		}
 		q->refcount=1;
-		*vc->vc_uni_pagedir_loc = (unsigned long)q;
+		*vc->vc_uni_pagedir_loc = q;
 	} else {
 		if (p == dflt) dflt = NULL;
 		p->refcount++;
@@ -539,7 +539,7 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 	console_lock();
 
 	/* Save original vc_unipagdir_loc in case we allocate a new one */
-	p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
+	p = *vc->vc_uni_pagedir_loc;
 	if (p->readonly) {
 		console_unlock();
 		return -EIO;
@@ -564,7 +564,7 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 		 * Since refcount was > 1, con_clear_unimap() allocated a
 		 * a new uni_pagedir for this vc.  Re: p != q
 		 */
-		q = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
+		q = *vc->vc_uni_pagedir_loc;
 
 		/*
 		 * uni_pgdir is a 32*32*64 table with rows allocated
@@ -586,7 +586,7 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 					err1 = con_insert_unipair(q, l, p2[k]);
 					if (err1) {
 						p->refcount++;
-						*vc->vc_uni_pagedir_loc = (unsigned long)p;
+						*vc->vc_uni_pagedir_loc = p;
 						con_release_unimap(q);
 						kfree(q);
 						console_unlock();
@@ -655,12 +655,12 @@ int con_set_default_unimap(struct vc_data *vc)
 	struct uni_pagedir *p;
 
 	if (dflt) {
-		p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
+		p = *vc->vc_uni_pagedir_loc;
 		if (p == dflt)
 			return 0;
 
 		dflt->refcount++;
-		*vc->vc_uni_pagedir_loc = (unsigned long)dflt;
+		*vc->vc_uni_pagedir_loc = dflt;
 		if (p && !--p->refcount) {
 			con_release_unimap(p);
 			kfree(p);
@@ -674,7 +674,7 @@ int con_set_default_unimap(struct vc_data *vc)
 	if (err)
 		return err;
     
-	p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
+	p = *vc->vc_uni_pagedir_loc;
 	q = dfont_unitable;
 	
 	for (i = 0; i < 256; i++)
@@ -685,7 +685,7 @@ int con_set_default_unimap(struct vc_data *vc)
 		}
 			
 	if (con_unify_unimap(vc, p)) {
-		dflt = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
+		dflt = *vc->vc_uni_pagedir_loc;
 		return err;
 	}
 
@@ -713,9 +713,9 @@ int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc)
 	if (*dst_vc->vc_uni_pagedir_loc == *src_vc->vc_uni_pagedir_loc)
 		return 0;
 	con_free_unimap(dst_vc);
-	q = (struct uni_pagedir *)*src_vc->vc_uni_pagedir_loc;
+	q = *src_vc->vc_uni_pagedir_loc;
 	q->refcount++;
-	*dst_vc->vc_uni_pagedir_loc = (long)q;
+	*dst_vc->vc_uni_pagedir_loc = q;
 	return 0;
 }
 EXPORT_SYMBOL(con_copy_unimap);
@@ -737,7 +737,7 @@ int con_get_unimap(struct vc_data *vc, ushort ct, ushort __user *uct, struct uni
 
 	ect = 0;
 	if (*vc->vc_uni_pagedir_loc) {
-		p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
+		p = *vc->vc_uni_pagedir_loc;
 		for (i = 0; i < 32; i++)
 		if ((p1 = p->uni_pgdir[i]))
 			for (j = 0; j < 32; j++)
@@ -810,7 +810,7 @@ conv_uni_to_pc(struct vc_data *conp, long ucs)
 	if (!*conp->vc_uni_pagedir_loc)
 		return -3;
 
-	p = (struct uni_pagedir *)*conp->vc_uni_pagedir_loc;  
+	p = *conp->vc_uni_pagedir_loc;
 	if ((p1 = p->uni_pgdir[ucs >> 11]) &&
 	    (p2 = p1[(ucs >> 6) & 0x1f]) &&
 	    (h = p2[ucs & 0x3f]) < MAX_GLYPH)
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 3ad0b61e35b4..8209bdce7f69 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -735,7 +735,7 @@ static void visual_init(struct vc_data *vc, int num, int init)
 	vc->vc_num = num;
 	vc->vc_display_fg = &master_display_fg;
 	vc->vc_uni_pagedir_loc = &vc->vc_uni_pagedir;
-	vc->vc_uni_pagedir = 0;
+	vc->vc_uni_pagedir = NULL;
 	vc->vc_hi_font_mask = 0;
 	vc->vc_complement_mask = 0;
 	vc->vc_can_do_color = 0;
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 9e18770aaba6..f267284b423b 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -87,7 +87,7 @@ static void vgacon_save_screen(struct vc_data *c);
 static int vgacon_scroll(struct vc_data *c, int t, int b, int dir,
 			 int lines);
 static void vgacon_invert_region(struct vc_data *c, u16 * p, int count);
-static unsigned long vgacon_uni_pagedir;
+static struct uni_pagedir *vgacon_uni_pagedir;
 static int vgacon_refcount;
 
 /* Description of the hardware situation */
@@ -554,7 +554,7 @@ static const char *vgacon_startup(void)
 
 static void vgacon_init(struct vc_data *c, int init)
 {
-	unsigned long p;
+	struct uni_pagedir *p;
 
 	/*
 	 * We cannot be loaded as a module, therefore init is always 1,
diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index 7f0c32908568..e859c98d1767 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -17,6 +17,7 @@
 #include <linux/workqueue.h>
 
 struct vt_struct;
+struct uni_pagedir;
 
 #define NPAR 16
 
@@ -104,8 +105,8 @@ struct vc_data {
 	unsigned int	vc_bell_pitch;		/* Console bell pitch */
 	unsigned int	vc_bell_duration;	/* Console bell duration */
 	struct vc_data **vc_display_fg;		/* [!] Ptr to var holding fg console for this display */
-	unsigned long	vc_uni_pagedir;
-	unsigned long	*vc_uni_pagedir_loc;  /* [!] Location of uni_pagedir variable for this console */
+	struct uni_pagedir *vc_uni_pagedir;
+	struct uni_pagedir **vc_uni_pagedir_loc; /* [!] Location of uni_pagedir variable for this console */
 	bool vc_panic_force_write; /* when oops/panic this VC can accept forced output/blanking */
 	/* additional information is in vt_kern.h */
 };
-- 
1.9.2

