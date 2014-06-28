Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaF1RsA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:48:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbaF1Rr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 3.10 26/77] matroxfb: perform a dummy read of M_STATUS
Date: Sat, 28 Jun 2014 10:46:19 -0700
Message-Id: <20140628174522.890921446@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/matrox/matroxfb_base.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/matrox/matroxfb_base.h
+++ b/drivers/video/matrox/matroxfb_base.h
@@ -698,7 +698,7 @@ void matroxfb_unregister_driver(struct m
 
 #define mga_fifo(n)	do {} while ((mga_inl(M_FIFOSTATUS) & 0xFF) < (n))
 
-#define WaitTillIdle()	do {} while (mga_inl(M_STATUS) & 0x10000)
+#define WaitTillIdle()	do { mga_inl(M_STATUS); do {} while (mga_inl(M_STATUS) & 0x10000); } while (0)
 
 /* code speedup */
 #ifdef CONFIG_FB_MATROX_MILLENIUM


