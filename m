Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbbAMOos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:44:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbbAMOnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:43:31 -0500
Date: Tue, 13 Jan 2015 16:43:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 3/6] virtio/console: verify device has config space
Message-ID: <1421160167-18498-4-git-send-email-mst@redhat.com>
References: <1421160167-18498-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421160167-18498-1-git-send-email-mst@redhat.com>
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

