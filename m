Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbbANR14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:27:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbbANR1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:27:52 -0500
Date: Wed, 14 Jan 2015 19:27:28 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, cornelia.huck@de.ibm.com,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH v3 02/16] virtio/9p: verify device has config space
Message-ID: <1421256142-11512-3-git-send-email-mst@redhat.com>
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
virtio/9p needs config space access so make it
fail gracefully if not there.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/9p/trans_virtio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index daa749c..d8e376a 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -524,6 +524,12 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 	int err;
 	struct virtio_chan *chan;
 
+	if (!vdev->config->get) {
+		dev_err(&vdev->dev, "%s failure: config access disabled\n",
+			__func__);
+		return -EINVAL;
+	}
+
 	chan = kmalloc(sizeof(struct virtio_chan), GFP_KERNEL);
 	if (!chan) {
 		pr_err("Failed to allocate virtio 9P channel\n");
-- 
MST

