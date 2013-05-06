Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371Ab3EFUvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:51:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab3EFUrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:47:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 098/115] e1000e: fix numeric overflow in phc settime method
Date: Mon,  6 May 2013 13:45:34 -0700
Message-Id: <20130506203105.658820364@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Cochran <richardcochran@gmail.com>

commit 73e3dd6b45c4c870fc2641eb04c24e3f12dab1e0 upstream.

The PTP Hardware Clock settime function in the e1000e driver
computes nanoseconds from a struct timespec. The code converts the
seconds field .tv_sec by multiplying it with NSEC_PER_SEC. However,
both operands are of type long, resulting in an unintended overflow.
The patch fixes the issue by using the helper function from time.h.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/ptp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -145,8 +145,7 @@ static int e1000e_phc_settime(struct ptp
 	unsigned long flags;
 	u64 ns;
 
-	ns = ts->tv_sec * NSEC_PER_SEC;
-	ns += ts->tv_nsec;
+	ns = timespec_to_ns(ts);
 
 	/* reset the timecounter */
 	spin_lock_irqsave(&adapter->systim_lock, flags);


