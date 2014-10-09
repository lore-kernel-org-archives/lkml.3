Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbaJIVKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:10:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59452 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645AbaJIVKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 111/163] USB: EHCI: unlink QHs even after the controller has stopped
Date: Thu,  9 Oct 2014 14:02:16 -0700
Message-Id: <1412888588-26755-112-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ehci-hcd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 4dfd6fb..86e6d39 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -973,8 +973,6 @@ rescan:
 	}
 
 	qh->exception = 1;
-	if (ehci->rh_state < EHCI_RH_RUNNING)
-		qh->qh_state = QH_STATE_IDLE;
 	switch (qh->qh_state) {
 	case QH_STATE_LINKED:
 		WARN_ON(!list_empty(&qh->qtd_list));
-- 
1.9.1

