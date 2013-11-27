Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab3K0BLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:11:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3K0A7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.12 110/116] usb: musb: core: properly free host / device structs in err path
Date: Tue, 26 Nov 2013 16:58:03 -0800
Message-Id: <20131127005744.536853644@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1947,6 +1947,8 @@ musb_init_controller(struct device *dev,
 		if (status < 0)
 			goto fail3;
 		status = musb_gadget_setup(musb);
+		if (status)
+			musb_host_cleanup(musb);
 		break;
 	default:
 		dev_err(dev, "unsupported port mode %d\n", musb->port_mode);
@@ -1973,6 +1975,7 @@ fail5:
 
 fail4:
 	musb_gadget_cleanup(musb);
+	musb_host_cleanup(musb);
 
 fail3:
 	if (musb->dma_controller)


