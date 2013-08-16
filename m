Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab3HQAGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:06:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51727 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3HPWj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 089/133] virtio: console: fix race in port_fops_open() and port unplug
Date: Fri, 16 Aug 2013 15:33:51 -0700
Message-Id: <1376692475-28413-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/char/virtio_console.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index ff015e7..4e848c8 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1047,6 +1047,10 @@ static int port_fops_open(struct inode *inode, struct file *filp)
 
 	/* We get the port with a kref here */
 	port = find_port_by_devt(cdev->dev);
+	if (!port) {
+		/* Port was unplugged before we could proceed */
+		return -ENXIO;
+	}
 	filp->private_data = port;
 
 	/*
-- 
1.8.1.2

