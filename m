Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357AbaGCKM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:12:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51611 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265AbaGCJVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 039/198] matroxfb: perform a dummy read of M_STATUS
Date: Thu,  3 Jul 2014 10:18:02 +0100
Message-Id: <1404379241-8590-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

