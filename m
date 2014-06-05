Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaFEE0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:26:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbaFEEWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Dave Airlie <airlied@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 204/214] vgacon.c: add cond reschedule points in vgacon_do_font_op
Date: Wed,  4 Jun 2014 21:19:27 -0700
Message-Id: <20140605041706.864621992@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/console/vgacon.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

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
 


