Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab3JCFSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:18:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab3JCESW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:18:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 22/57] serial: pch_uart: fix tty-kref leak in dma-rx path
Date: Wed,  2 Oct 2013 21:08:48 -0700
Message-Id: <20131003040638.127825049@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 19b85cfb190eb9980eaf416bff96aef4159a430e upstream.

Fix tty_kref leak when tty_buffer_request room fails in dma-rx path.

Note that the tty ref isn't really needed anymore, but as the leak has
always been there, fixing it before removing should makes it easier to
backport the fix.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/pch_uart.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -658,11 +658,12 @@ static int dma_push_rx(struct eg20t_port
 		dev_warn(port->dev, "Rx overrun: dropping %u bytes\n",
 			 size - room);
 	if (!room)
-		return room;
+		goto out;
 
 	tty_insert_flip_string(tport, sg_virt(&priv->sg_rx), size);
 
 	port->icount.rx += room;
+out:
 	tty_kref_put(tty);
 
 	return room;


