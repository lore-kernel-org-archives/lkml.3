Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaBRXFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:05:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbaBRWq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lior Amsalem <alior@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.12 08/32] irqchip: armada-370-xp: fix IPI race condition
Date: Tue, 18 Feb 2014 14:47:08 -0800
Message-Id: <20140218224500.340953162@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224500.101465031@linuxfoundation.org>
References: <20140218224500.101465031@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lior Amsalem <alior@marvell.com>

commit a6f089e95b1e08cdea9633d50ad20aa5d44ba64d upstream.

In the Armada 370/XP driver, when we receive an IRQ 0, we read the
list of doorbells that caused the interrupt from register
ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS. This gives the list of IPIs that
were generated. However, instead of acknowledging only the IPIs that
were generated, we acknowledge *all* the IPIs, by writing
~IPI_DOORBELL_MASK in the ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS register.

This creates a race condition: if a new IPI that isn't part of the
ones read into the temporary "ipimask" variable is fired before we
acknowledge all IPIs, then we will simply loose it. This is causing
scheduling hangs on SMP intensive workloads.

It is important to mention that this ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS
register has the following behavior: "A CPU write of 0 clears the bits
in this field. A CPU write of 1 has no effect". This is what allows us
to simply write ~ipimask to acknoledge the handled IPIs.

Notice that the same problem is present in the MSI implementation, but
it will be fixed as a separate patch, so that this IPI fix can be
pushed to older stable versions as appropriate (all the way to 3.8),
while the MSI code only appeared in 3.13.

Signed-off-by: Lior Amsalem <alior@marvell.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Fixes: 344e873e5657e8dc0 'arm: mvebu: Add IPI support via doorbells'
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-armada-370-xp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -229,7 +229,7 @@ armada_370_xp_handle_irq(struct pt_regs
 						ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS)
 				& IPI_DOORBELL_MASK;
 
-			writel(~IPI_DOORBELL_MASK, per_cpu_int_base +
+			writel(~ipimask, per_cpu_int_base +
 				ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS);
 
 			/* Handle all pending doorbells */


