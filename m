Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966113Ab3E2NHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:07:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47238 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966072Ab3E2NHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:07:13 -0400
From: Ravi Babu <ravibabu@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        Ravi Babu <ravibabu@ti.com>
Subject: [PATCH v1 2/3] usb: musb: core: added babble recovery func-ptr to musb->ops
Date: Wed, 29 May 2013 18:37:03 +0530
Message-ID: <1369832824-29071-3-git-send-email-ravibabu@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369832824-29071-1-git-send-email-ravibabu@ti.com>
References: <1369832824-29071-1-git-send-email-ravibabu@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding babble_recovery operation as part of musb->ops, used
to recover from babble condition during babble interrupt.

Signed-off-by: Ravi Babu <ravibabu@ti.com>
---
 drivers/usb/musb/musb_core.c |    6 ++++++
 drivers/usb/musb/musb_core.h |    7 +++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index ab6fa39..411c29d 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -857,6 +857,12 @@ b_host:
 		}
 	}
 
+	/* handle babble condition */
+	if (int_usb & MUSB_INTR_BABBLE) {
+		pr_info("babble: restarting the musb controller..");
+		musb_babble_recovery(musb);
+	}
+
 #if 0
 /* REVISIT ... this would be for multiplexing periodic endpoints, or
  * supporting transfer phasing to prevent exceeding ISO bandwidth
diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index f96e899..bf37dc9 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -213,6 +213,8 @@ struct musb_platform_ops {
 	int	(*adjust_channel_params)(struct dma_channel *channel,
 				u16 packet_sz, u8 *mode,
 				dma_addr_t *dma_addr, u32 *len);
+
+	void	(*babble_recovery)(struct musb *musb);
 };
 
 /*
@@ -590,4 +592,9 @@ static inline int musb_platform_exit(struct musb *musb)
 	return musb->ops->exit(musb);
 }
 
+static inline void musb_babble_recovery(struct musb *musb)
+{
+	if (musb->ops->babble_recovery)
+		musb->ops->babble_recovery(musb);
+}
 #endif	/* __MUSB_CORE_H__ */
-- 
1.7.0.4

