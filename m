Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbaFPRG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:06:29 -0400
Received: from mail-ie0-f196.google.com ([209.85.223.196]:50980 "EHLO
	mail-ie0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaFPRG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:06:27 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: swise@chelsio.com
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Patch Resend] infiniband:memory leak in get_skb function in file cm.c
Date: Mon, 16 Jun 2014 13:06:21 -0400
Message-Id: <1402938381-5882-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index f9477e2..2d56983 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -340,15 +340,13 @@ static int status2errno(int status)
  */
 static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
 {
 if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
                skb_trim(skb, 0);
                skb_get(skb);
                skb_reset_transport_header(skb);
        } else {
+if (!skb)
+	skb_kfree(skb);
+	/*NULL is ignored */
                skb = alloc_skb(len, gfp);
        }
        t4_set_arp_err_handler(skb, NULL, NULL);

