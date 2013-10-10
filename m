Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab3JJQIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:08:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52692 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab3JJPpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:45:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 054/104] serial: pch_uart: fix tty-kref leak in dma-rx path
Date: Thu, 10 Oct 2013 08:41:42 -0700
Message-Id: <1381419752-29733-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 19b85cfb190eb9980eaf416bff96aef4159a430e upstream.

Fix tty_kref leak when tty_buffer_request room fails in dma-rx path.

Note that the tty ref isn't really needed anymore, but as the leak has
always been there, fixing it before removing should makes it easier to
backport the fix.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/serial/pch_uart.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index a9e4be7..6e67829 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -648,11 +648,12 @@ static int dma_push_rx(struct eg20t_port *priv, int size)
 		dev_warn(port->dev, "Rx overrun: dropping %u bytes\n",
 			 size - room);
 	if (!room)
-		return room;
+		goto out;
 
 	tty_insert_flip_string(tty, sg_virt(&priv->sg_rx), size);
 
 	port->icount.rx += room;
+out:
 	tty_kref_put(tty);
 
 	return room;
-- 
1.8.1.2

