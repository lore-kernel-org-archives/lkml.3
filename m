Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbaGHTIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:08:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54038 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755649AbaGHTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tomi Valkeinen" <tomi.valkeinen@ti.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.273575946@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 012/125] matroxfb: perform a dummy read of M_STATUS
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/fbdev/matrox/matroxfb_base.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/matrox/matroxfb_base.h
+++ b/drivers/video/matrox/matroxfb_base.h
@@ -698,7 +698,7 @@ void matroxfb_unregister_driver(struct m
 
 #define mga_fifo(n)	do {} while ((mga_inl(M_FIFOSTATUS) & 0xFF) < (n))
 
-#define WaitTillIdle()	do {} while (mga_inl(M_STATUS) & 0x10000)
+#define WaitTillIdle()	do { mga_inl(M_STATUS); do {} while (mga_inl(M_STATUS) & 0x10000); } while (0)
 
 /* code speedup */
 #ifdef CONFIG_FB_MATROX_MILLENIUM

