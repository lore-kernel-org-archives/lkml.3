Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3FKUC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:02:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124Ab3FKUCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:02:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Tim Richardson <tim@tim-richardson.net>
Subject: [ 09/21] USB: revert periodic scheduling bugfix
Date: Tue, 11 Jun 2013 13:03:03 -0700
Message-Id: <20130611195521.110829029@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195520.003233586@linuxfoundation.org>
References: <20130611195520.003233586@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/ehci-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -236,7 +236,7 @@ static inline unsigned char tt_start_ufr
 }
 
 static const unsigned char
-max_tt_usecs[] = { 125, 125, 125, 125, 125, 125, 125, 25 };
+max_tt_usecs[] = { 125, 125, 125, 125, 125, 125, 30, 0 };
 
 /* carryover low/fullspeed bandwidth that crosses uframe boundries */
 static inline void carryover_tt_bandwidth(unsigned short tt_usecs[8])


