Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbaHHWCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:02:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032AbaHHVgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ivan Vecera <ivecera@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 10/39] bna: fix performance regression
Date: Fri,  8 Aug 2014 14:34:56 -0700
Message-Id: <20140808213355.415588935@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213354.980430919@linuxfoundation.org>
References: <20140808213354.980430919@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit c36c9d50cc6af5c5bfcc195f21b73f55520c15f9 ]

The recent commit "e29aa33 bna: Enable Multi Buffer RX" is causing
a performance regression. It does not properly update 'cmpl' pointer
at the end of the loop in NAPI handler bnad_cq_process(). The result is
only one packet / per NAPI-schedule is processed.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/brocade/bna/bnad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -600,9 +600,9 @@ bnad_cq_process(struct bnad *bnad, struc
 	prefetch(bnad->netdev);
 
 	cq = ccb->sw_q;
-	cmpl = &cq[ccb->producer_index];
 
 	while (packets < budget) {
+		cmpl = &cq[ccb->producer_index];
 		if (!cmpl->valid)
 			break;
 		/* The 'valid' field is set by the adapter, only after writing


