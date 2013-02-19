Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035Ab3BSSvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:51:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54223 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933985Ab3BSSvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:51:13 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 20/81] USB: EHCI: fix bug in scheduling periodic split transfers
Date: Tue, 19 Feb 2013 15:48:43 -0300
Message-Id: <1361299784-8830-21-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 3e619d04159be54b3daa0b7036b0ce9e067f4b5d upstream.

This patch (as1654) fixes a very old bug in ehci-hcd, connected with
scheduling of periodic split transfers.  The calculations for
full/low-speed bus usage are all carried out after the correction for
bit-stuffing has been applied, but the values in the max_tt_usecs
array assume it hasn't been.  The array should allow for allocation of
up to 90% of the bus capacity, which is 900 us, not 780 us.

The symptom caused by this bug is that any isochronous transfer to a
full-speed device with a maxpacket size larger than about 980 bytes is
always rejected with a -ENOSPC error.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/ehci-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index 33182c6..ccc9f70 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -236,7 +236,7 @@ static inline unsigned char tt_start_uframe(struct ehci_hcd *ehci, __hc32 mask)
 }
 
 static const unsigned char
-max_tt_usecs[] = { 125, 125, 125, 125, 125, 125, 30, 0 };
+max_tt_usecs[] = { 125, 125, 125, 125, 125, 125, 125, 25 };
 
 /* carryover low/fullspeed bandwidth that crosses uframe boundries */
 static inline void carryover_tt_bandwidth(unsigned short tt_usecs[8])
-- 
1.7.9.5

