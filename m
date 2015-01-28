Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbbA1BiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:38:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759067AbbA1BiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 3.14 19/77] bus: mvebu-mbus: fix support of MBus window 13
Date: Tue, 27 Jan 2015 17:26:57 -0800
Message-Id: <20150128012746.540386954@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit 38bdf45f4aa5cb6186d50a29e6cbbd9d486a1519 upstream.

On Armada XP, 375 and 38x the MBus window 13 has the remap capability,
like windows 0 to 7. However, the mvebu-mbus driver isn't currently
taking into account this special case, which means that when window 13
is actually used, the remap registers are left to 0, making the device
using this MBus window unavailable.

As a minimal fix for stable, don't use window 13. A full fix will
follow later.

Fixes: fddddb52a6c ("bus: introduce an Marvell EBU MBus driver")
Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bus/mvebu-mbus.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/bus/mvebu-mbus.c
+++ b/drivers/bus/mvebu-mbus.c
@@ -181,12 +181,25 @@ static void mvebu_mbus_disable_window(st
 }
 
 /* Checks whether the given window number is available */
+
+/* On Armada XP, 375 and 38x the MBus window 13 has the remap
+ * capability, like windows 0 to 7. However, the mvebu-mbus driver
+ * isn't currently taking into account this special case, which means
+ * that when window 13 is actually used, the remap registers are left
+ * to 0, making the device using this MBus window unavailable. The
+ * quick fix for stable is to not use window 13. A follow up patch
+ * will correctly handle this window.
+*/
 static int mvebu_mbus_window_is_free(struct mvebu_mbus_state *mbus,
 				     const int win)
 {
 	void __iomem *addr = mbus->mbuswins_base +
 		mbus->soc->win_cfg_offset(win);
 	u32 ctrl = readl(addr + WIN_CTRL_OFF);
+
+	if (win == 13)
+		return false;
+
 	return !(ctrl & WIN_CTRL_ENABLE);
 }
 


