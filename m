Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbbANHZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:25:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbbANHZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:25:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arend Van Spriel <arend@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.18 039/150] brcmfmac: Fix ifidx for rx data by msgbuf.
Date: Tue, 13 Jan 2015 23:21:50 -0800
Message-Id: <20150114072057.631272654@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hante Meuleman <meuleman@broadcom.com>

commit 94a612086f5e78272e831c04b673778f8546ea73 upstream.

The ifidx provided by FW needs to be offsetted when receiving data
packets.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -1081,8 +1081,17 @@ brcmf_msgbuf_rx_skb(struct brcmf_msgbuf
 {
 	struct brcmf_if *ifp;
 
+	/* The ifidx is the idx to map to matching netdev/ifp. When receiving
+	 * events this is easy because it contains the bssidx which maps
+	 * 1-on-1 to the netdev/ifp. But for data frames the ifidx is rcvd.
+	 * bssidx 1 is used for p2p0 and no data can be received or
+	 * transmitted on it. Therefor bssidx is ifidx + 1 if ifidx > 0
+	 */
+	if (ifidx)
+		(ifidx)++;
 	ifp = msgbuf->drvr->iflist[ifidx];
 	if (!ifp || !ifp->ndev) {
+		brcmf_err("Received pkt for invalid ifidx %d\n", ifidx);
 		brcmu_pkt_buf_free_skb(skb);
 		return;
 	}


