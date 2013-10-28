Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab3J1Ovx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:51:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51314 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073Ab3J1Ot5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Seif Mazareeb <seif@marvell.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 59/64] net: fix cipso packet validation when !NETLABEL
Date: Mon, 28 Oct 2013 14:48:18 +0000
Message-Id: <1382971703-17393-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seif Mazareeb <seif@marvell.com>

commit f2e5ddcc0d12f9c4c7b254358ad245c9dddce13b upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
-- 
1.8.3.2

