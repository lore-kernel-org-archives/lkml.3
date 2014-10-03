Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbaJCWQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:16:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903AbaJCWQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:16:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Petallo, MauriceX R" <mauricex.r.petallo@intel.com>
Subject: [PATCH 3.14 230/238] dmaengine: dw: introduce dwc_dostart_first_queued() helper
Date: Fri,  3 Oct 2014 14:32:25 -0700
Message-Id: <20141003212921.020233742@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e7637c6c0382485f4d2e20715d058dae6f2b6a7c upstream.

We have a duplicate code which starts first descriptor in the queue. Let's make
this as a separate helper that can be used in future as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Cc: "Petallo, MauriceX R" <mauricex.r.petallo@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/dw/core.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -279,6 +279,15 @@ static void dwc_dostart(struct dw_dma_ch
 	channel_set_bit(dw, CH_EN, dwc->mask);
 }
 
+static void dwc_dostart_first_queued(struct dw_dma_chan *dwc)
+{
+	if (list_empty(&dwc->queue))
+		return;
+
+	list_move(dwc->queue.next, &dwc->active_list);
+	dwc_dostart(dwc, dwc_first_active(dwc));
+}
+
 /*----------------------------------------------------------------------*/
 
 static void
@@ -335,10 +344,7 @@ static void dwc_complete_all(struct dw_d
 	 * the completed ones.
 	 */
 	list_splice_init(&dwc->active_list, &list);
-	if (!list_empty(&dwc->queue)) {
-		list_move(dwc->queue.next, &dwc->active_list);
-		dwc_dostart(dwc, dwc_first_active(dwc));
-	}
+	dwc_dostart_first_queued(dwc);
 
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
@@ -467,10 +473,7 @@ static void dwc_scan_descriptors(struct
 	/* Try to continue after resetting the channel... */
 	dwc_chan_disable(dw, dwc);
 
-	if (!list_empty(&dwc->queue)) {
-		list_move(dwc->queue.next, &dwc->active_list);
-		dwc_dostart(dwc, dwc_first_active(dwc));
-	}
+	dwc_dostart_first_queued(dwc);
 	spin_unlock_irqrestore(&dwc->lock, flags);
 }
 


