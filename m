Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbbANR1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:27:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbbANR1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:27:52 -0500
Date: Wed, 14 Jan 2015 19:27:35 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, cornelia.huck@de.ibm.com,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit.shah@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 04/16] virtio/console: verify device has config space
Message-ID: <1421256142-11512-5-git-send-email-mst@redhat.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421256142-11512-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices might not implement config space access
(e.g. remoteproc used not to - before 3.9).
virtio/console needs config space access so make it
fail gracefully if not there.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/char/virtio_console.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index de03df9..26afb56 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1986,6 +1986,12 @@ static int virtcons_probe(struct virtio_device *vdev)
 	bool multiport;
 	bool early = early_put_chars != NULL;
 
+	if (!vdev->config->get) {
+		dev_err(&vdev->dev, "%s failure: config access disabled\n",
+			__func__);
+		return -EINVAL;
+	}
+
 	/* Ensure to read early_put_chars now */
 	barrier();
 
-- 
MST

