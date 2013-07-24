Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab3GXOXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:23:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45739 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943Ab3GXOGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marcelo Tosatti" <mtosatti@redhat.com>,
        "Dave Airlie" <airlied@redhat.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.881009677@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [41/85] vgacon.c: add cond reschedule points in vgacon_do_font_op
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 7e6d72c15ff4cc0c27573901bb05f9eddbd71ed4 upstream.

Booting a 64-vcpu KVM guest, with CONFIG_PREEMPT_VOLUNTARY,
can result in a soft lockup:

BUG: soft lockup - CPU#41 stuck for 67s! [setfont:1505]
 RIP: 0010:[<ffffffff812c48da>]
[<ffffffff812c48da>] vgacon_do_font_op.clone.0+0x1ba/0x550

This is due to the 8192 (cmapsz) IO operations taking longer than expected
due to lock contention in QEMU.

Add conditional resched points in between writes allowing other tasks to
execute.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[bwh: Backported to 3.2: add #include <linux/sched.h>, already present
 upstream]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/console/vgacon.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -42,6 +42,7 @@
 #include <linux/kd.h>
 #include <linux/slab.h>
 #include <linux/vt_kern.h>
+#include <linux/sched.h>
 #include <linux/selection.h>
 #include <linux/spinlock.h>
 #include <linux/ioport.h>
@@ -1124,11 +1125,15 @@ static int vgacon_do_font_op(struct vgas
 
 	if (arg) {
 		if (set)
-			for (i = 0; i < cmapsz; i++)
+			for (i = 0; i < cmapsz; i++) {
 				vga_writeb(arg[i], charmap + i);
+				cond_resched();
+			}
 		else
-			for (i = 0; i < cmapsz; i++)
+			for (i = 0; i < cmapsz; i++) {
 				arg[i] = vga_readb(charmap + i);
+				cond_resched();
+			}
 
 		/*
 		 * In 512-character mode, the character map is not contiguous if
@@ -1139,11 +1144,15 @@ static int vgacon_do_font_op(struct vgas
 			charmap += 2 * cmapsz;
 			arg += cmapsz;
 			if (set)
-				for (i = 0; i < cmapsz; i++)
+				for (i = 0; i < cmapsz; i++) {
 					vga_writeb(arg[i], charmap + i);
+					cond_resched();
+				}
 			else
-				for (i = 0; i < cmapsz; i++)
+				for (i = 0; i < cmapsz; i++) {
 					arg[i] = vga_readb(charmap + i);
+					cond_resched();
+				}
 		}
 	}
 

