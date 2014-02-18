Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbaBRXBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:01:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbaBRWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lior Amsalem <alior@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.13 10/40] irqchip: armada-370-xp: fix MSI race condition
Date: Tue, 18 Feb 2014 14:47:11 -0800
Message-Id: <20140218224433.626357511@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224433.337299968@linuxfoundation.org>
References: <20140218224433.337299968@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lior Amsalem <alior@marvell.com>

commit c7f7bd4a136e4b02dd2a66bf95aec545bd93e8db upstream.

In the Armada 370/XP driver, when we receive an IRQ 1, we read the
list of doorbells that caused the interrupt from register
ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS. This gives the list of MSIs that
were generated. However, instead of acknowledging only the MSIs that
were generated, we acknowledge *all* the MSIs, by writing
~MSI_DOORBELL_MASK in the ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS register.

This creates a race condition: if a new MSI that isn't part of the
ones read into the temporary "msimask" variable is fired before we
acknowledge all MSIs, then we will simply loose it.

It is important to mention that this ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS
register has the following behavior: "A CPU write of 0 clears the bits
in this field. A CPU write of 1 has no effect". This is what allows us
to simply write ~msimask to acknoledge the handled MSIs.

Notice that the same problem is present in the IPI implementation, but
it is fixed as a separate patch, so that this IPI fix can be pushed to
older stable versions as appropriate (all the way to 3.8), while the
MSI code only appeared in 3.13.

Signed-off-by: Lior Amsalem <alior@marvell.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-armada-370-xp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -381,7 +381,7 @@ armada_370_xp_handle_irq(struct pt_regs
 						ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS)
 				& PCI_MSI_DOORBELL_MASK;
 
-			writel(~PCI_MSI_DOORBELL_MASK, per_cpu_int_base +
+			writel(~msimask, per_cpu_int_base +
 			       ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS);
 
 			for (msinr = PCI_MSI_DOORBELL_START;


