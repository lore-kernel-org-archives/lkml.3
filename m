Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbaDXJQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:16:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47064 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbaDXI4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 160/182] staging: r8712u: Fix case where ethtype was never obtained and always be checked against 0
Date: Thu, 24 Apr 2014 09:51:25 +0100
Message-Id: <1398329507-5911-161-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit f764cd68d9036498f08fe8834deb6a367b5c2542 upstream.

Zero-initializing ether_type masked that the ether type would never be
obtained for 8021x packets and the comparison against eapol_type
would always fail.

Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/rtl8712/rtl871x_recv.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
index 23ec684..274c359 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.c
+++ b/drivers/staging/rtl8712/rtl871x_recv.c
@@ -254,7 +254,7 @@ union recv_frame *r8712_portctrl(struct _adapter *adapter,
 	struct sta_info *psta;
 	struct	sta_priv *pstapriv;
 	union recv_frame *prtnframe;
-	u16 ether_type = 0;
+	u16 ether_type;
 
 	pstapriv = &adapter->stapriv;
 	ptr = get_recvframe_data(precv_frame);
@@ -263,15 +263,14 @@ union recv_frame *r8712_portctrl(struct _adapter *adapter,
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
-- 
1.9.1

