Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab3DBWuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:50:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208Ab3DBWuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        Benjamin Poirier <bpoirier@suse.de>
Subject: [ 28/56] macvtap: zerocopy: validate vectors before building skb
Date: Tue,  2 Apr 2013 15:49:55 -0700
Message-Id: <20130402224715.152114862@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jason Wang <jasowang@redhat.com>

commit b92946e2919134ebe2a4083e4302236295ea2a73 upstream.

There're several reasons that the vectors need to be validated:

- Return error when caller provides vectors whose num is greater than UIO_MAXIOV.
- Linearize part of skb when userspace provides vectors grater than MAX_SKB_FRAGS.
- Return error when userspace provides vectors whose total length may exceed
- MAX_SKB_FRAGS * PAGE_SIZE.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Benjamin Poirier <bpoirier@suse.de> [patch reduced to
					the 3rd reason only for 3.0]
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvtap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -552,6 +552,10 @@ static ssize_t macvtap_get_user(struct m
 	if (unlikely(len < ETH_HLEN))
 		goto err;
 
+	err = -EMSGSIZE;
+	if (unlikely(count > UIO_MAXIOV))
+		goto err;
+
 	skb = macvtap_alloc_skb(&q->sk, NET_IP_ALIGN, len, vnet_hdr.hdr_len,
 				noblock, &err);
 	if (!skb)


