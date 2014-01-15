Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbaAOI02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:26:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaAOI01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:26:27 -0500
Date: Wed, 15 Jan 2014 10:26:08 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH stable-only] virtio-net: fix build on m68k and sparc64
Message-ID: <1389774152-1526-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a result of backporting a bugfix, virtio_net started passing void *
to page_address, assuming that it will get silently converted to struct
page *. But this does not happen on architectures where page_address is
a macro, the result is build failure as the macro tries to dereference
void*.

Fix by reordering code slightly, so we always pass
struct page * to page_address.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

David, Greg asked that this be put in stable ASAP to avoid
next release being broken.
I still didn't Cc stable directly as I know you prefer to do this
yourself.
Sorry about creating this mess, could you help fast-path it there please?

Thanks!

 drivers/net/virtio_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b8665588..c8d5ee1 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -330,9 +330,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 					 void *buf,
 					 unsigned int len)
 {
-	struct skb_vnet_hdr *hdr = page_address(buf);
-	int num_buf = hdr->mhdr.num_buffers;
 	struct page *page = buf;
+	struct skb_vnet_hdr *hdr = page_address(page);
+	int num_buf = hdr->mhdr.num_buffers;
 	struct sk_buff *skb = page_to_skb(rq, page, len);
 	int i;
 
-- 
MST
