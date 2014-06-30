Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbaF3MlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:41:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932213AbaF3MbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:20 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 126/181] matroxfb: perform a dummy read of M_STATUS
Date: Mon, 30 Jun 2014 13:52:27 +0200
Message-Id: <3633bbaec56c99a04939d6088c711645a284c34c.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 972754cfaee94d6e25acf94a497bc0a864d91b7e upstream.

I had occasional screen corruption with the matrox framebuffer driver and
I found out that the reason for the corruption is that the hardware
blitter accesses the videoram while it is being written to.

The matrox driver has a macro WaitTillIdle() that should wait until the
blitter is idle, but it sometimes doesn't work. I added a dummy read
mga_inl(M_STATUS) to WaitTillIdle() to fix the problem. The dummy read
will flush the write buffer in the PCI chipset, and the next read of
M_STATUS will return the hardware status.

Since applying this patch, I had no screen corruption at all.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/video/matrox/matroxfb_base.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/matrox/matroxfb_base.h b/drivers/video/matrox/matroxfb_base.h
index 556d96ce40bf..89a8a89a5eb2 100644
--- a/drivers/video/matrox/matroxfb_base.h
+++ b/drivers/video/matrox/matroxfb_base.h
@@ -698,7 +698,7 @@ void matroxfb_unregister_driver(struct matroxfb_driver* drv);
 
 #define mga_fifo(n)	do {} while ((mga_inl(M_FIFOSTATUS) & 0xFF) < (n))
 
-#define WaitTillIdle()	do {} while (mga_inl(M_STATUS) & 0x10000)
+#define WaitTillIdle()	do { mga_inl(M_STATUS); do {} while (mga_inl(M_STATUS) & 0x10000); } while (0)
 
 /* code speedup */
 #ifdef CONFIG_FB_MATROX_MILLENIUM
-- 
2.0.0

