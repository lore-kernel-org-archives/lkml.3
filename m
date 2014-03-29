Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaC2AdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 20:33:07 -0400
Received: from ring0.de ([5.45.105.125]:43046 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaC2AdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 20:33:04 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv3 06/14] HSI: export method to (un)register clients
Date: Sat, 29 Mar 2014 01:31:42 +0100
Message-Id: <1396053110-21639-7-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396053110-21639-1-git-send-email-sre@kernel.org>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose method for registering and unregistering HSI clients, so that
client drivers can register other client drivers.

This is useful for HSI drivers, which want to use the functionality
of other HSI drivers. For example the N900 modem driver can load HSI
drivers for mcsaab protocol and speech protocol.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/hsi/hsi.c       | 11 ++++++++---
 include/linux/hsi/hsi.h |  3 +++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
index 9d1130d..07e1639 100644
--- a/drivers/hsi/hsi.c
+++ b/drivers/hsi/hsi.c
@@ -72,14 +72,15 @@ static void hsi_client_release(struct device *dev)
 	kfree(cl);
 }
 
-static void hsi_new_client(struct hsi_port *port, struct hsi_board_info *info)
+struct hsi_client *hsi_new_client(struct hsi_port *port,
+						struct hsi_board_info *info)
 {
 	struct hsi_client *cl;
 	size_t size;
 
 	cl = kzalloc(sizeof(*cl), GFP_KERNEL);
 	if (!cl)
-		return;
+		return NULL;
 
 	cl->tx_cfg = info->tx_cfg;
 	if (cl->tx_cfg.channels) {
@@ -106,7 +107,10 @@ static void hsi_new_client(struct hsi_port *port, struct hsi_board_info *info)
 		pr_err("hsi: failed to register client: %s\n", info->name);
 		put_device(&cl->device);
 	}
+
+	return cl;
 }
+EXPORT_SYMBOL_GPL(hsi_new_client);
 
 static void hsi_scan_board_info(struct hsi_controller *hsi)
 {
@@ -122,12 +126,13 @@ static void hsi_scan_board_info(struct hsi_controller *hsi)
 		}
 }
 
-static int hsi_remove_client(struct device *dev, void *data __maybe_unused)
+int hsi_remove_client(struct device *dev, void *data __maybe_unused)
 {
 	device_unregister(dev);
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(hsi_remove_client);
 
 static int hsi_remove_port(struct device *dev, void *data __maybe_unused)
 {
diff --git a/include/linux/hsi/hsi.h b/include/linux/hsi/hsi.h
index 50a85a9..57ee40f 100644
--- a/include/linux/hsi/hsi.h
+++ b/include/linux/hsi/hsi.h
@@ -296,6 +296,9 @@ struct hsi_controller *hsi_alloc_controller(unsigned int n_ports, gfp_t flags);
 void hsi_put_controller(struct hsi_controller *hsi);
 int hsi_register_controller(struct hsi_controller *hsi);
 void hsi_unregister_controller(struct hsi_controller *hsi);
+struct hsi_client *hsi_new_client(struct hsi_port *port,
+						struct hsi_board_info *info);
+int hsi_remove_client(struct device *dev, void *data);
 void hsi_port_unregister_clients(struct hsi_port *port);
 
 static inline void hsi_controller_set_drvdata(struct hsi_controller *hsi,
-- 
1.9.0

