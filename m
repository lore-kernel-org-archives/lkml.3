Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab3IKE7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab3IKE5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:09 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=0xnfn5rwEf4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=rP_Tw5wPcqQA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=Tty9oNO6AAAA:8 a=sVePFC_FFXGozliEQDMA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042921.701107620@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [177/251] virtio: console: fix raising SIGIO after port unplug
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0177-virtio-console-fix-raising-SIGIO-after-port-unplug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@redhat.com>

[ Upstream commit 92d3453815fbe74d539c86b60dab39ecdf01bb99 ]

SIGIO should be sent when a port gets unplugged.  It should only be sent
to prcesses that have the port opened, and have asked for SIGIO to be
delivered.  We were clearing out guest_connected before calling
send_sigio_to_port(), resulting in a sigio not getting sent to
processes.

Fix by setting guest_connected to false after invoking the sigio
function.

CC: <stable@vger.kernel.org>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/char/virtio_console.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index e6a51da..4df55cb 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1290,12 +1290,14 @@ static void unplug_port(struct port *port)
 	spin_unlock_irq(&port->portdev->ports_lock);
 
 	if (port->guest_connected) {
+		/* Let the app know the port is going down. */
+		send_sigio_to_port(port);
+
+		/* Do this after sigio is actually sent */
 		port->guest_connected = false;
 		port->host_connected = false;
-		wake_up_interruptible(&port->waitqueue);
 
-		/* Let the app know the port is going down. */
-		send_sigio_to_port(port);
+		wake_up_interruptible(&port->waitqueue);
 	}
 
 	if (is_console_port(port)) {
-- 
1.7.10.4


