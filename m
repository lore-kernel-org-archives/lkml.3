Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191AbbACNog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 08:44:36 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:14182 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbbACNoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 08:44:34 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApUKADPxp1RXQzKq/2dsb2JhbABcgwaBKrNwBQEBAQEBAQUBd5c0gQUXAQEBAQF9hGkjgRo3iDABrymOFQErhgOJdB2EEwWXCIlnh2kigUWCKj0xgkMBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jaroslav Kysela <perex@perex.cz>,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 linux-next] hp100: simplify hp100_module_init
Date: Sat,  3 Jan 2015 14:44:16 +0100
Message-Id: <1420292656-14429-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Avoid double goto and directly return err where possible.
-Remove unused labels which fixes:

drivers/net/ethernet/hp/hp100.c:3047:2: warning: label
'out3' defined but not used [-Wunused-label]

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
This is untested.

 drivers/net/ethernet/hp/hp100.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hp/hp100.c b/drivers/net/ethernet/hp/hp100.c
index ae6e30d..7155938 100644
--- a/drivers/net/ethernet/hp/hp100.c
+++ b/drivers/net/ethernet/hp/hp100.c
@@ -3031,26 +3031,25 @@ static int __init hp100_module_init(void)
 
 	err = hp100_isa_init();
 	if (err && err != -ENODEV)
-		goto out;
+		return err;
 #ifdef CONFIG_EISA
 	err = eisa_driver_register(&hp100_eisa_driver);
 	if (err && err != -ENODEV)
-		goto out2;
+		goto out_eisa;
+	else
+		return err;
 #endif
 #ifdef CONFIG_PCI
 	err = pci_register_driver(&hp100_pci_driver);
-	if (err && err != -ENODEV)
-		goto out3;
+	if (!err || err == -ENODEV)
+		return err;
 #endif
- out:
-	return err;
- out3:
 #ifdef CONFIG_EISA
 	eisa_driver_unregister (&hp100_eisa_driver);
- out2:
+ out_eisa:
 #endif
 	hp100_isa_cleanup();
-	goto out;
+	return err;
 }
 
 
-- 
2.1.0

