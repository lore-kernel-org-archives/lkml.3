Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaCWSj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:39:27 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:53417 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaCWSj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:39:26 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: gregkh@linuxfoundation.org, peter@hurleysoftware.com,
        stefanr@s5r6.in-berlin.de, joe@perches.com, valentin.ilie@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/staging: Use RCU_INIT_POINTER(x, NULL) in fwserial/fwserial.c
Date: Mon, 24 Mar 2014 00:08:22 +0530
Message-Id: <1395599902-8056-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/staging/fwserial/fwserial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 8af136e..4e42bde 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -1809,7 +1809,7 @@ static void fwserial_release_port(struct fwtty_port *port, bool reset)
 	port->max_payload = link_speed_to_max_payload(SCODE_100);
 	dma_fifo_change_tx_limit(&port->tx_fifo, port->max_payload);
 
-	rcu_assign_pointer(port->peer, NULL);
+	RCU_INIT_POINTER(port->peer, NULL);
 	spin_unlock_bh(&port->lock);
 
 	if (port->port.console && port->fwcon_ops->notify != NULL)
@@ -2235,7 +2235,7 @@ static int fwserial_create(struct fw_unit *unit)
 		port->max_payload = link_speed_to_max_payload(SCODE_100);
 		dma_fifo_init(&port->tx_fifo);
 
-		rcu_assign_pointer(port->peer, NULL);
+		RCU_INIT_POINTER(port->peer, NULL);
 		serial->ports[i] = port;
 
 		/* get unique bus addr region for port's status & recv fifo */
-- 
1.7.9.5

