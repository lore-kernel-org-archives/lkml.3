Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab3J2BTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:19:18 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33994 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab3J2BTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:19:17 -0400
Date: Tue, 29 Oct 2013 09:18:51 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: rucsoftsec@gmail.com, jslaby@suse.cz, airlied@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2]tty:vt: Add NULL check to return value of kzalloc()
Message-ID: <20131029011851.GA2926@udknight>
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
Reported-by: RUC_SoftSec <rucsoftsec@gmail.com>
---
 Changes:
 v1-v2:
 1:fix warning and error reported by scripts/checkpatch.pl

 drivers/tty/vt/vc_screen.c |  6 ++++--
 drivers/tty/vt/vt.c        | 12 ++++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index d7799de..e0de4bc 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -662,7 +662,9 @@ int __init vcs_init(void)
 
 	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, 0), NULL, "vcs");
 	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, 128), NULL, "vcsa");
-	for (i = 0; i < MIN_NR_CONSOLES; i++)
-		vcs_make_sysfs(i);
+	for (i = 0; i < MIN_NR_CONSOLES; i++) {
+		if (vc_cons[i].d)
+			vcs_make_sysfs(i);
+	}
 	return 0;
 }
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 740202d..8f490e9 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2885,6 +2885,8 @@ static int __init con_init(void)
 
 	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
 		vc_cons[currcons].d = vc = kzalloc(sizeof(struct vc_data), GFP_NOWAIT);
+		if (vc == NULL)
+			break;
 		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 		tty_port_init(&vc->port);
 		visual_init(vc, currcons, 1);
@@ -2892,8 +2894,18 @@ static int __init con_init(void)
 		vc_init(vc, vc->vc_rows, vc->vc_cols,
 			currcons || !vc->vc_sw->con_save_screen);
 	}
+	if (currcons < MIN_NR_CONSOLES)
+		pr_warn("Console: vt %d-%d initialization failed!\n",
+			currcons, MIN_NR_CONSOLES - 1);
+
 	currcons = fg_console = 0;
 	master_display_fg = vc = vc_cons[currcons].d;
+
+	if (vc == NULL) {
+		pr_warn("Console: no avaiable vt!\n");
+		console_unlock();
+		return 0;
+	}
 	set_origin(vc);
 	save_screen(vc);
 	gotoxy(vc, vc->vc_x, vc->vc_y);
-- 
1.7.12.4.dirty
