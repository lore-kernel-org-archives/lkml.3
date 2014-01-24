Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaAXGDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 01:03:46 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:11564
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445AbaAXGDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 01:03:14 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h1155h)
From: Liu Ying <Ying.Liu@freescale.com>
To: <jg1.han@samsung.com>
CC: <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <jani.nikula@linux.intel.com>
Subject: [PATCH v4 2/2] backlight: update backlight status when necessary
Date: Fri, 24 Jan 2014 14:04:36 +0800
Message-ID: <1390543476-13499-3-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390543476-13499-1-git-send-email-Ying.Liu@freescale.com>
References: <1390543476-13499-1-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't have to update a backlight status every time a
blanking or unblanking event comes because the backlight
status may have already been what we want. Another thought
is that one backlight device may be shared by multiple
framebuffers. We don't hope blanking one of the framebuffers
may turn the backlight off for all the other framebuffers,
since they are likely being active to display something.
This patch makes the backlight status be updated only when
the relevant backlight device's use count changes from zero
to one or from one to zero.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 drivers/video/backlight/backlight.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index efc9a2d..27d3cf2 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -34,7 +34,7 @@ static const char *const backlight_types[] = {
 			   defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE))
 /* This callback gets called when something important happens inside a
  * framebuffer driver. We're looking if that important event is blanking,
- * and if it is, we're switching backlight power as well ...
+ * and if it is and necessary, we're switching backlight power as well ...
  */
 static int fb_notifier_callback(struct notifier_block *self,
 				unsigned long event, void *data)
@@ -60,6 +60,7 @@ static int fb_notifier_callback(struct notifier_block *self,
 				if (!bd->use_count++) {
 					bd->props.state &= ~BL_CORE_FBBLANK;
 					bd->props.fb_blank = FB_BLANK_UNBLANK;
+					backlight_update_status(bd);
 				}
 			} else if (fb_blank != FB_BLANK_UNBLANK &&
 				   bd->fb_bl_on[node]) {
@@ -67,9 +68,9 @@ static int fb_notifier_callback(struct notifier_block *self,
 				if (!(--bd->use_count)) {
 					bd->props.state |= BL_CORE_FBBLANK;
 					bd->props.fb_blank = fb_blank;
+					backlight_update_status(bd);
 				}
 			}
-			backlight_update_status(bd);
 		}
 	mutex_unlock(&bd->ops_lock);
 	return 0;
-- 
1.7.9.5


