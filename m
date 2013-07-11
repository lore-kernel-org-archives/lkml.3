Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab3GKOdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:33:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43204 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919Ab3GKO0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 77/98] vgacon.c: add cond reschedule points in vgacon_do_font_op
Date: Thu, 11 Jul 2013 15:24:47 +0100
Message-Id: <1373552708-15235-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/console/vgacon.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 5855d17..0dd6d96 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -1124,11 +1124,15 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 
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
@@ -1139,11 +1143,15 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
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
 
-- 
1.8.1.2

