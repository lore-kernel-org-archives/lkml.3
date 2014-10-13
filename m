Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaJMHwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:52:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788AbaJMHro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:47:44 -0400
Date: Mon, 13 Oct 2014 10:50:53 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>
Subject: [PATCH v4 14/25] 9p/trans_virtio: enable VQs early
Message-ID: <1413114332-626-15-git-send-email-mst-v4@redhat.com>
References: <1413114332-626-1-git-send-email-mst-v4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413114332-626-1-git-send-email-mst-v4@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio spec requires drivers to set DRIVER_OK before using VQs.
This is set automatically after probe returns, but virtio 9p device
adds self to channel list within probe, at which point VQ can be
used in violation of the spec.

To fix, call virtio_device_ready before using VQs.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/9p/trans_virtio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 6940d8f..766ba48 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -575,6 +575,8 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 	/* Ceiling limit to avoid denial of service attacks */
 	chan->p9_max_pages = nr_free_buffer_pages()/4;
 
+	virtio_device_ready(vdev);
+
 	mutex_lock(&virtio_9p_lock);
 	list_add_tail(&chan->chan_list, &virtio_chan_list);
 	mutex_unlock(&virtio_9p_lock);
-- 
MST


