Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab3HMGgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:36:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab3HMGe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:34:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 06/17] virtio: console: fix race in port_fops_open() and port unplug
Date: Mon, 12 Aug 2013 23:35:52 -0700
Message-Id: <20130813063502.259970498@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063501.728847844@linuxfoundation.org>
References: <20130813063501.728847844@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit 671bdea2b9f210566610603ecbb6584c8a201c8c upstream.

Between open() being called and processed, the port can be unplugged.
Check if this happened, and bail out.

A simple test script to reproduce this is:

while true; do for i in $(seq 1 100); do echo $i > /dev/vport0p3; done; done;

This opens and closes the port a lot of times; unplugging the port while
this is happening triggers the bug.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/virtio_console.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -794,6 +794,10 @@ static int port_fops_open(struct inode *
 
 	/* We get the port with a kref here */
 	port = find_port_by_devt(cdev->dev);
+	if (!port) {
+		/* Port was unplugged before we could proceed */
+		return -ENXIO;
+	}
 	filp->private_data = port;
 
 	/*


