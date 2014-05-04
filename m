Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbaEDQrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:47:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbaEDPlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3.14 053/158] staging: r8712u: Fix case where ethtype was never obtained and always be checked against 0
Date: Sun,  4 May 2014 11:39:22 -0400
Message-Id: <20140504154037.165016668@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit f764cd68d9036498f08fe8834deb6a367b5c2542 upstream.

Zero-initializing ether_type masked that the ether type would never be
obtained for 8021x packets and the comparison against eapol_type
would always fail.

Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8712/rtl871x_recv.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/staging/rtl8712/rtl871x_recv.c
+++ b/drivers/staging/rtl8712/rtl871x_recv.c
@@ -254,7 +254,7 @@ union recv_frame *r8712_portctrl(struct
 	struct sta_info *psta;
 	struct	sta_priv *pstapriv;
 	union recv_frame *prtnframe;
-	u16 ether_type = 0;
+	u16 ether_type;
 
 	pstapriv = &adapter->stapriv;
 	ptr = get_recvframe_data(precv_frame);
@@ -263,15 +263,14 @@ union recv_frame *r8712_portctrl(struct
 	psta = r8712_get_stainfo(pstapriv, psta_addr);
 	auth_alg = adapter->securitypriv.AuthAlgrthm;
 	if (auth_alg == 2) {
+		/* get ether_type */
+		ptr = ptr + pfhdr->attrib.hdrlen + LLC_HEADER_SIZE;
+		memcpy(&ether_type, ptr, 2);
+		ether_type = ntohs((unsigned short)ether_type);
+
 		if ((psta != NULL) && (psta->ieee8021x_blocked)) {
 			/* blocked
 			 * only accept EAPOL frame */
-			prtnframe = precv_frame;
-			/*get ether_type */
-			ptr = ptr + pfhdr->attrib.hdrlen +
-			      pfhdr->attrib.iv_len + LLC_HEADER_SIZE;
-			memcpy(&ether_type, ptr, 2);
-			ether_type = ntohs((unsigned short)ether_type);
 			if (ether_type == 0x888e)
 				prtnframe = precv_frame;
 			else {


