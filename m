Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab3BLUft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:35:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab3BLUfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 15/61] mfd: db8500-prcmu: Fix irqdomain usage
Date: Tue, 12 Feb 2013 12:34:35 -0800
Message-Id: <20130212203420.282048679@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit 89d9b1c99374997d68910ba49d5b7df80e7f2061 upstream.

This fixes two issues with the DB8500 PRCMU irqdomain:
- You have to state the irq base 0 to get a linear domain
  for the DT case from irq_domain_add_simple()
- The irqdomain was not used to translate the initial irq
  request using irq_create_mapping() making the linear
  case fail as it was lacking a proper descriptor.

I took this opportunity to fix two lines of whitespace
errors in related code as I was anyway messing around with
it.

Acked-by Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/db8500-prcmu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2478,7 +2478,7 @@ static bool read_mailbox_0(void)
 
 		for (n = 0; n < NUM_PRCMU_WAKEUPS; n++) {
 			if (ev & prcmu_irq_bit[n])
-				generic_handle_irq(IRQ_PRCMU_BASE + n);
+				generic_handle_irq(irq_find_mapping(db8500_irq_domain, n));
 		}
 		r = true;
 		break;
@@ -2706,6 +2706,10 @@ static int db8500_irq_init(struct device
 		return -ENOSYS;
 	}
 
+	/* All wakeups will be used, so create mappings for all */
+	for (i = 0; i < NUM_PRCMU_WAKEUPS; i++)
+		irq_create_mapping(db8500_irq_domain, i);
+
 	return 0;
 }
 


