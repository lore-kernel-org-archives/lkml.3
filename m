Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441AbaJCXiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:38:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbaJCWDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 3.14 101/238] USB: EHCI: unlink QHs even after the controller has stopped
Date: Fri,  3 Oct 2014 14:30:16 -0700
Message-Id: <20141003212916.909227059@linuxfoundation.org>
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

From: Alan Stern <stern@rowland.harvard.edu>

commit 7312b5ddd47fee2356baa78c5516ef8e04eed452 upstream.

Old code in ehci-hcd tries to expedite disabling endpoints after the
controller has stopped, by destroying the endpoint's associated QH
without first unlinking the QH.  This was necessary back when the
driver wasn't so careful about keeping track of the controller's
state.

But now we are careful about it, and the driver knows that when the
controller isn't running, no unlinking delay is needed.  Furthermore,
skipping the unlink step will trigger a BUG() in qh_destroy() when the
preceding QH is released, because the link pointer will be non-NULL.

Removing the lines that skip the unlinking step and go directly to
QH_STATE_IDLE fixes the problem.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Joe Lawrence <joe.lawrence@stratus.com>
Tested-by: Joe Lawrence <joe.lawrence@stratus.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-hcd.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -965,8 +965,6 @@ rescan:
 	}
 
 	qh->exception = 1;
-	if (ehci->rh_state < EHCI_RH_RUNNING)
-		qh->qh_state = QH_STATE_IDLE;
 	switch (qh->qh_state) {
 	case QH_STATE_LINKED:
 		WARN_ON(!list_empty(&qh->qtd_list));


