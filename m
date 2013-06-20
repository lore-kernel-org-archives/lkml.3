Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab3FTVQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:16:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518Ab3FTVQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:16:45 -0400
Date: Thu, 20 Jun 2013 18:05:56 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] vgacon.c: add cond reschedule points in vgacon_do_font_op
Message-ID: <20130620210556.GA13479@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
 
