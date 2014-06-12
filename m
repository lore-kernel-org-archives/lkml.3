Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbaFLImk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:42:40 -0400
Received: from stringer.orebokech.com ([212.83.175.182]:54255 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531AbaFLImh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:42:37 -0400
From: Romain Francoise <romain@orebokech.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, nab@daterainc.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        sfr@canb.auug.org.au, linux-scsi@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PULL] vhost: infrastructure changes for 3.16
Organization: orebokech dot com
References: <20140611134447.GA8208@redhat.com>
Date: Thu, 12 Jun 2014 10:42:34 +0200
In-Reply-To: <20140611134447.GA8208@redhat.com> (Michael S. Tsirkin's message
	of "Wed, 11 Jun 2014 16:44:47 +0300")
Message-ID: <87mwdiwmbp.fsf@kima.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> Memory allocation for vhost-net now supports fallback on vmalloc (same
> as for vhost-scsi) this makes it possible to create the device on
> systems where memory is very fragmented, with slightly lower
> performance.

Thanks Michael, I'm glad to see that this change made its way into
mainline after all! Would you be willing to take the following on top?


From: Romain Francoise <romain@orebokech.com>
Date: Thu, 12 Jun 2014 10:26:40 +0200
Subject: [PATCH] vhost-net: don't open-code kvfree

Commit 23cc5a991c ("vhost-net: extend device allocation to vmalloc")
added another open-coded version of kvfree (which is available since
v3.15-rc5), nuke it.

Signed-off-by: Romain Francoise <romain@orebokech.com>
---
 drivers/vhost/net.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 971a760..8dae2f7 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -700,14 +700,6 @@ static void handle_rx_net(struct vhost_work *work)
 	handle_rx(net);
 }
 
-static void vhost_net_free(void *addr)
-{
-	if (is_vmalloc_addr(addr))
-		vfree(addr);
-	else
-		kfree(addr);
-}
-
 static int vhost_net_open(struct inode *inode, struct file *f)
 {
 	struct vhost_net *n;
@@ -723,7 +715,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 	}
 	vqs = kmalloc(VHOST_NET_VQ_MAX * sizeof(*vqs), GFP_KERNEL);
 	if (!vqs) {
-		vhost_net_free(n);
+		kvfree(n);
 		return -ENOMEM;
 	}
 
@@ -840,7 +832,7 @@ static int vhost_net_release(struct inode *inode, struct file *f)
 	 * since jobs can re-queue themselves. */
 	vhost_net_flush(n);
 	kfree(n->dev.vqs);
-	vhost_net_free(n);
+	kvfree(n);
 	return 0;
 }
 
-- 
2.0.0

