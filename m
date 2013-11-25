Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab3KYO0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:26:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58861 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963Ab3KYNxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:38 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Seif Mazareeb" <seif@marvell.com>, "Paul Moore" <paul@paul-moore.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.92152905@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 19/87] net: fix cipso packet validation when !NETLABEL
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Seif Mazareeb <seif@marvell.com>

[ Upstream commit f2e5ddcc0d12f9c4c7b254358ad245c9dddce13b ]

When CONFIG_NETLABEL is disabled, the cipso_v4_validate() function could loop
forever in the main loop if opt[opt_iter +1] == 0, this will causing a kernel
crash in an SMP system, since the CPU executing this function will
stall /not respond to IPIs.

This problem can be reproduced by running the IP Stack Integrity Checker
(http://isic.sourceforge.net) using the following command on a Linux machine
connected to DUT:

"icmpsic -s rand -d <DUT IP address> -r 123456"
wait (1-2 min)

Signed-off-by: Seif Mazareeb <seif@marvell.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/cipso_ipv4.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/cipso_ipv4.h b/include/net/cipso_ipv4.h
index a7a683e..a8c2ef6 100644
--- a/include/net/cipso_ipv4.h
+++ b/include/net/cipso_ipv4.h
@@ -290,6 +290,7 @@ static inline int cipso_v4_validate(const struct sk_buff *skb,
 	unsigned char err_offset = 0;
 	u8 opt_len = opt[1];
 	u8 opt_iter;
+	u8 tag_len;
 
 	if (opt_len < 8) {
 		err_offset = 1;
@@ -302,11 +303,12 @@ static inline int cipso_v4_validate(const struct sk_buff *skb,
 	}
 
 	for (opt_iter = 6; opt_iter < opt_len;) {
-		if (opt[opt_iter + 1] > (opt_len - opt_iter)) {
+		tag_len = opt[opt_iter + 1];
+		if ((tag_len == 0) || (opt[opt_iter + 1] > (opt_len - opt_iter))) {
 			err_offset = opt_iter + 1;
 			goto out;
 		}
-		opt_iter += opt[opt_iter + 1];
+		opt_iter += tag_len;
 	}
 
 out:

