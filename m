Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbaEMKkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:40:21 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60775 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760047AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 047/182] staging: r8712u: Fix case where ethtype was never obtained and always be checked against 0
Date: Tue, 13 May 2014 11:26:39 +0200
Message-Id: <e4c62d135c422f2fbff79eacf326bf65fbc286a1.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f764cd68d9036498f08fe8834deb6a367b5c2542 upstream.

Zero-initializing ether_type masked that the ether type would never be
obtained for 8021x packets and the comparison against eapol_type
would always fail.

Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/rtl8712/rtl871x_recv.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
index 23ec684b60e1..274c359279ef 100644
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
1.9.3

