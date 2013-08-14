Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab3HNKqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:46:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34638 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab3HNKiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 53/75] virtio: console: fix race in port_fops_open() and port unplug
Date: Wed, 14 Aug 2013 11:36:42 +0100
Message-Id: <1376476624-10011-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/virtio_console.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 002357f..4ab78e9 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -797,6 +797,10 @@ static int port_fops_open(struct inode *inode, struct file *filp)
 
 	/* We get the port with a kref here */
 	port = find_port_by_devt(cdev->dev);
+	if (!port) {
+		/* Port was unplugged before we could proceed */
+		return -ENXIO;
+	}
 	filp->private_data = port;
 
 	/*
-- 
1.8.3.2

