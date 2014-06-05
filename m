Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaFEEnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:43:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaFEEVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russ Gorby <russ.gorby@intel.com>,
        "Yin, Fengwei" <fengwei.yin@intel.com>,
        Alan Cox <alan@linux.intel.com>, Ben Hutchings <ben@decadent.org.uk>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 137/214] n_gsm: replace kfree_skb w/ appropriate dev_* versions
Date: Wed,  4 Jun 2014 21:18:20 -0700
Message-Id: <20140605041658.168721352@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russ Gorby <russ.gorby@intel.com>

commit 329e56780e514a7ab607bcb51a52ab0dc2669414 upstream.

Drivers are supposed to use the dev_* versions of the kfree_skb
interfaces. In a couple of cases we were called with IRQs
disabled as well which kfree_skb() does not expect.

Replaced kfree_skb calls w/ dev_kfree_skb and dev_kfree_skb_any

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
Tested-by: Yin, Fengwei <fengwei.yin@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/n_gsm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -879,7 +879,7 @@ static int gsm_dlci_data_output_framed(s
 	if (len > gsm->mtu) {
 		if (dlci->adaption == 3) {
 			/* Over long frame, bin it */
-			kfree_skb(dlci->skb);
+			dev_kfree_skb_any(dlci->skb);
 			dlci->skb = NULL;
 			return 0;
 		}
@@ -908,7 +908,7 @@ static int gsm_dlci_data_output_framed(s
 	skb_pull(dlci->skb, len);
 	__gsm_data_queue(dlci, msg);
 	if (last) {
-		kfree_skb(dlci->skb);
+		dev_kfree_skb_any(dlci->skb);
 		dlci->skb = NULL;
 	}
 	return size;
@@ -1688,7 +1688,7 @@ static void gsm_dlci_free(struct kref *r
 	dlci->gsm->dlci[dlci->addr] = NULL;
 	kfifo_free(dlci->fifo);
 	while ((dlci->skb = skb_dequeue(&dlci->skb_list)))
-		kfree_skb(dlci->skb);
+		dev_kfree_skb(dlci->skb);
 	kfree(dlci);
 }
 
@@ -2039,7 +2039,7 @@ void gsm_cleanup_mux(struct gsm_mux *gsm
 {
 	int i;
 	struct gsm_dlci *dlci = gsm->dlci[0];
-	struct gsm_msg *txq, *utxq;
+	struct gsm_msg *txq, *ntxq;
 	struct gsm_control *gc;
 
 	gsm->dead = 1;


