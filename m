Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaBEUIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:08:25 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48606 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbaBEUIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:08:00 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mathias Krause <minipli@googlemail.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 193/213] dccp: check ccid before dereferencing
Date: Wed, 5 Feb 2014 15:02:28 -0500
Message-ID: <1391630568-49251-194-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 276bdb82dedb290511467a5a4fdbe9f0b52dce6f upstream.

ccid_hc_rx_getsockopt() and ccid_hc_tx_getsockopt() might be called with
a NULL ccid pointer leading to a NULL pointer dereference. This could
lead to a privilege escalation if the attacker is able to map page 0 and
prepare it with a fake ccid_ops pointer.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/dccp/ccid.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dccp/ccid.h b/net/dccp/ccid.h
index 6df6f8ac9636..4f78abbf1045 100644
--- a/net/dccp/ccid.h
+++ b/net/dccp/ccid.h
@@ -218,7 +218,7 @@ static inline int ccid_hc_rx_getsockopt(struct ccid *ccid, struct sock *sk,
 					u32 __user *optval, int __user *optlen)
 {
 	int rc = -ENOPROTOOPT;
-	if (ccid->ccid_ops->ccid_hc_rx_getsockopt != NULL)
+	if (ccid != NULL && ccid->ccid_ops->ccid_hc_rx_getsockopt != NULL)
 		rc = ccid->ccid_ops->ccid_hc_rx_getsockopt(sk, optname, len,
 						 optval, optlen);
 	return rc;
@@ -229,7 +229,7 @@ static inline int ccid_hc_tx_getsockopt(struct ccid *ccid, struct sock *sk,
 					u32 __user *optval, int __user *optlen)
 {
 	int rc = -ENOPROTOOPT;
-	if (ccid->ccid_ops->ccid_hc_tx_getsockopt != NULL)
+	if (ccid != NULL && ccid->ccid_ops->ccid_hc_tx_getsockopt != NULL)
 		rc = ccid->ccid_ops->ccid_hc_tx_getsockopt(sk, optname, len,
 						 optval, optlen);
 	return rc;
-- 
1.8.5.2

