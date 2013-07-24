Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab3GXDeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:34:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:41094 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab3GXDeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:34:07 -0400
X-Spam-Score: -100.8
Message-ID: <51EF4AF0.1000509@asianux.com>
Date: Wed, 24 Jul 2013 11:33:04 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: sameo@linux.intel.com, lee.jones@linaro.org
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers: mfd: mfd-core: disable irq_domain related code when
 'HAVE_GENERIC_HARDIRQS' disabled.
References: <51EE3E20.1090101@asianux.com> <20130723104703.GB26775@osiris> <51EF1763.3020904@asianux.com>
In-Reply-To: <51EF1763.3020904@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'irq_domain' depends on hard irqs, so for the architectures which have
no hard irqs, but still need mfd (e.g. s390), need disable the related
code, or can not pass compiling.

The related commit:

  "c94bb23 mfd: Make MFD core code Device Tree and IRQ domain aware"

The related error: (with allmodconfig under s390)

  ERROR: "irq_create_mapping" [drivers/mfd/mfd-core.ko] undefined!


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/mfd/mfd-core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 7604f4e..8e56a74 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -129,13 +129,16 @@ static int mfd_add_device(struct device *parent, int id,
 			res[r].end = mem_base->start +
 				cell->resources[r].end;
 		} else if (cell->resources[r].flags & IORESOURCE_IRQ) {
+#ifdef HAVE_GENERIC_HARDIRQS
 			if (domain) {
 				/* Unable to create mappings for IRQ ranges. */
 				WARN_ON(cell->resources[r].start !=
 					cell->resources[r].end);
 				res[r].start = res[r].end = irq_create_mapping(
 					domain, cell->resources[r].start);
-			} else {
+			} else
+#endif
+			{
 				res[r].start = irq_base +
 					cell->resources[r].start;
 				res[r].end   = irq_base +
-- 
1.7.7.6
