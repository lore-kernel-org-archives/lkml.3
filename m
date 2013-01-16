Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3APRMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:12:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35718 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3APP6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:58:44 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 021/222] xhci: Fix conditional check in bandwidth calculation.
Date: Wed, 16 Jan 2013 13:53:41 -0200
Message-Id: <1358351822-7675-22-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 392a07ae3316f2b90b39ce41e66d6f6b5c95de90 upstream.

David reports that at drivers/usb/host/xhci.c:2257:

static bool xhci_is_sync_in_ep(unsigned int ep_type)
{
    return (ep_type == ISOC_IN_EP || ep_type != INT_IN_EP);
}

The static analyser cppcheck says

[linux-3.7-rc2/drivers/usb/host/xhci.c:2257]: (style) Redundant condition: If ep_type == 5, the comparison ep_type != 7 is always true.

Maybe the original programmer intention was something like

static bool xhci_is_sync_in_ep(unsigned int ep_type)
{
    return (ep_type == ISOC_IN_EP || ep_type == INT_IN_EP);
}

Fix this.

This patch should be backported to stable kernels as old as 3.2, that
contain the commit 2b69899934c63b7b9432568584fb4c4a2924f40c "xhci: USB
3.0 BW checking."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/xhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 5f831c2..f67634b 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2253,7 +2253,7 @@ static bool xhci_is_async_ep(unsigned int ep_type)
 
 static bool xhci_is_sync_in_ep(unsigned int ep_type)
 {
-	return (ep_type == ISOC_IN_EP || ep_type != INT_IN_EP);
+	return (ep_type == ISOC_IN_EP || ep_type == INT_IN_EP);
 }
 
 static unsigned int xhci_get_ss_bw_consumed(struct xhci_bw_info *ep_bw)
-- 
1.7.9.5

