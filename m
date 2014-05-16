Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbaEPMxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:53:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49572 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753763AbaEPMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Larry Finger" <Larry.Finger@lwfinger.net>,
        "Jes Sorensen" <Jes.Sorensen@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Fri, 16 May 2014 13:47:21 +0100
Message-ID: <lsq.1400244441.423624393@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 07/34] staging: r8712u: Fix case where ethtype was
 never obtained and always be checked against 0
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit f764cd68d9036498f08fe8834deb6a367b5c2542 upstream.

Zero-initializing ether_type masked that the ether type would never be
obtained for 8021x packets and the comparison against eapol_type
would always fail.

Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/rtl8712/rtl871x_recv.c | 13 ++++++-------
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

