Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab3FPWVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:21:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46474 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755767Ab3FPWI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Joseph Salisbury" <joseph.salisbury@canonical.com>,
        "Tim Richardson" <tim@tim-richardson.net>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.466638801@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [38/83] USB: revert periodic scheduling bugfix
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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

