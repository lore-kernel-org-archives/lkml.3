Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbaKTRjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:39:54 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:7293 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757843AbaKTRjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:39:52 -0500
X-IronPort-AV: E=Sophos;i="5.07,425,1413237600"; 
   d="scan'208";a="89679749"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Joshua Morris <josh.h.morris@us.ibm.com>
Cc: kernel-janitors@vger.kernel.org,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] rsxx: fix error return code
Date: Thu, 20 Nov 2014 18:34:00 +0100
Message-Id: <1416504842-18548-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1416504842-18548-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1416504842-18548-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Return a negative error code on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The patches in this series are independent of each other.

 drivers/block/rsxx/core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index d8b2488..3801721 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -893,6 +893,7 @@ static int rsxx_pci_probe(struct pci_dev *dev,
 	card->event_wq = create_singlethread_workqueue(DRIVER_NAME"_event");
 	if (!card->event_wq) {
 		dev_err(CARD_TO_DEV(card), "Failed card event setup.\n");
+		st = -ENOMEM;
 		goto failed_event_handler;
 	}
 

