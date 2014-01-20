Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaATTm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:42:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42796 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaATTmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:42:24 -0500
Date: Mon, 20 Jan 2014 19:42:16 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Scott Wood <scottwood@freescale.com>,
        Wang Dongsheng <dongsheng.wang@freescale.com>,
        Jia Hongtao <hongtao.jia@freescale.com>,
        Alexander Gordeev <agordeev@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] powerpc/mpic: Fix build errors for CONFIG_MPIC_WEIRD
Message-ID: <20140120194212.GA5684@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_MPIC_WEIRD is defined, the following build error occurs:

arch/powerpc/sysdev/mpic.c: In function 'mpic_set_irq_type':
arch/powerpc/sysdev/mpic.c:892:9: error: case label does not reduce to an integer constant
         MPIC_INFO(VECPRI_POLARITY_POSITIVE):
         ^
arch/powerpc/sysdev/mpic.c:896:9: error: case label does not reduce to an integer constant
         MPIC_INFO(VECPRI_POLARITY_NEGATIVE):
         ^
arch/powerpc/sysdev/mpic.c:900:9: error: case label does not reduce to an integer constant
         MPIC_INFO(VECPRI_POLARITY_POSITIVE):
         ^
arch/powerpc/sysdev/mpic.c:904:9: error: case label does not reduce to an integer constant
         MPIC_INFO(VECPRI_POLARITY_NEGATIVE):
         ^

This is because the case labels are built by accessing mpic->hw_set, and not an
integer constant.

Fixes: 446f6d06fab0 ("powerpc/mpic: Properly set default triggers")
Cc: <stable@vger.kernel.org> (3.4+)
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/sysdev/mpic.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 0e166ed..e7bf1a2 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -886,25 +886,21 @@ int mpic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 
 	/* Default: read HW settings */
 	if (flow_type == IRQ_TYPE_DEFAULT) {
-		switch(vold & (MPIC_INFO(VECPRI_POLARITY_MASK) |
-			       MPIC_INFO(VECPRI_SENSE_MASK))) {
-			case MPIC_INFO(VECPRI_SENSE_EDGE) |
-			     MPIC_INFO(VECPRI_POLARITY_POSITIVE):
-				flow_type = IRQ_TYPE_EDGE_RISING;
-				break;
-			case MPIC_INFO(VECPRI_SENSE_EDGE) |
-			     MPIC_INFO(VECPRI_POLARITY_NEGATIVE):
-				flow_type = IRQ_TYPE_EDGE_FALLING;
-				break;
-			case MPIC_INFO(VECPRI_SENSE_LEVEL) |
-			     MPIC_INFO(VECPRI_POLARITY_POSITIVE):
-				flow_type = IRQ_TYPE_LEVEL_HIGH;
-				break;
-			case MPIC_INFO(VECPRI_SENSE_LEVEL) |
-			     MPIC_INFO(VECPRI_POLARITY_NEGATIVE):
-				flow_type = IRQ_TYPE_LEVEL_LOW;
-				break;
-		}
+		unsigned int info;
+		info = vold & (MPIC_INFO(VECPRI_POLARITY_MASK) |
+			       MPIC_INFO(VECPRI_SENSE_MASK));
+		if (info == (MPIC_INFO(VECPRI_SENSE_EDGE) |
+			     MPIC_INFO(VECPRI_POLARITY_POSITIVE)))
+			flow_type = IRQ_TYPE_EDGE_RISING;
+		else if (info == (MPIC_INFO(VECPRI_SENSE_EDGE) |
+				  MPIC_INFO(VECPRI_POLARITY_NEGATIVE)))
+			flow_type = IRQ_TYPE_EDGE_FALLING;
+		else if (info == (MPIC_INFO(VECPRI_SENSE_LEVEL) |
+				  MPIC_INFO(VECPRI_POLARITY_POSITIVE)))
+			flow_type = IRQ_TYPE_LEVEL_HIGH;
+		else if (info == (MPIC_INFO(VECPRI_SENSE_LEVEL) |
+				  MPIC_INFO(VECPRI_POLARITY_NEGATIVE)))
+			flow_type = IRQ_TYPE_LEVEL_LOW;
 	}
 
 	/* Apply to irq desc */
-- 
1.8.3.2

Cheers,
--
Luis
