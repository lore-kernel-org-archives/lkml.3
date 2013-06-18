Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab3FRLoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:44:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55922 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab3FRLoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Tim Richardson <tim@tim-richardson.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 10/93] USB: revert periodic scheduling bugfix
Date: Tue, 18 Jun 2013 12:42:18 +0100
Message-Id: <1371555821-12820-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit fdc03438f53a00294ed9939eb3a1f6db6f3d8963 upstream.

This patch reverts commit 3e619d04159be54b3daa0b7036b0ce9e067f4b5d
(USB: EHCI: fix bug in scheduling periodic split transfers).  The
commit was valid -- it fixed a real bug -- but the periodic scheduler
in ehci-hcd is in such bad shape (especially the part that handles
split transactions) that fixing one bug is very likely to cause
another to surface.  That's what happened in this case; the result was
choppy and noisy playback on certain 24-bit audio devices.

The only real fix will be to rewrite this entire section of code.  My
next project...

This fixes https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1136110.

Thanks to Tim Richardson for extra testing and feedback, and to Joseph
Salisbury and Tyson Tan for tracking down the original source of the
problem.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Joseph Salisbury <joseph.salisbury@canonical.com>
CC: Tim Richardson <tim@tim-richardson.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/ehci-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index ccc9f70..33182c6 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -236,7 +236,7 @@ static inline unsigned char tt_start_uframe(struct ehci_hcd *ehci, __hc32 mask)
 }
 
 static const unsigned char
-max_tt_usecs[] = { 125, 125, 125, 125, 125, 125, 125, 25 };
+max_tt_usecs[] = { 125, 125, 125, 125, 125, 125, 30, 0 };
 
 /* carryover low/fullspeed bandwidth that crosses uframe boundries */
 static inline void carryover_tt_bandwidth(unsigned short tt_usecs[8])
-- 
1.8.1.2

