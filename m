Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaKETCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 14:02:23 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:49009 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751208AbaKETCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 14:02:20 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 4/4] serial: 8250_pnp: Override pnp suspend for no_console_suspend
Date: Wed,  5 Nov 2014 14:02:05 -0500
Message-Id: <1415214125-14751-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415212854-16944-5-git-send-email-peter@hurleysoftware.com>
References: <1415212854-16944-5-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent PNP bus from powering down the serial console device
when suspending if the no_console_suspend command line option is set.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250_pnp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_pnp.c b/drivers/tty/serial/8250/8250_pnp.c
index 50b7c89..4aefaf2 100644
--- a/drivers/tty/serial/8250/8250_pnp.c
+++ b/drivers/tty/serial/8250/8250_pnp.c
@@ -487,7 +487,7 @@ serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 
 	if (uart_console(&port8250->port) && !console_suspend_enabled) {
 		info->override_disable = !!(dev->capabilities & PNP_DISABLE);
-		dev->capabilities &= ~PNP_DISABLE;
+		dev->capabilities &= ~(PNP_DISABLE | PNP_SUSPEND);
 	}
 
 	pnp_set_drvdata(dev, info);
@@ -502,6 +502,7 @@ static void serial_pnp_remove(struct pnp_dev *dev)
 		serial8250_unregister_port(info->line);
 		if (info->override_disable)
 			dev->capabilities |= PNP_DISABLE;
+		dev->capabilities |= PNP_SUSPEND;
 	}
 }
 
-- 
2.1.3

