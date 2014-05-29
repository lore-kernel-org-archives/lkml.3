Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbaE2HCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:02:14 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48697 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbaE2HCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:02:12 -0400
Date: Thu, 29 May 2014 16:01:27 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "staging: dgap: remove unneeded kfree() in
 dgap_tty_register_ports()"
Message-ID: <20140529070127.GA1347@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 0ade4a34fd439d62df46937e8f3e584eb0879579.

This patch removes kfree for serial_ports in dgap_tty_register_ports()
if the "brd->printer_ports" allocation fails and serial_ports may be
freed by calling dgap_tty_uninit() within other patch.
That patch has an error handling but incomplete cleanup
so it need to call kfree() for brd->serial_ports in
dgap_tty_register_ports().

Conflicts:

	drivers/staging/dgap/dgap.c
---
 drivers/staging/dgap/dgap.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 48c13c9..f0556ee 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -4145,8 +4145,10 @@ static int dgap_tty_register_ports(struct board_t *brd)
 
 	brd->printer_ports = kcalloc(brd->nasync, sizeof(*brd->printer_ports),
 					GFP_KERNEL);
-	if (!brd->printer_ports)
+	if (brd->printer_ports == NULL) {
+		kfree(brd->serial_ports);
 		return -ENOMEM;
+	}
 
 	for (i = 0; i < brd->nasync; i++) {
 		tty_port_init(&brd->serial_ports[i]);
-- 
1.7.1

