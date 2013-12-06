Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422640Ab3LFNS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:18:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44619 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161953Ab3LFNEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Mack <zonque@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 223/272] usb: musb: core: properly free host / device structs in err path
Date: Fri,  6 Dec 2013 12:58:32 +0000
Message-Id: <1386334761-25517-224-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 0d2dd7eaed1dac07b266ca2c662ff4a184a3060f upstream.

The patch fixes two issues in the error path cleanup:
- in MUSB_PORT_MODE_DUAL_ROLE mode, if musb_gadget_setup() fails we
  never cleanup the host struct earlier allocated.
- if musb_init_debugfs() or sysfs_create_group() fails, then we never
  free the host part initialization, only device part.

Cc: Daniel Mack <zonque@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/musb/musb_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 6ef8c94..41b9d6f 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1962,6 +1962,8 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 		if (status < 0)
 			goto fail3;
 		status = musb_gadget_setup(musb);
+		if (status)
+			musb_host_cleanup(musb);
 		break;
 	default:
 		dev_err(dev, "unsupported port mode %d\n", musb->port_mode);
@@ -1988,6 +1990,7 @@ fail5:
 
 fail4:
 	musb_gadget_cleanup(musb);
+	musb_host_cleanup(musb);
 
 fail3:
 	pm_runtime_put_sync(musb->controller);
-- 
1.8.3.2

