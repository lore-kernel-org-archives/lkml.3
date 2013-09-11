Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3IKE71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab3IKE5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:09 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=cdLb9vFUF8wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=YOfW3OP1mHkA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=Tty9oNO6AAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042921.404738116@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [175/251] virtio: console: fix race in port_fops_open() and port unplug
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0175-virtio-console-fix-race-in-port_fops_open-and-port-u.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@redhat.com>

[ Upstream commit 671bdea2b9f210566610603ecbb6584c8a201c8c ]

Between open() being called and processed, the port can be unplugged.
Check if this happened, and bail out.

A simple test script to reproduce this is:

while true; do for i in $(seq 1 100); do echo $i > /dev/vport0p3; done; done;

This opens and closes the port a lot of times; unplugging the port while
this is happening triggers the bug.

CC: <stable@vger.kernel.org>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/char/virtio_console.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index abca6eb..a57cc3b 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -798,6 +798,10 @@ static int port_fops_open(struct inode *inode, struct file *filp)
 
 	/* We get the port with a kref here */
 	port = find_port_by_devt(cdev->dev);
+	if (!port) {
+		/* Port was unplugged before we could proceed */
+		return -ENXIO;
+	}
 	filp->private_data = port;
 
 	/*
-- 
1.7.10.4


