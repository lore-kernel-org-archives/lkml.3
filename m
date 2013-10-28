Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3J1Q0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:26:54 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:39138 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347Ab3J1Q0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:26:53 -0400
Date: Tue, 29 Oct 2013 00:26:05 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: rucsoftsec@gmail.com, jslaby@suse.cz, airlied@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH]tty:vt: Add NULL check to return value of kzalloc()
Message-ID: <20131028162605.GA3738@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, rucsoftsec@gmail.com, jslaby@suse.cz,
	airlied@redhat.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In extreme situation kzalloc in con_init may
return NULL, so we should check it to prevent
OOPS!

Signed-off-by: Wang YanQing <udknight@gmail.com>
Reported-by: rucsoftsec@gmail.com
---
 I don't think a system without memory to initialize
 vt could do some useful things, but this patch could
 make debug easier and improve kernel code's robustness 
 in theory.

 drivers/tty/vt/vc_screen.c |  2 +-
 drivers/tty/vt/vt.c        | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 14a2b5f..2bc3987bc 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -648,6 +648,6 @@ int __init vcs_init(void)
 	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, 0), NULL, "vcs");
 	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, 128), NULL, "vcsa");
 	for (i = 0; i < MIN_NR_CONSOLES; i++)
-		vcs_make_sysfs(i);
+		if (vc_cons[i].d) vcs_make_sysfs(i);
 	return 0;
 }
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 9a8e8c5..ef8b1aa 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2887,6 +2887,8 @@ static int __init con_init(void)
 
 	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
 		vc_cons[currcons].d = vc = kzalloc(sizeof(struct vc_data), GFP_NOWAIT);
+		if (vc == NULL)
+			break;
 		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 		tty_port_init(&vc->port);
 		visual_init(vc, currcons, 1);
@@ -2894,8 +2896,18 @@ static int __init con_init(void)
 		vc_init(vc, vc->vc_rows, vc->vc_cols,
 			currcons || !vc->vc_sw->con_save_screen);
 	}
+	if (currcons < MIN_NR_CONSOLES)
+		printk(KERN_WARNING "Console: vt %d-%d initialization failed!\n",
+			currcons, MIN_NR_CONSOLES - 1);
+
 	currcons = fg_console = 0;
 	master_display_fg = vc = vc_cons[currcons].d;
+
+	if (vc == NULL) {
+		printk(KERN_WARNING "Console: no avaiable vt!\n");
+		console_unlock();
+		return 0;
+	}
 	set_origin(vc);
 	save_screen(vc);
 	gotoxy(vc, vc->vc_x, vc->vc_y);
-- 
1.7.12.4.dirty
