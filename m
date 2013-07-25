Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3GYF0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 01:26:42 -0400
Received: from smtp206.alice.it ([82.57.200.102]:48348 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab3GYF0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 01:26:39 -0400
From: Gianluca Anzolin <gianluca@sottospazio.it>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, gustavo@padovan.org, peter@hurleysoftware.com,
        linux-kernel@vger.kernel.org,
        Gianluca Anzolin <gianluca@sottospazio.it>
Subject: [PATCH] tty_port: Fix refcounting leak in tty_port_tty_hangup()
Date: Thu, 25 Jul 2013 07:26:16 +0200
Message-Id: <1374729977-7164-1-git-send-email-gianluca@sottospazio.it>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function tty_port_tty_hangup() could leak a reference to the tty_struct:

        struct tty_struct *tty = tty_port_tty_get(port);

        if (tty && (!check_clocal || !C_CLOCAL(tty))) {
                tty_hangup(tty);
                tty_kref_put(tty);
        }

If tty != NULL and the second condition is false we never call tty_kref_put and
the reference is leaked.

Fix by always calling tty_kref_put() which accepts a NULL argument.

The patch fixes a regression introduced by commit aa27a094.

Acked-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Gianluca Anzolin <gianluca@sottospazio.it>
---
 drivers/tty/tty_port.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 121aeb9..f597e88 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -256,10 +256,9 @@ void tty_port_tty_hangup(struct tty_port *port, bool check_clocal)
 {
 	struct tty_struct *tty = tty_port_tty_get(port);
 
-	if (tty && (!check_clocal || !C_CLOCAL(tty))) {
+	if (tty && (!check_clocal || !C_CLOCAL(tty)))
 		tty_hangup(tty);
-		tty_kref_put(tty);
-	}
+	tty_kref_put(tty);
 }
 EXPORT_SYMBOL_GPL(tty_port_tty_hangup);
 
-- 
1.8.3.3

