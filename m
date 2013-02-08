Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763Ab3BHBGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:06:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab3BHA6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:58:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 18/26] USB: EHCI: fix bug in scheduling periodic split transfers
Date: Thu,  7 Feb 2013 16:57:46 -0800
Message-Id: <20130208004630.382017727@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.258272404@linuxfoundation.org>
References: <20130208004627.258272404@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/ehci-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -236,7 +236,7 @@ static inline unsigned char tt_start_ufr
 }
 
 static const unsigned char
-max_tt_usecs[] = { 125, 125, 125, 125, 125, 125, 30, 0 };
+max_tt_usecs[] = { 125, 125, 125, 125, 125, 125, 125, 25 };
 
 /* carryover low/fullspeed bandwidth that crosses uframe boundries */
 static inline void carryover_tt_bandwidth(unsigned short tt_usecs[8])


