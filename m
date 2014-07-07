Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaGGPPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:15:52 -0400
Received: from skprod2.natinst.com ([130.164.80.23]:35014 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752992AbaGGPPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:15:50 -0400
X-Greylist: delayed 1532 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2014 11:15:50 EDT
From: Nathan Sullivan <nathan.sullivan@ni.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nathan Sullivan <nathan.sullivan@ni.com>
Subject: [PATCH] usb: gadget: fix eem_wrap cloned skb logic
Date: Mon, 7 Jul 2014 09:50:14 -0500
Message-Id: <1404744614-26354-1-git-send-email-nathan.sullivan@ni.com>
X-Mailer: git-send-email 1.7.10.4
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 07/07/2014 09:50:15 AM,
	Serialize by Router on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 07/07/2014 09:50:15 AM,
	Serialize complete at 07/07/2014 09:50:15 AM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-07_01:2014-07-07,2014-07-07,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if the skb is cloned, we still need a ZLP or USB will stall.

Signed-off-by: Nathan Sullivan <nathan.sullivan@ni.com>
Acked-by: Brad Mouring <brad.mouring@ni.com>
---
 drivers/usb/gadget/f_eem.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/gadget/f_eem.c b/drivers/usb/gadget/f_eem.c
index d61c11d..4d8b236 100644
--- a/drivers/usb/gadget/f_eem.c
+++ b/drivers/usb/gadget/f_eem.c
@@ -355,20 +355,18 @@ static struct sk_buff *eem_wrap(struct gether *port, struct sk_buff *skb)
 	int		padlen = 0;
 	u16		len = skb->len;
 
-	if (!skb_cloned(skb)) {
-		int headroom = skb_headroom(skb);
-		int tailroom = skb_tailroom(skb);
+	int headroom = skb_headroom(skb);
+	int tailroom = skb_tailroom(skb);
 
-		/* When (len + EEM_HLEN + ETH_FCS_LEN) % in->maxpacket) is 0,
-		 * stick two bytes of zero-length EEM packet on the end.
-		 */
-		if (((len + EEM_HLEN + ETH_FCS_LEN) % in->maxpacket) == 0)
-			padlen += 2;
+	/* When (len + EEM_HLEN + ETH_FCS_LEN) % in->maxpacket) is 0,
+	 * stick two bytes of zero-length EEM packet on the end.
+	 */
+	if (((len + EEM_HLEN + ETH_FCS_LEN) % in->maxpacket) == 0)
+		padlen += 2;
 
-		if ((tailroom >= (ETH_FCS_LEN + padlen)) &&
-				(headroom >= EEM_HLEN))
-			goto done;
-	}
+	if ((tailroom >= (ETH_FCS_LEN + padlen)) &&
+			(headroom >= EEM_HLEN) && !skb_cloned(skb))
+		goto done;
 
 	skb2 = skb_copy_expand(skb, EEM_HLEN, ETH_FCS_LEN + padlen, GFP_ATOMIC);
 	dev_kfree_skb_any(skb);
-- 
1.7.10.4

