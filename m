Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab3AOWbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:31:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:42219 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757589Ab3AOWbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:31:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Campbell <ian.campbell@citrix.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        annie li <annie.li@oracle.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, xen-devel@lists.xen.org,
        netdev@vger.kernel.org
Subject: [ 103/221] xen/netfront: improve truesize tracking
Date: Tue, 15 Jan 2013 10:50:30 -0800
Message-Id: <20130115185005.470007939@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Campbell <Ian.Campbell@citrix.com>

commit d9a58a782e396a0f04e8445b7ba3763c8a48c7fe upstream.

Using RX_COPY_THRESHOLD is incorrect if the SKB is actually smaller
than that. We have already accounted for this in
NETFRONT_SKB_CB(skb)->pull_to so use that instead.

Fixes WARN_ON from skb_try_coalesce.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: annie li <annie.li@oracle.com>
Cc: xen-devel@lists.xen.org
Cc: netdev@vger.kernel.org
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/xen-netfront.c |   27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1015,29 +1015,10 @@ err:
 		i = xennet_fill_frags(np, skb, &tmpq);
 
 		/*
-		 * Truesize approximates the size of true data plus
-		 * any supervisor overheads. Adding hypervisor
-		 * overheads has been shown to significantly reduce
-		 * achievable bandwidth with the default receive
-		 * buffer size. It is therefore not wise to account
-		 * for it here.
-		 *
-		 * After alloc_skb(RX_COPY_THRESHOLD), truesize is set
-		 * to RX_COPY_THRESHOLD + the supervisor
-		 * overheads. Here, we add the size of the data pulled
-		 * in xennet_fill_frags().
-		 *
-		 * We also adjust for any unused space in the main
-		 * data area by subtracting (RX_COPY_THRESHOLD -
-		 * len). This is especially important with drivers
-		 * which split incoming packets into header and data,
-		 * using only 66 bytes of the main data area (see the
-		 * e1000 driver for example.)  On such systems,
-		 * without this last adjustement, our achievable
-		 * receive throughout using the standard receive
-		 * buffer size was cut by 25%(!!!).
-		 */
-		skb->truesize += skb->data_len - RX_COPY_THRESHOLD;
+                 * Truesize is the actual allocation size, even if the
+                 * allocation is only partially used.
+                 */
+		skb->truesize += PAGE_SIZE * skb_shinfo(skb)->nr_frags;
 		skb->len += skb->data_len;
 
 		if (rx->flags & XEN_NETRXF_csum_blank)


