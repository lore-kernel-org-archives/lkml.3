Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3J1Hdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 03:33:32 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:29705 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab3J1Hdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 03:33:31 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>, <linux-kernel@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] drivers/vga: check decodes for vgaarb lock/unlock
Date: Mon, 28 Oct 2013 15:33:51 +0800
Message-Id: <1382945631-3942-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug that X windows system may use an invalid decodes iostat
on the VGA Arbiter device when lock and unlock. this may cause system
crash. So we must validate the value of iostat.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/gpu/vga/vgaarb.c | 55 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index af02597..4772367 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -906,8 +906,9 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 	struct vga_arb_private *priv = file->private_data;
 	struct vga_arb_user_card *uc = NULL;
 	struct pci_dev *pdev;
+	struct vga_device *vgadev = NULL;
 
-	unsigned int io_state;
+	unsigned int io_state = 0;
 
 	char *kbuf, *curr_pos;
 	size_t remaining = count;
@@ -927,6 +928,19 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 	curr_pos = kbuf;
 	kbuf[count] = '\0';	/* Just to make sure... */
 
+	pdev = priv->target;
+	if (priv->target == NULL) {
+		pr_debug("No device found");
+		ret_val = -ENODEV;
+		goto done;
+	}
+	vgadev = vgadev_find(pdev);
+	if (vgadev == NULL) {
+		pr_debug("Could not find vga device for %s", pci_name(pdev));
+		ret_val = -ENODEV;
+		goto done;
+	}
+
 	if (strncmp(curr_pos, "lock ", 5) == 0) {
 		curr_pos += 5;
 		remaining -= 5;
@@ -937,14 +951,15 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 			ret_val = -EPROTO;
 			goto done;
 		}
-		if (io_state == VGA_RSRC_NONE) {
+		if ((vgadev->owns & io_state) != io_state) {
+			pr_debug("iostate (%x and %x ) do not match",
+				io_state, vgadev->owns);
+
 			ret_val = -EPROTO;
 			goto done;
 		}
-
-		pdev = priv->target;
-		if (priv->target == NULL) {
-			ret_val = -ENODEV;
+		if (io_state == VGA_RSRC_NONE) {
+			ret_val = -EPROTO;
 			goto done;
 		}
 
@@ -969,14 +984,21 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 
 		pr_debug("client 0x%p called 'unlock'\n", priv);
 
-		if (strncmp(curr_pos, "all", 3) == 0)
+		if (strncmp(curr_pos, "all", 3) == 0) {
 			io_state = VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM;
-		else {
+		} else {
 			if (!vga_str_to_iostate
 			    (curr_pos, remaining, &io_state)) {
 				ret_val = -EPROTO;
 				goto done;
 			}
+			if ((vgadev->owns & io_state) != io_state) {
+				pr_debug("iostate (%x and %x ) do not match",
+					io_state, vgadev->owns);
+
+				ret_val = -EPROTO;
+				goto done;
+			}
 			/* TODO: Add this?
 			   if (io_state == VGA_RSRC_NONE) {
 			   ret_val = -EPROTO;
@@ -985,11 +1007,6 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 			  */
 		}
 
-		pdev = priv->target;
-		if (priv->target == NULL) {
-			ret_val = -ENODEV;
-			goto done;
-		}
 		for (i = 0; i < MAX_USER_CARDS; i++) {
 			if (priv->cards[i].pdev == pdev)
 				uc = &priv->cards[i];
@@ -1029,6 +1046,13 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 			ret_val = -EPROTO;
 			goto done;
 		}
+		if ((vgadev->owns & io_state) != io_state) {
+			pr_debug("iostate (%x and %x ) do not match",
+				io_state, vgadev->owns);
+
+			ret_val = -EPROTO;
+			goto done;
+		}
 		/* TODO: Add this?
 		   if (io_state == VGA_RSRC_NONE) {
 		   ret_val = -EPROTO;
@@ -1036,11 +1060,6 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		   }
 		 */
 
-		pdev = priv->target;
-		if (priv->target == NULL) {
-			ret_val = -ENODEV;
-			goto done;
-		}
 
 		if (vga_tryget(pdev, io_state)) {
 			/* Update the client's locks lists... */
-- 
1.8.4.rc3

